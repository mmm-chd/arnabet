import 'package:arena/components/custom_text.dart';
import 'package:flutter/material.dart';

class StockSummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;

  const StockSummaryRow({
    super.key,
    required this.title,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: title, style: const TextStyle(color: Colors.grey)),
          CustomText(
            text: value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}