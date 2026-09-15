import 'package:arena/components/custom_text.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProductSizeChip extends StatelessWidget {
  final String text;

  const ProductSizeChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: CustomText(
        text: text,
        style: const TextStyle(
          fontSize: 13,
          color: SupportAppColors.greyDarkerColor,
        ),
      ),
    );
  }
}
