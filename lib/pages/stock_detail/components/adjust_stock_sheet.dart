import 'package:arena/components/bottom_sheet/custom_bottom_sheet_v2.dart';
import 'package:arena/components/build/build_label.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/text_field/custom_text_field.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/helper/currency_input_formatter.dart';
import 'package:arena/helper/currency_text_parser.dart';
import 'package:arena/helper/dot_input_formatter.dart';
import 'package:arena/models/enums/role.dart';
import 'package:arena/models/stock/stock_detail_model.dart';
import 'package:arena/models/stock/update_stock_request_model.dart';
import 'package:arena/pages/stock_detail/bloc/stock_detail_bloc.dart';
import 'package:arena/pages/stock_detail/bloc/stock_detail_event.dart';
import 'package:arena/services/auth/user_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdjustStockSheet extends StatefulWidget {
  final String productId;
  final StockDetailBatch batch;
  final TextEditingController batchCodeController;
  final TextEditingController quantityController;
  final TextEditingController buyPriceController;
  final TextEditingController sellPriceController;
  final TextEditingController reasonController;
  final ValueNotifier<bool> isSaveEnabled;
  final bool isOwner;
  final bool isWarehouse;

  const AdjustStockSheet({
    super.key,
    required this.productId,
    required this.batch,
    required this.batchCodeController,
    required this.quantityController,
    required this.buyPriceController,
    required this.sellPriceController,
    required this.reasonController,
    required this.isSaveEnabled,
    required this.isOwner,
    required this.isWarehouse,
  });

  static void show(
    BuildContext context, {
    required String productId,
    required StockDetailBatch batch,
  }) {
    final role = UserSession.role;
    final isOwner = role == Role.owner;
    final isWarehouse = role == Role.warehouseStaff;

    final batchCodeController = TextEditingController(
      text: (batch.batchCode ?? '').replaceAll(RegExp(r'[^0-9]'), ''),
    );
    final quantityController = TextEditingController(
      text: (batch.quantity ?? 0).toString(),
    );
    final buyPriceController = TextEditingController(
      text: formatInitialCurrency(batch.buyPrice),
    );
    final sellPriceController = TextEditingController(
      text: formatInitialCurrency(batch.sellPrice),
    );
    final reasonController = TextEditingController();

    final isSaveEnabled = ValueNotifier<bool>(!isWarehouse);

    void onReasonChanged() {
      isSaveEnabled.value = !isWarehouse || reasonController.text.trim().isNotEmpty;
    }
    reasonController.addListener(onReasonChanged);

    void dispose() {
      reasonController.removeListener(onReasonChanged);
      isSaveEnabled.dispose();
      batchCodeController.dispose();
      quantityController.dispose();
      buyPriceController.dispose();
      sellPriceController.dispose();
      reasonController.dispose();
    }

    CustomBottomSheetV2.show(
      context,
      title: "Edit Batch",
      isScrollable: true,
      isSaveEnabled: isSaveEnabled,
      onSave: () {
        final batchCode = batchCodeController.text.trim();
        final quantityText = quantityController.text.trim();
        final buyPriceText = buyPriceController.text.trim();
        final sellPriceText = sellPriceController.text.trim();
        final reason = reasonController.text.trim();

        final quantity = quantityText.isNotEmpty
            ? int.tryParse(quantityText)
            : null;

        if (quantityText.isNotEmpty && (quantity == null || quantity < 0)) {
          AppSnackBar.warning(
            context: context,
            message: "Quantity tidak valid",
          );
          return false;
        }

        if (batchCode.isNotEmpty) {
          final dotError = getDotCodeError(batchCode);
          if (dotError != null) {
            AppSnackBar.warning(context: context, message: dotError);
            return false;
          }
        }

        if (isWarehouse && reason.length < 5) {
          AppSnackBar.warning(
            context: context,
            message: "Alasan perubahan minimal 5 karakter",
          );
          return false;
        }

        final original = batch;
        final originalBatchCodeDigits = (original.batchCode ?? '')
            .replaceAll(RegExp(r'[^0-9]'), '');
        final hasChanges =
            (batchCode.isNotEmpty && batchCode != originalBatchCodeDigits) ||
            (quantity != null && quantity != original.quantity) ||
            (isOwner &&
                buyPriceText.isNotEmpty &&
                buyPriceText.toCurrencyInt() != original.buyPrice) ||
            (isOwner &&
                sellPriceText.isNotEmpty &&
                sellPriceText.toCurrencyInt() != original.sellPrice) ||
            reason.isNotEmpty;

        if (!hasChanges) {
          AppSnackBar.warning(
            context: context,
            message: "Tidak ada perubahan yang dilakukan",
          );
          return false;
        }

        context.read<StockDetailBloc>().add(
          UpdateStockSubmitted(
            stockId: original.stockId ?? "",
            productId: productId,
            request: UpdateStockRequestModel(
              batchCode:
                  batchCode.isNotEmpty && batchCode != originalBatchCodeDigits
                  ? batchCode
                  : null,
              quantity: quantity,
              buyPrice: isOwner && buyPriceText.isNotEmpty
                  ? buyPriceText.toCurrencyInt()
                  : null,
              sellPrice: isOwner && sellPriceText.isNotEmpty
                  ? sellPriceText.toCurrencyInt()
                  : null,
              reason: reason.isNotEmpty ? reason : null,
            ),
          ),
        );

        return true;
      },
      onDismissed: dispose,
      child: BlocProvider.value(
        value: context.read<StockDetailBloc>(),
        child: AdjustStockSheet(
          productId: productId,
          batch: batch,
          batchCodeController: batchCodeController,
          quantityController: quantityController,
          buyPriceController: buyPriceController,
          sellPriceController: sellPriceController,
          reasonController: reasonController,
          isSaveEnabled: isSaveEnabled,
          isOwner: isOwner,
          isWarehouse: isWarehouse,
        ),
      ),
    );
  }

  @override
  State<AdjustStockSheet> createState() => _AdjustStockSheetState();
}

