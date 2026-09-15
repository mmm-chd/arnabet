import 'package:arena/components/bottom_sheet/custom_bottom_sheet.dart';
import 'package:arena/components/bottom_sheet/custom_bottom_sheet_v2.dart';
import 'package:arena/components/current_user_avatar.dart';
import 'package:arena/components/dialog/custom_dialog.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/header/header_search.dart';
import 'package:arena/components/text_field/custom_text_field.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/brand/brand_list_model.dart';
import 'package:arena/models/enums/role.dart';
import 'package:arena/pages/brand/bloc/brand_bloc.dart';
import 'package:arena/pages/brand/bloc/brand_event.dart';
import 'package:arena/pages/brand/bloc/brand_state.dart';
import 'package:arena/pages/brand/components/brand_card.dart';
import 'package:arena/utils/app_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:arena/utils/nav_drawer.dart';

class BrandListPage extends StatefulWidget {
  const BrandListPage({super.key});

  @override
  State<BrandListPage> createState() => _BrandListPageState();
}

class _BrandListPageState extends State<BrandListPage> {
  Role? _userRole;
  late final ScrollController _scrollController;

  List<int> selectedIndexes = [];

  bool get isSelectionMode => selectedIndexes.isNotEmpty;

  Future<void> _loadRole() async {
    final raw = await AppSecureStorage.read(key: "user_role");
    final role = Role.fromString(raw);

    setState(() {
      _userRole = role;
    });
  }

  void toggleSelection(int index) {
    if (_userRole != Role.owner) return;

    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        selectedIndexes.add(index);
      }
    });
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
            title: const CustomText(text: "Edit brand"),
            onTap: () {
              context.pop();

              if (selectedIndexes.length != 1) return;

              final brand = _brandAtIndex(selectedIndexes.first);
              if (brand == null) return;

              _showBottomSheetEditBrand(brand.id ?? 0, brand.name ?? "");
              setState(() {});
            },
          ),
        ],

        if (_userRole == Role.owner && selectedIndexes.isNotEmpty) ...[
          ListTile(
            leading: SvgPicture.asset(CustomIcons.x, color: AppColors.error),
            title: const CustomText(
              text: "Hapus brand",
              style: TextStyle(color: AppColors.error),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onTap: () {
              context.pop();

              if (selectedIndexes.isEmpty) return;

              final brand = _brandAtIndex(selectedIndexes.first);
              if (brand == null) return;

              CustomDialog.confirmDelete(
                context,
                title: "Hapus Brand",
                message: "Yakin ingin menghapus brand ${brand.displayName}?",
                onPressed: () {
                  context.read<BrandBloc>().add(DeleteBrand(id: brand.id ?? 0));

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

  BrandListDatum? _brandAtIndex(int index) {
    final state = context.read<BrandBloc>().state;
    if (index < 0 || index >= state.brands.length) return null;
    return state.brands[index];
  }

  void _showBottomSheetEditBrand(int id, String name) {
    final controller = TextEditingController(text: name);
    CustomBottomsheet.show(
      context,
      title: "Edit Brand",
      initialChildSize: 0.45,
      onDismissed: () {},
      primaryButtonText: "Simpan",
      pBackgroundColor: AppColors.primary,
      onPressed: () {
        if (controller.text.trim().isNotEmpty) {
          context.read<BrandBloc>().add(
            UpdateBrand(id: id, name: controller.text),
          );
          Navigator.pop(context);
        }
      },
      children: [
        CustomTextField(
          controller: controller,
          label: "Nama Brand",
          hint: "Masukkan nama brand",
        ),
      ],
    );
  }

  void _showBottomSheetAddBrand() {
    final controller = TextEditingController();
    CustomBottomsheet.show(
      context,
      title: "Tambah Brand",
      initialChildSize: 0.45,
      onDismissed: () {},
      primaryButtonText: "Simpan",
      pBackgroundColor: AppColors.primary,
      onPressed: () {
        if (controller.text.trim().isNotEmpty) {
          context.read<BrandBloc>().add(AddBrand(name: controller.text));
          Navigator.pop(context);
        }
      },
      children: [
        CustomTextField(
          controller: controller,
          label: "Nama Brand",
          hint: "Masukkan nama brand",
        ),
      ],
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<BrandBloc>().add(const LoadMoreBrands());
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRole();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<BrandBloc>().add(const LoadBrands());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      floatingActionButton: isSelectionMode
          ? null
          : FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () {
                _showBottomSheetAddBrand();
              },
              child: const Icon(Icons.add),
            ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<BrandBloc>().add(const LoadBrands());
            await context.read<BrandBloc>().stream.firstWhere(
              (state) => state.status == BrandStatus.ready,
            );
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
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: isSelectionMode
                      ? CustomIconbuttonCircle(
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
                        )
                      : CustomIconbuttonCircle(
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
                      : "Brand",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                actionsPadding: const EdgeInsets.only(right: 16),
                actions: [
                  if (isSelectionMode)
                    CustomIconbuttonCircle(
                      prefixIcon: Icons.more_vert,
                      backgroundColor: SupportAppColors.white,
                      iconColor: SupportAppColors.greyDarkerColor,
                      iconSize: 24,
                      width: 60,
                      height: 60,
                      onPressed: onPressedMoreOptions,
                    )
                  else
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () => context.push(AppRoutes.profile),
                      child: const CurrentUserAvatar(),
                    ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(63),
                  child: HeaderSearch(
                    onChanged: (value) {
                      context.read<BrandBloc>().add(SearchBrand(value));
                    },
                  ),
                ),
              ),
              BlocConsumer<BrandBloc, BrandState>(
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
                  if (state.isLoading || state.isInitial) {
                    return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state.isFailure) {
                    return SliverFillRemaining(
                      child: Center(
                        child: CustomText(
                          text: state.errorMessage ?? "Terjadi kesalahan",
                        ),
                      ),
                    );
                  }
                  if (state.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(child: CustomText(text: "Tidak ada brand")),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList.builder(
                      itemCount:
                          state.brands.length + (state.hasReachedMax ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index >= state.brands.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final brand = state.brands[index];
                        return BrandCard(
                          brand: brand,
                          isSelected: selectedIndexes.contains(index),
                          selectionMode: isSelectionMode,
                          onTap: () {
                            if (isSelectionMode) {
                              toggleSelection(index);
                            }
                          },
                          onLongPress: () => toggleSelection(index),
                        );
                      },
                    ),
                  );
                },
              ),
              const SliverToBoxAdapter(child: CustomSpacing(height: 88)),
            ],
          ),
        ),
      ),
    );
  }
}
