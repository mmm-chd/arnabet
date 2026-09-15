import 'package:arena/components/custom_button.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/models/stock/stock_detail_model.dart';
import 'package:flutter/material.dart';

class CartSheet extends StatefulWidget {
  final StockDetailData stock;

  const CartSheet({super.key, required this.stock});

  @override
  State<CartSheet> createState() => _CartSheetState();
}

class _CartSheetState extends State<CartSheet> {
  int qty = 1;

  StockDetailBatch? selectedBatch;

  @override
  void initState() {
    super.initState();

    if (widget.stock.batches != null && widget.stock.batches!.isNotEmpty) {
      selectedBatch = widget.stock.batches!.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: SupportAppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomSpacing(height: 10),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: widget.stock.brandName ?? "",
                        style: const TextStyle(
                          fontSize: 13,
                          color: SupportAppColors.greyColor,
                        ),
                      ),

                      const CustomSpacing(height: 4),

                      CustomText(
                        text: widget.stock.productName ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const CustomSpacing(width: 12),

                Align(
                  alignment: Alignment.topRight,
                  child: CustomText(
                    text: ((widget.stock.sellPrice ?? 0) * qty)
                        .toLocaleCurrency(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),

            const CustomSpacing(height: 20),

            /// DOT
            if (widget.stock.batches != null &&
                widget.stock.batches!.isNotEmpty) ...[
              const CustomText(
                text: "DOT",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),

              const CustomSpacing(height: 12),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: widget.stock.batches!.map((batch) {
                  final isSelected =
                      selectedBatch?.batchCode == batch.batchCode;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedBatch = batch;
                        final batchStock = batch.quantity ?? 0;
                        if (qty > batchStock && batchStock > 0) {
                          qty = batchStock;
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : SupportAppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : SupportAppColors.greyMidColor,
                        ),
                      ),
                      child: CustomText(
                        text: "${batch.batchCode ?? "-"} (${batch.quantity ?? 0})",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? SupportAppColors.white
                              : SupportAppColors.greyDarkColor,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const CustomSpacing(height: 20),
            ],

            /// QTY
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(text: "Jumlah"),
                    if (selectedBatch != null) ...[
                      const CustomSpacing(height: 2),
                      CustomText(
                        text: "Stok tersedia: ${selectedBatch?.quantity ?? 0}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: SupportAppColors.greyColor,
                        ),
                      ),
                    ],
                  ],
                ),

                Row(
                  children: [
                    _btn(Icons.remove, () {
                      if (qty > 1) setState(() => qty--);
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomText(
                        text: "$qty",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    _btn(Icons.add, () {
                      final maxStock = selectedBatch?.quantity ?? 0;
                      if (qty < maxStock) {
                        setState(() => qty++);
                      } else {
                        AppSnackBar.warning(
                          context: context,
                          message:
                              'Jumlah tidak boleh melebihi stok yang tersedia ($maxStock)',
                        );
                      }
                    }),
                  ],
                ),
              ],
            ),

            const CustomSpacing(height: 20),

            CustomButton(
              text: (selectedBatch?.quantity ?? 0) <= 0
                  ? "Stok Habis"
                  : "Tambahkan Ke Keranjang",
              backgroundColor: (selectedBatch?.quantity ?? 0) <= 0
                  ? SupportAppColors.greyColor
                  : SupportAppColors.normalRed,
              foregroundColor: SupportAppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              onPressed: (selectedBatch?.quantity ?? 0) <= 0
                  ? null
                  : () {
                      final maxStock = selectedBatch?.quantity ?? 0;
                      if (qty > maxStock) {
                        AppSnackBar.warning(
                          context: context,
                          message:
                              'Jumlah tidak boleh melebihi stok yang tersedia ($maxStock)',
                        );
                        return;
                      }
                      Navigator.pop(context, {
                        "name": widget.stock.productName,
                        "brand": widget.stock.brandName,
                        "dot": selectedBatch?.batchCode ?? "-",
                        "size": widget.stock.displaySize,
                        "ring": widget.stock.displayRing,
                        "price": widget.stock.sellPrice,
                        "qty": qty,
                        "stock_id": selectedBatch?.stockId ?? "",
                      });
                    },
            ),
          ],
        ),
      ),
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: SupportAppColors.greyMidTermColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}
