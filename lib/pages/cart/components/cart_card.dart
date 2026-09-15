import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/currency_local_formatter.dart';
import 'package:flutter/material.dart';
import 'package:arena/models/cart/cart_list_model.dart';
import '../../../components/custom_text.dart';
import '../../../components/custom_spacing.dart';
import 'qty_button.dart';

class CartCard extends StatelessWidget {
  final Item item;
  final VoidCallback onAdd, onMin;
  final bool enabled;
  final bool isSyncing;

  const CartCard({
    super.key,
    required this.item,
    required this.onAdd,
    required this.onMin,
    this.enabled = true,
    this.isSyncing = false,
  });

  @override
  Widget build(BuildContext context) {
    final subtotal =
        item.subtotal ?? ((item.unitPrice ?? 0) * (item.quantity ?? 0));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SupportAppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: item.brand ?? "-",
              style: const TextStyle(
                fontSize: 13,
                color: SupportAppColors.greyDarkerColor,
              ),
            ),

            const CustomSpacing(height: 6),

            CustomText(
              text: item.productName ?? "-",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const CustomSpacing(height: 14),

            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                _chipRich(label: 'Ukuran', value: item.size ?? item.sku ?? "-"),
                _chipRich(label: 'Ring', value: item.ring ?? "-"),
                _chipRich(value: item.batchCode ?? "-"),
              ],
            ),

            const CustomSpacing(height: 18),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                QtyButton(
                  qty: item.quantity ?? 0,
                  onAdd: onAdd,
                  onMin: onMin,
                  enabled: enabled,
                  isSyncing: isSyncing,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomText(
                        text: '${item.unitPrice?.toLocaleCurrency()} / pcs',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black45,
                        ),
                      ),
                      const CustomSpacing(height: 6),
                      CustomText(
                        text: subtotal.toLocaleCurrency(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chipRich({String? label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(22),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14),
          children: [
            TextSpan(
              text: label != null ? '$label ' : '',
              style: const TextStyle(color: Colors.black45),
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