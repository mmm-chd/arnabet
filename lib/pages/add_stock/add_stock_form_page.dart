import 'dart:async';

import 'package:arena/components/build/build_label.dart';
import 'package:arena/components/build/build_searchable_dropdown.dart';
import 'package:arena/components/bottom_sheet/custom_bottom_sheet_fix.dart';
import 'package:arena/components/custom_button.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/text_field/custom_text_field.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/dot_model.dart';
import 'package:arena/models/enums/role.dart';
import 'package:arena/pages/add_stock/bloc/add_stock_bloc.dart';
import 'package:arena/pages/add_stock/bloc/add_stock_event.dart';
import 'package:arena/pages/add_stock/bloc/add_stock_state.dart';
import 'package:arena/pages/stock_list/bloc/stock_bloc.dart';
import 'package:arena/pages/stock_list/bloc/stock_event.dart';
import 'package:arena/config/routes/nav_routes.dart';
import 'package:arena/utils/app_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../models/tire_model.dart';
import '../../components/custom_card_box.dart';
import 'components/dot_form_item.dart';

class AddStockFormPage extends StatefulWidget {
  final TireModel tire;

  final Map<String, dynamic>? existingData;

  const AddStockFormPage({super.key, required this.tire, this.existingData});

  @override
  State<AddStockFormPage> createState() => _AddStockFormPageState();
}

class _AddStockFormPageState extends State<AddStockFormPage> {
  final TextEditingController noteController = TextEditingController();
  Role _userRole = Role.unknown;
  StreamSubscription? _existingDataSubscription;

  bool get _isEditMode => widget.existingData != null;

