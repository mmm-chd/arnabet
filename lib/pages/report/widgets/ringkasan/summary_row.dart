import 'package:arena/components/custom_text.dart';
import 'package:flutter/material.dart';

class SummaryRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String qty;
  final String value;
  final String profit;
  final String percent;

  final bool isBold;
  final bool isHeader;

  const SummaryRow({
    super.key,
    required this.title,
    this.subtitle,
    required this.qty,
    required this.value,
    required this.profit,
    required this.percent,
    this.isBold = false,
    this.isHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = TextStyle(
      fontSize: isHeader ? 11 : 13,
      fontWeight: isHeader ? FontWeight.w600 : isBold ? FontWeight.bold : FontWeight.w500,
      color: isHeader ? Colors.grey : Colors.black,
    );

    Color getValueColor(String val) {
      if (isHeader || isBold) return Colors.black;
      return Colors.green;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isHeader ? 0 : 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// PRODUK
          Expanded(
            flex: 3,
            child: isHeader
                ? CustomText(text: title, style: baseStyle)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: title, style: baseStyle),
                      if (subtitle != null)
                        CustomText(
                          text: subtitle!,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                    ],
                  ),
          ),

          /// QTY
          Expanded(
            child: CustomText(text: qty, style: baseStyle, textAlign: TextAlign.center),
          ),

          /// OMZET
          Expanded(
            child: CustomText(
              text: value,
              style: baseStyle.copyWith(color: getValueColor(value)),
              textAlign: TextAlign.center,
            ),
          ),

          /// LABA
          Expanded(
            child: CustomText(
              text: profit,
              style: baseStyle.copyWith(color: Colors.green),
              textAlign: TextAlign.center,
            ),
          ),

          /// MARGIN
          Expanded(
            child: CustomText(
              text: percent,
              style: baseStyle.copyWith(color: isHeader ? Colors.grey : Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}