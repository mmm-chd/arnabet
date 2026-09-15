import 'dart:async';

import 'package:arena/components/bottom_sheet/custom_bottom_sheet_v2.dart';
import 'package:arena/components/build/build_label.dart';
import 'package:arena/components/build/build_searchable_dropdown.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/text_field/custom_text_field.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/currency_input_formatter.dart';
import 'package:arena/helper/size_input_formatter.dart';
import 'package:arena/models/metadata/dropdown_item_model.dart';
import 'package:arena/models/product/product_list_model.dart';
import 'package:arena/pages/product/components/add_size_sheet/add_size_sheet_controller.dart';
import 'package:arena/pages/product/components/add_size_sheet/size_row_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/product_list_bloc.dart';
import '../../bloc/product_list_event.dart';
import '../../bloc/product_list_state.dart';

class AddSizeSheet extends StatefulWidget {
  final AddSizeSheetController controller;
  final bool isOwner;

  const AddSizeSheet({
    super.key,
    required this.controller,
    required this.isOwner,
  });

  static String? _resolveProductId(ProductModel product) {
    if (product.variants.isNotEmpty) return product.variants.first.productId;
    return product.productId;
  }

  static void show(BuildContext context, {required bool isOwner}) {
    final productListBloc = context.read<ProductListBloc>();
    final controller = AddSizeSheetController(requirePrice: isOwner);
    CustomBottomSheetV2.show(
      context,
      title: 'Tambah ukuran',
      isScrollable: true,
      isSaveEnabled: controller.canSave,
      onSave: () {
        final selectedProduct = controller.selectedProduct.value;
        final rows = controller.rows.value;

        if (selectedProduct == null) {
          AppSnackBar.warning(
            context: context,
            message: "Pilih produk terlebih dahulu",
          );
          return false;
        }

        if (rows.isEmpty || rows.any((row) => !row.isValid)) {
          controller.showErrors.value = true;

          AppSnackBar.warning(
            context: context,
            message: "Lengkapi semua baris ukuran terlebih dahulu",
          );

          final errorContext =
              controller.firstInvalidRow?.rowKey.currentContext;
          if (errorContext != null) {
            Scrollable.ensureVisible(
              errorContext,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }

          return false;
        }

        final productId = _resolveProductId(selectedProduct);

        if (productId == null) {
          AppSnackBar.warning(
            context: context,
            message: "Produk tidak memiliki ID",
          );
          return false;
        }

        productListBloc.add(
          CreateVariants(productId, [for (final row in rows) row.toRequest()]),
        );

        Future.delayed(const Duration(milliseconds: 300), controller.dispose);

        return true;
      },
      onDismissed: controller.dispose,
      children: [
        BlocProvider.value(
          value: productListBloc,
          child: AddSizeSheet(controller: controller, isOwner: isOwner),
        ),
      ],
    );
  }

  @override
  State<AddSizeSheet> createState() => _AddSizeSheetState();
}

class _AddSizeSheetState extends State<AddSizeSheet> {
  AddSizeSheetController get controller => widget.controller;

  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onProductSearch(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      context.read<ProductListBloc>().add(SearchProducts(query));
    });
  }

  void _addRow() {
    final row = controller.addRow();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rowContext = row.rowKey.currentContext;
      if (rowContext != null) {
        Scrollable.ensureVisible(
          rowContext,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
        );
      }
      row.sizeFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildLabel(text: "Produk", isRequired: true),
        const CustomSpacing(height: 10),
        _buildProductDropdown(),
        const CustomSpacing(height: 20),
        ValueListenableBuilder<List<SizeRowData>>(
          valueListenable: controller.rows,
          builder: (context, rows, _) {
            if (rows.isEmpty) return _buildEmptyState();

            return Column(
              children: [
                for (var i = 0; i < rows.length; i++) _buildRow(rows[i], i),
              ],
            );
          },
        ),
        const CustomSpacing(height: 12),
        _buildAddRowButton(),
        ValueListenableBuilder<bool>(
          valueListenable: controller.canSave,
          builder: (context, canSave, _) {
            if (canSave) return const SizedBox.shrink();

            return const Padding(
              padding: EdgeInsets.only(top: 8),
              child: CustomText(
                text: "Isi minimal satu baris ukuran untuk mengaktifkan Simpan",
                style: TextStyle(
                  fontSize: 12,
                  color: SupportAppColors.greyColor,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProductDropdown() {
    return BlocBuilder<ProductListBloc, ProductListState>(
      builder: (context, state) {
        final products = <ProductModel>[
          for (final brand in state.products) ...brand.models,
        ];

        if (products.isNotEmpty && controller.selectedProduct.value == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.selectedProduct.value ??= products.first;
          });
        }

        final dropdownItems = <DropdownItemModel>[
          for (var i = 0; i < products.length; i++)
            DropdownItemModel(id: i, name: products[i].displayModelName),
        ];

        return ValueListenableBuilder<ProductModel?>(
          valueListenable: controller.selectedProduct,
          builder: (context, selectedProduct, _) {
            final selectedIndex = selectedProduct == null
                ? null
                : products.indexWhere((p) {
                    final id = AddSizeSheet._resolveProductId(p);
                    return id != null &&
                        id == AddSizeSheet._resolveProductId(selectedProduct);
                  });

            final selectedItem = (selectedIndex == null || selectedIndex < 0)
                ? null
                : dropdownItems[selectedIndex];

            return BuildSearchableDropdown(
              hint: "Pilih produk",
              items: dropdownItems,
              value: selectedItem,
              onChanged: (item) {
                controller.selectedProduct.value = item == null
                    ? null
                    : products[item.id];
              },
              onSearch: _onProductSearch,
              isLoading: state.status == ProductStatus.loading ||
                  state.isLoadingMore,
              onLoadMore: () {
                context.read<ProductListBloc>().add(LoadMoreProducts());
              },
              hasMore: state.page < state.totalPages,
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return CustomPaint(
      painter: _DashedBorderPainter(color: Colors.grey.shade400),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
        alignment: Alignment.center,
        child: const CustomText(
          text: "Belum ada ukuran ditambahkan",
          style: TextStyle(fontSize: 13, color: SupportAppColors.greyColor),
        ),
      ),
    );
  }

  Widget _buildRow(SizeRowData row, int index) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        controller.showErrors,
        row.sizeController,
        row.ringController,
        row.sellPriceController,
      ]),
      builder: (context, _) {
        final showErrors = controller.showErrors.value;
        final hasError = showErrors && !row.isValid;

        return Container(
          key: row.rowKey,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: hasError ? AppColors.error : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomText(
                      text: "Ukuran ${index + 1}",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: SupportAppColors.greyDarkColor,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => controller.removeRow(row.id),
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
              const CustomSpacing(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const BuildLabel(text: "Ukuran", isRequired: true),
                        CustomTextField(
                          controller: row.sizeController,
                          focusNode: row.sizeFocusNode,
                          label: "Ukuran",
                          hint: "195/65",
                          textInputType: TextInputType.number,
                          inputFormatters: [SizeInputFormatter()],
                          filled: true,
                          errorText: showErrors && !row.isSizeFilled
                              ? "Ukuran wajib diisi"
                              : null,
                        ),
                      ],
                    ),
                  ),
                  const CustomSpacing(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const BuildLabel(text: "Ring", isRequired: true),
                        CustomTextField(
                          controller: row.ringController,
                          label: "Ring",
                          hint: "16",
                          isNumber: true,
                          prefixText: "R ",
                          filled: true,
                          errorText: showErrors && !row.isRingFilled
                              ? "Ring wajib diisi"
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (widget.isOwner) ...[
                const CustomSpacing(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BuildLabel(text: "Harga Jual", isRequired: true),
                    CustomTextField(
                      controller: row.sellPriceController,
                      hint: "Harga jual",
                      isNumber: true,
                      label: "Harga Jual",
                      prefixText: "Rp ",
                      inputFormatters: [CurrencyInputFormatter()],
                      filled: true,
                      errorText: showErrors && !row.isSellPriceFilled
                          ? "Harga jual wajib diisi"
                          : null,
                    ),
                  ],
                ),
                const CustomSpacing(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BuildLabel(text: "Harga Beli", isOptional: true),
                    CustomTextField(
                      controller: row.buyPriceController,
                      hint: "Harga beli",
                      isNumber: true,
                      label: "Harga Beli",
                      prefixText: "Rp ",
                      inputFormatters: [CurrencyInputFormatter()],
                      filled: true,
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddRowButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _addRow,
        icon: const Icon(Icons.add, size: 18),
        label: const CustomText(
          text: "Tambah baris ukuran",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;

  static const _radius = 16.0;

  const _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(_radius)),
      );

    const dashWidth = 6.0;
    const dashSpace = 4.0;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}