  Future<void> _loadRole() async {
    final raw = await AppSecureStorage.read(key: "user_role");
    final role = Role.fromString(raw);
    if (mounted) {
      setState(() {
        _userRole = role;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRole();
    context.read<AddStockBloc>().add(LoadProductNames());

    if (_isEditMode) {
      _existingDataSubscription = context.read<AddStockBloc>().stream.listen((
        state,
      ) {
        if (state.status == AddStockStatus.ready &&
            state.productNames.isNotEmpty) {
          _existingDataSubscription?.cancel();
          final data = widget.existingData!;
          context.read<AddStockBloc>().add(
            LoadExistingStock(
              productName: data['productName'] as String? ?? '',
              size: data['size'] as String? ?? '',
              ring: data['ring'] as String? ?? '',
              note: data['note'] as String? ?? '',
              dots: (data['dots'] as List<DotModel>?) ?? [],
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _existingDataSubscription?.cancel();
    noteController.dispose();
    super.dispose();
  }

  void _addDot() async {
    final result = await context.push<DotModel>(
      AppRoutes.addDot,
      extra: widget.tire,
    );

    if (result != null) {
      context.read<AddStockBloc>().add(DotAdded(result));
    }
  }

  void _showExitConfirmationDialog() {
    CustomBottomsheetfix.show(
      context,
      hideHeader: true,
      initialChildSize: 0.35,
      onDismissed: () {},
      onPressed: () {
        context.read<AddStockBloc>().add(DiscardCurrentItem());
        Future.microtask(() {
          if (context.mounted) context.pop();
        });
        return true;
      },
      onReset: () {
        Future.microtask(() {
          if (context.mounted) context.pop();
        });
      },
      primaryButtonText: 'Ya, Keluar',
      secondaryButtonText: 'Batal',
      pBackgroundColor: AppColors.primary,
      sBorderColor: Colors.grey.shade300,
      sForegroundColor: Colors.grey.shade600,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomText(
              text: "Batalkan Pengisian?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const CustomSpacing(height: 12),
            CustomText(
              text:
                  "Data yang telah Anda isi akan hilang dan tidak dapat dikembalikan.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const CustomSpacing(height: 16),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddStockBloc, AddStockState>(
      listener: (context, state) {
        if (state.status == AddStockStatus.success) {
          context.read<StockBloc>().add(LoadStock());

          AppSnackBar.success(
            message: "Stok berhasil ditambahkan",
            context: context,
          );
          if (context.canPop()) {
            Future.microtask(() {
              if (context.mounted) context.pop();
            });
          } else {
            context.go(NavRoutes.getStockListRoute(_userRole));
          }
        } else if (state.status == AddStockStatus.failure) {
          AppSnackBar.error(
            message: state.errorMessage ?? "",
            context: context,
          );
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;

            if (state.isFormDirty) {
              _showExitConfirmationDialog();
            } else {
              context.read<AddStockBloc>().add(DiscardCurrentItem());
              Future.microtask(() {
                if (context.mounted) context.pop();
              });
            }
          },
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              backgroundColor: AppColors.bgColor,
              appBar: AppBar(
                backgroundColor: AppColors.bgColor,
                surfaceTintColor: AppColors.bgColor,
                automaticallyImplyLeading: false,
                leadingWidth: 72,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: CustomIconbuttonCircle(
                    prefixIcon: Icons.arrow_back,
                    backgroundColor: SupportAppColors.white,
                    iconColor: Colors.black,
                    iconSize: 24,
                    width: 40,
                    height: 40,
                    onPressed: () {
                      if (state.isFormDirty) {
                        _showExitConfirmationDialog();
                      } else {
                        context.read<AddStockBloc>().add(DiscardCurrentItem());
                        Future.microtask(() {
                          if (context.mounted) context.pop();
                        });
                      }
                    },
                  ),
                ),
                titleSpacing: 16,
                title: CustomText(
                  text: _isEditMode ? "Edit Stok" : "Tambah Stok",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    /// INFORMASI BAN
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: SupportAppColors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          BlocBuilder<AddStockBloc, AddStockState>(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const BuildLabel(
                                    text: "Nama Produk",
                                    isRequired: true,
                                  ),
                                  const CustomSpacing(height: 8),
                                  BuildSearchableDropdown(
                                    hint: "Pilih nama produk",
                                    value: state.selectedProductName.isEmpty
                                        ? null
                                        : state.productNames.firstWhere(
                                            (e) =>
                                                e.name ==
                                                state.selectedProductName,
                                            orElse: () =>
                                                state.productNames.first,
                                          ),
                                    items: state.productNames,
                                    onChanged: (value) {
                                      context.read<AddStockBloc>().add(
                                        ProductSelected(value!.name),
                                      );
                                    },
                                    onSearch: (query) {
                                      context.read<AddStockBloc>().add(
                                        SearchProductNames(query),
                                      );
                                    },
                                    isLoading:
                                        state.isLoading ||
                                        state.isLoadingMoreProductNames,
                                    onLoadMore: () {
                                      context.read<AddStockBloc>().add(
                                        LoadMoreProductNames(),
                                      );
                                    },
                                    hasMore:
                                        state.productNamePage <
                                        state.productNameTotalPages,
                                  ),
                                ],
                              );
                            },
                          ),
                          const CustomSpacing(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const BuildLabel(
                                      text: "Ukuran",
                                      isRequired: true,
                                    ),
                                    const CustomSpacing(height: 8),
                                    BuildSearchableDropdown(
                                      hint: "Ukuran...",
                                      value:
                                          state.selectedSize.isEmpty ||
                                              state.productSize.isEmpty
                                          ? null
                                          : state.productSize.firstWhere(
                                              (e) =>
                                                  e.name == state.selectedSize,
                                              orElse: () =>
                                                  state.productSize.first,
                                            ),
                                      items: state.productSize,
                                      onChanged: (value) {
                                        context.read<AddStockBloc>().add(
                                          SizeSelected(value!.name),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const CustomSpacing(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BuildLabel(text: "Ring", isRequired: true),
                                    const CustomSpacing(height: 8),
                                    BuildSearchableDropdown(
                                      hint: "Ring...",
                                      value:
                                          state.selectedRing.isEmpty ||
                                              state.productRing.isEmpty
                                          ? null
                                          : state.productRing.firstWhere(
                                              (e) =>
                                                  e.name == state.selectedRing,
                                              orElse: () =>
                                                  state.productRing.first,
                                            ),
                                      items: state.productRing,
                                      onChanged: (value) {
                                        context.read<AddStockBloc>().add(
                                          RingSelected(value!.name),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const CustomSpacing(height: 16),

                    /// KODE DOT
                    CustomCardBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const BuildLabel(
                                text: "Kode DOT",
                                isRequired: true,
                              ),
                              CustomText(text: "${state.totalPcs} pcs"),
                            ],
                          ),
                          const CustomSpacing(height: 10),

                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.dots.length,
                            itemBuilder: (context, index) {
                              final dot = state.dots[index];
                              return DotFormItem(
                                dot: dot,
                                showPrices: _userRole == Role.owner,
                                onIncrement: () {
                                  context.read<AddStockBloc>().add(
                                    DotUpdated(
                                      index,
                                      dot.copyWith(jumlah: dot.jumlah + 1),
                                    ),
                                  );
                                },
                                onDecrement: () {
                                  if (dot.jumlah > 1) {
                                    context.read<AddStockBloc>().add(
                                      DotUpdated(
                                        index,
                                        dot.copyWith(jumlah: dot.jumlah - 1),
                                      ),
                                    );
                                  } else {
                                    context.read<AddStockBloc>().add(
                                      DotRemoved(index),
                                    );
                                  }
                                },
                              );
                            },
                          ),

                          const CustomSpacing(height: 6),
                          if (!_isEditMode)
                            CustomButton(
                              height: 0,
                              text: 'Tambah',
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                side: BorderSide(
                                  color: AppColors.primary,
                                  width: 0.5,
                                ),
                              ),
                              elevation: 0,
                              foregroundColor: AppColors.primary,
                              fontSize: 16,
                              onPressed: _addDot,
                            ),
                        ],
                      ),
                    ),

                    const CustomSpacing(height: 16),

                    /// CATATAN
                    CustomCardBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BuildLabel(
                            text: "Catatan",
                            isOptional: _isEditMode ? false : true,
                            isRequired: _isEditMode ? true : false,
                          ),
                          const CustomSpacing(height: 10),
                          CustomTextField(
                            controller: noteController,
                            label: "Masukkan Catatan...",
                            hint: "Masukkan Catatan...",
                            filled: true,
                            alignLabelWithHint: true,
                            maxLines: 5,
                          ),
                        ],
                      ),
                    ),

                    const CustomSpacing(height: 16),

                    CustomCardBox(
                      child: Column(
                        children: [
                          if (_userRole == Role.owner) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: "Total Harga Beli",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                CustomText(
                                  text: state.displayTotalHargaBeli,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const CustomSpacing(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: "Total Harga Jual",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                CustomText(
                                  text: state.displayTotalHargaJual,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),

                            const CustomSpacing(height: 16),
                          ],

                          CustomButton(
                            text: _isEditMode ? "Simpan" : "Tambah Stok",
                            backgroundColor: AppColors.primary,
                            foregroundColor: SupportAppColors.white,
                            onPressed: state.isFormFilled
                                ? () {
                                    context.read<AddStockBloc>().add(
                                      SaveStockItem(),
                                    );
                                    context.pop();
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
