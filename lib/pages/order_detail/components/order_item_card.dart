import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/models/enums/enums.dart';
import 'package:arena/models/order/order_detail_model.dart';
import 'package:flutter/material.dart';

class OrderItemCard extends StatelessWidget {
  final OrderDetailItem item;
  final bool showPrice;

  const OrderItemCard({super.key, required this.item, this.showPrice = true});

  @override
  Widget build(BuildContext context) {
    final qty = item.quantity ?? 0;
    final unitPrice = item.unitPrice ?? 0;
    final subtotal = item.subtotal ?? (unitPrice * qty);
    final isService = item.itemType == ItemType.SERVICE;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SupportAppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isService) ...[
            CustomText(
              text: item.displayBrandName,
              style: const TextStyle(
                fontSize: 13,
                color: SupportAppColors.greyDarkerColor,
              ),
            ),

            const CustomSpacing(height: 6),
          ],
          if (isService) ...[
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                const CustomSpacing(width: 8),
                CustomText(
                  text: item.displayProductName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ] else ...[
            CustomText(
              text: item.displayProductName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],

          if (!isService) ...[
            const CustomSpacing(height: 14),

            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                _chipRich(label: 'Ukuran', value: item.displaySize),
                _chipRich(label: 'Ring', value: item.displayRing),
                _chipRich(value: item.displayBatchCode),
              ],
            ),
          ],

          const CustomSpacing(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!isService)
                CustomText(
                  text: "Jumlah: ${item.displayQty}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: SupportAppColors.greyDarkerColor,
                  ),
                ),
              const Spacer(),
              if (showPrice)
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (!isService)
                      CustomText(
                        text: '${unitPrice.toLocaleCurrency()} / pcs',
                        style: const TextStyle(
                          fontSize: 12,
                          color: SupportAppColors.greyDarkerColor,
                        ),
                      ),
                    CustomText(
                      text: subtotal.toLocaleCurrency(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chipRich({String? label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: SupportAppColors.greyMidTermColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14),
          children: [
            TextSpan(
              text: label != null ? '$label ' : '',
              style: const TextStyle(color: SupportAppColors.greyDarkerColor),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
