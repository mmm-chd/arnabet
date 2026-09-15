import 'package:arena/components/bottom_sheet/custom_bottom_sheet_v2.dart';
import 'package:arena/components/build/build_label.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/dialog/custom_dialog.dart';
import 'package:arena/components/text_field/custom_text_field.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/currency_input_formatter.dart';
import 'package:arena/helper/currency_text_parser.dart';
import 'package:arena/helper/size_input_formatter.dart';
import 'package:arena/models/enums/role.dart';
import 'package:arena/models/product/product_list_model.dart';
import 'package:arena/models/product/update_product_request_model.dart';
import 'package:arena/pages/product/bloc/product_list_bloc.dart';
import 'package:arena/pages/product/bloc/product_list_event.dart';
import 'package:arena/services/auth/user_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditSizeSheet extends StatefulWidget {
  final ProductModel model;
  final ProductListDatum brand;
  final bool isOwner;

  const EditSizeSheet({
    super.key,
    required this.model,
    required this.brand,
    this.isOwner = false,
  });

  static void show(
    BuildContext context, {
    required ProductModel product,
    required ProductListDatum brand,
    required bool isOwner,
  }) {
    final productListBloc = context.read<ProductListBloc>();

    CustomBottomSheetV2.show(
      context,
      title: product.displayModelName,
      isScrollable: true,
      children: [
        BlocProvider.value(
          value: productListBloc,
          child: EditSizeSheet(model: product, brand: brand, isOwner: isOwner),
        ),
      ],
    );
  }

  @override
  State<EditSizeSheet> createState() => _EditSizeSheetState();
}

class _EditSizeSheetState extends State<EditSizeSheet> {
  void _showEditDialog(ProductVariant variant) {
    final productListBloc = context.read<ProductListBloc>();

    final isWarehouse = UserSession.role == Role.warehouseStaff;

    final sizeController = TextEditingController(text: variant.size);
    final ringController = TextEditingController(
      text: (variant.ring ?? "").replaceAll(RegExp(r'[^0-9]'), ''),
    );
    final sellPriceController = TextEditingController(
      text: formatInitialCurrency(variant.sellPrice),
    );
    final buyPriceController = TextEditingController(
      text: formatInitialCurrency(variant.buyPrice),
    );
    final reasonController = TextEditingController();

    CustomBottomSheetV2.show(
      context,
      title: "Edit Ukuran",
      onSave: () {
        if (sizeController.text.trim().isEmpty ||
            ringController.text.trim().isEmpty ||
            sellPriceController.text.trim().isEmpty) {
          AppSnackBar.warning(
            context: context,
            message: "Ukuran, ring, dan harga jual wajib diisi",
          );
          return false;
        }

        if (isWarehouse && reasonController.text.trim().isEmpty) {
          AppSnackBar.warning(
            context: context,
            message: "Alasan perubahan wajib diisi",
          );
          return false;
        }

        final reason = reasonController.text.trim();

        productListBloc.add(
          UpdateProduct(
            variant.productId,
            UpdateProductRequestModel(
              name: widget.model.displayModelName,
              brandId: widget.brand.brandId,
              size: sizeController.text.trim(),
              ring: "R${ringController.text.trim()}",
              sellPrice: sellPriceController.text.trim().toCurrencyInt(),
              buyPrice: buyPriceController.text.trim().isEmpty
                  ? null
                  : buyPriceController.text.trim().toCurrencyInt(),
              reason: isWarehouse && reason.isNotEmpty ? reason : null,
            ),
          ),
        );

        return true;
      },
      onDismissed: () {
        sizeController.dispose();
        ringController.dispose();
        sellPriceController.dispose();
        buyPriceController.dispose();
        reasonController.dispose();
      },
      children: [
        const BuildLabel(text: "Produk", isReadOnly: true),
        CustomTextField(
          controller: TextEditingController(
            text: widget.model.displayModelName,
          ),
          readOnly: true,
          filled: true,
        ),
        const CustomSpacing(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BuildLabel(text: "Ukuran", isRequired: true),
                  CustomTextField(
                    controller: sizeController,
                    label: "---/--",
                    hint: "195/65",
                    textInputType: TextInputType.number,
                    inputFormatters: [SizeInputFormatter()],
                    filled: true,
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
                    controller: ringController,
                    label: "R 0",
                    hint: "16",
                    isNumber: true,
                    prefixText: "R ",
                    filled: true,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (widget.isOwner) ...[
          const CustomSpacing(height: 20),
          const BuildLabel(text: "Harga Jual Default", isRequired: true),
          CustomTextField(
            controller: sellPriceController,
            hint: "Masukkan harga jual",
            isNumber: true,
            label: "Rp 0",
            prefixText: "Rp ",
            inputFormatters: [CurrencyInputFormatter()],
            filled: true,
          ),
          const CustomSpacing(height: 20),
          const BuildLabel(text: "Harga Beli Refrensi", isOptional: true),
          CustomTextField(
            controller: buyPriceController,
            hint: "Masukkan harga beli",
            isNumber: true,
            label: "Rp 0",
            prefixText: "Rp ",
            inputFormatters: [CurrencyInputFormatter()],
            filled: true,
          ),
        ],
        if (isWarehouse) ...[
          const CustomSpacing(height: 20),
          const BuildLabel(text: "Alasan Perubahan", isRequired: true),
          CustomTextField(
            controller: reasonController,
            alignLabelWithHint: true,
            label: 'Alasan perubahan ukuran/harga',
            hint: "Contoh: penyesuaian ukuran dari supplier",
            filled: true,
            maxLines: 3,
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final variants = widget.model.variants
        .where(
          (v) =>
              (v.size?.isNotEmpty ?? false) ||
              (v.ring?.isNotEmpty ?? false),
        )
        .toList();

    if (variants.isEmpty) {
      return const CustomText(
        text: "Tidak ada varian",
        style: TextStyle(fontSize: 13, color: SupportAppColors.greyColor),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: variants.length,
      itemBuilder: (context, index) {
        final variant = variants[index];

        return ListTile(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: CustomText(
            text: "${variant.displaySize} ${variant.displayRing}",
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isOwner)
                IconButton(
                  onPressed: () => _confirmDeleteVariant(variant),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                    size: 20,
                  ),
                  splashRadius: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              const Icon(Icons.chevron_right),
            ],
          ),
          onTap: () => _showEditDialog(variant),
        );
      },
    );
  }

  Future<void> _confirmDeleteVariant(ProductVariant variant) async {
    final isLastVariant = widget.model.variants.length == 1;

    final confirmed = await CustomDialog.confirmDelete(
      context,
      title: "Hapus Ukuran",
      message: isLastVariant
          ? "Ini ukuran terakhir. Produk beserta seluruh ukurannya akan ikut terhapus."
          : "Yakin ingin menghapus ukuran ini?",
    );

    if (confirmed == true && mounted) {
      context.read<ProductListBloc>().add(
        DeleteProduct(variant.productId, label: "ukuran ini"),
      );
      context.pop();
    }
  }
}