class _AdjustStockSheetState extends State<AdjustStockSheet> {
  String? _batchCodeError;

  @override
  void initState() {
    super.initState();
    _updateBatchCodeError();
    widget.batchCodeController.addListener(_updateBatchCodeError);
  }

  @override
  void dispose() {
    widget.batchCodeController.removeListener(_updateBatchCodeError);
    super.dispose();
  }

  void _updateBatchCodeError() {
    final error = getDotCodeError(widget.batchCodeController.text.trim());
    if (error != _batchCodeError) {
      setState(() => _batchCodeError = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomSpacing(height: 4),
        CustomText(
          text:
              "${widget.batch.displayBatchCode} · stok sistem saat ini ${widget.batch.displayQuantity}",
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const CustomSpacing(height: 20),

        const BuildLabel(text: "Kode Batch"),
        CustomTextField(
          controller: widget.batchCodeController,
          hint: "Kode batch",
          inputFormatters: [DotCodeInputFormatter()],
          errorText: _batchCodeError,
          filled: true,
        ),
        const CustomSpacing(height: 20),

        const BuildLabel(text: "Quantity"),
        CustomTextField(
          controller: widget.quantityController,
          hint: "0",
          isNumber: true,
          textInputType: TextInputType.number,
          filled: true,
        ),

        if (widget.isOwner) ...[
          const CustomSpacing(height: 20),
          const BuildLabel(text: "Harga Beli"),
          CustomTextField(
            controller: widget.buyPriceController,
            hint: "Harga beli",
            isNumber: true,
            prefixText: "Rp ",
            inputFormatters: [CurrencyInputFormatter()],
            filled: true,
          ),
          const CustomSpacing(height: 20),
          const BuildLabel(text: "Harga Jual"),
          CustomTextField(
            controller: widget.sellPriceController,
            hint: "Harga jual",
            isNumber: true,
            prefixText: "Rp ",
            inputFormatters: [CurrencyInputFormatter()],
            filled: true,
          ),
        ],

        const CustomSpacing(height: 20),
        BuildLabel(text: "Alasan Perubahan", isRequired: widget.isWarehouse),
        CustomTextField(
          controller: widget.reasonController,
          hint: "Mis. stok opname, ban rusak, selisih fisik",
          label: "Mis. stok opname, ban rusak",
          alignLabelWithHint: true,
          filled: true,
          maxLines: 3,
        ),
        const CustomSpacing(height: 8),
      ],
    );
  }
}
