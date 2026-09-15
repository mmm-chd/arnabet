import 'dart:async';

import 'package:arena/components/bottom_sheet/custom_bottom_sheet_v2.dart';
import 'package:arena/components/current_user_avatar.dart';
import 'package:arena/components/custom_filter_chip.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/dialog/custom_dialog.dart';
import 'package:arena/components/header/header_search.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/enums/role.dart';
import 'package:arena/models/product/product_list_model.dart';
import 'package:arena/pages/product/components/edit_size_sheet.dart';
import 'package:arena/utils/app_secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'bloc/product_list_bloc.dart';
import 'bloc/product_list_state.dart';
import 'bloc/product_list_event.dart';
import 'package:arena/pages/product/components/product_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'components/product_bottom_sheet.dart';
import 'components/product_card.dart';
import 'package:arena/utils/nav_drawer.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ScrollController _scrollController = ScrollController();
  Timer? _searchDebounce;

  List<int> selectedIndexes = [];

  List<Map<String, dynamic>> items = [];

  bool get isSelectionMode => selectedIndexes.isNotEmpty;

  Role? _userRole;

  void toggleSelection(int index) {
    setState(() {
      final isWarehouse = _userRole == Role.warehouseStaff;

      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        if (isWarehouse) {
          selectedIndexes
            ..clear()
            ..add(index);
        } else {
          selectedIndexes.add(index);
        }
      }
    });
  }

  void deleteSelected() {
    for (var i = 0; i < selectedIndexes.length; i++) {
      final productId = context
          .read<ProductListBloc>()
          .state
          .products
          .first
          .models
          .first
          .variants[selectedIndexes[i]]
          .productId;
      context.read<ProductListBloc>().add(DeleteProduct(productId));
    }
    selectedIndexes.clear();
    context.read<ProductListBloc>().add(const LoadProducts());
  }

  Future<void> _loadRole() async {
    final raw = await AppSecureStorage.read(key: "user_role");
    final role = Role.fromString(raw);
    if (mounted) {
      setState(() {
        _userRole = role;
      });
    }
  }

  void onPressedMoreOptions() {
    CustomBottomSheetV2.show(
      context,
      title: 'Opsi Lainnya',
      children: [
        if (selectedIndexes.length == 1) ...[
          ListTile(
            leading: SvgPicture.asset(
              CustomIcons.edit,
              width: 32,
              height: 32,
              color: SupportAppColors.greyDarkerColor,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const CustomText(text: "Edit produk"),
            onTap: () async {
              context.pop();

              if (selectedIndexes.isEmpty) return;

              if (selectedIndexes.length == 1) {
                final ProductListDatum brand =
                    items[selectedIndexes.first]["brand"];

                final ProductModel product =
                    items[selectedIndexes.first]["model"];

                ProductSheet.show(context, product: product, brand: brand);
                setState(() {});
              }
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              CustomIcons.radix,
              color: SupportAppColors.greyDarkerColor,
            ),
            title: const CustomText(text: "Edit ukuran"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onTap: () {
              context.pop();

              if (selectedIndexes.length != 1) return;

              final ProductModel product =
                  items[selectedIndexes.first]["model"];
              final ProductListDatum brand =
                  items[selectedIndexes.first]["brand"];

              EditSizeSheet.show(
                context,
                product: product,
                brand: brand,
                isOwner: _userRole == Role.owner,
              );
              setState(() {});
            },
          ),
        ],

        if (_userRole == Role.owner && selectedIndexes.isNotEmpty) ...[
          ListTile(
            leading: SvgPicture.asset(CustomIcons.x, color: AppColors.error),
            title: const CustomText(
              text: "Hapus produk",
              style: TextStyle(color: AppColors.error),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onTap: () {
              context.pop();

              if (selectedIndexes.isEmpty) return;

              CustomDialog.confirmDelete(
                context,
                title: "Hapus Produk",
                message: "Yakin ingin menghapus produk ini?",
                onPressed: () {
                  final product =
                      items[selectedIndexes.first]["model"] as ProductModel;

                  context.read<ProductListBloc>().add(
                    DeleteProduct(product.variants.first.productId),
                  );

                  setState(() {
                    selectedIndexes.clear();
                  });

                  return true;
                },
              );
            },
          ),
        ],
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _loadRole();
    context.read<ProductListBloc>().add(const LoadProducts());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<ProductListBloc>().add(const LoadMoreProducts());
      }
    });
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      context.read<ProductListBloc>().add(SearchProducts(value));
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        floatingActionButton: isSelectionMode
            ? null
            : FloatingActionButton(
                backgroundColor: AppColors.primary,
                onPressed: () async {
                  ProductBottomSheet.show(context, _userRole == Role.owner);
                },
                child: const Icon(Icons.add),
              ),
        body: SafeArea(
          top: false,
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                selectedIndexes.clear();
              });
              context.read<ProductListBloc>().add(const LoadProducts());
              await Future.delayed(const Duration(milliseconds: 300));
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  elevation: 0,
                  backgroundColor: AppColors.bgColor,
                  surfaceTintColor: AppColors.bgColor,
                  floating: true,
                  snap: true,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  expandedHeight: 130,
                  leadingWidth: 72,
                  leading: isSelectionMode
                      ? Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: CustomIconbuttonCircle(
                            prefixIcon: Icons.close,
                            backgroundColor: SupportAppColors.white,
                            iconColor: SupportAppColors.greyDarkerColor,
                            iconSize: 24,
                            width: 40,
                            height: 40,
                            onPressed: () {
                              setState(() {
                                selectedIndexes.clear();
                              });
                            },
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: CustomIconbuttonCircle(
                            prefixIcon: Icons.menu,
                            backgroundColor: SupportAppColors.white,
                            iconColor: SupportAppColors.greyDarkerColor,
                            iconSize: 24,
                            width: 40,
                            height: 40,
                            onPressed: () {
                              openNavDrawer(context);
                            },
                          ),
                        ),
                  titleSpacing: 16,
                  title: CustomText(
                    text: isSelectionMode
                        ? "${selectedIndexes.length} dipilih"
                        : "Produk",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  actionsPadding: const EdgeInsets.only(right: 16),
                  actions: [
                    isSelectionMode
                        ? CustomIconbuttonCircle(
                            prefixIcon: Icons.more_vert,
                            backgroundColor: SupportAppColors.white,
                            iconColor: SupportAppColors.greyDarkerColor,
                            iconSize: 24,
                            width: 60,
                            height: 60,
                            onPressed: onPressedMoreOptions,
                          )
                        : InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              context.push(AppRoutes.profile);
                            },
                            child: const CurrentUserAvatar(),
                          ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(63),
                    child: HeaderSearch(
                      useFilter: false,
                      onChanged: _onSearchChanged,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: CustomSpacing(height: 8)),

                BlocBuilder<ProductListBloc, ProductListState>(
                  buildWhen: (prev, curr) =>
                      prev.brandNames != curr.brandNames ||
                      prev.selectedBrand != curr.selectedBrand,
                  builder: (context, state) {
                    if (state.brandNames.isEmpty) {
                      return const SliverToBoxAdapter(child: SizedBox.shrink());
                    }

                    final selected = state.selectedBrand;

                    return SliverToBoxAdapter(
                      child: SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            CustomFilterChip(
                              label: 'Semua',
                              isSelected: selected == null,
                              onTap: () => context.read<ProductListBloc>().add(
                                const FilterByBrand(null),
                              ),
                            ),
                            const CustomSpacing(width: 8),
                            ...state.brandNames.asMap().entries.map((entry) {
                              final brand = entry.value;
                              final isLast =
                                  entry.key == state.brandNames.length - 1;
                              return Padding(
                                padding: EdgeInsets.only(right: isLast ? 0 : 8),
                                child: CustomFilterChip(
                                  label: brand,
                                  isSelected: selected == brand,
                                  onTap: () => context
                                      .read<ProductListBloc>()
                                      .add(FilterByBrand(brand)),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SliverToBoxAdapter(child: CustomSpacing(height: 16)),

                BlocConsumer<ProductListBloc, ProductListState>(
                  listener: (context, state) {
                    if (state.errorMessage != null &&
                        state.errorMessage!.isNotEmpty) {
                      AppSnackBar.warning(
                        context: context,
                        message: state.errorMessage ?? "Tidak diketahui",
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state.status == ProductStatus.loading) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    items.clear();

                    for (final brand in state.products) {
                      for (final model in brand.models) {
                        items.add({"brand": brand, "model": model});
                      }
                    }

                    if (items.isEmpty) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: CustomText(text: "Tidak ada produk"),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final ProductListDatum brand = items[index]["brand"];
                          final ProductModel model = items[index]["model"];
                          return ProductCard(
                            brand: brand,
                            model: model,
                            isSelected: selectedIndexes.contains(index),
                            selectionMode: isSelectionMode,
                            onTap: () {
                              if (isSelectionMode) {
                                toggleSelection(index);
                              }
                            },
                            onLongPress: () {
                              toggleSelection(index);
                            },
                          );
                        },
                      ),
                    );
                  },
                ),

                const SliverToBoxAdapter(child: CustomSpacing(height: 80)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
