import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/helper/currency_local_formatter.dart';
import 'package:flutter/material.dart';
import '../../../models/dot_model.dart';

class DotFormItem extends StatelessWidget {
  final DotModel dot;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool showPrices;

  const DotFormItem({
    super.key,
    required this.dot,
    required this.onIncrement,
    required this.onDecrement,
    this.showPrices = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: dot.kode,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: onDecrement,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.remove, size: 16),
                      ),
                    ),
                    const CustomSpacing(width: 10),
                    CustomText(text: "${dot.jumlah}"),
                    const CustomSpacing(width: 10),
                    GestureDetector(
                      onTap: onIncrement,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, size: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            /// HARGA (hanya untuk owner, bersifat rahasia)
            if (showPrices) ...[
              const CustomSpacing(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Harga Beli",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  CustomText(
                    text: "${dot.hargaBeli?.toLocaleCurrency() ?? '-'}/pcs",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const CustomSpacing(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Harga Jual",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  CustomText(
                    text: "${dot.hargaJual?.toLocaleCurrency() ?? '-'}/pcs",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
