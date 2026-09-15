import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/helper/currency_local_formatter.dart';
import 'package:flutter/material.dart';
import '../../../models/dot_model.dart';

class DotSummaryItem extends StatelessWidget {
  final DotModel dot;

  const DotSummaryItem({super.key, required this.dot});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "DOT ${dot.kode}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const CustomSpacing(height: 4),
              CustomText(
                text: "${dot.jumlah} pcs",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          CustomText(
            text: dot.hargaBeli?.toLocaleCurrency() ?? '-',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
