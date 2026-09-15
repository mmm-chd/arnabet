import 'package:arena/components/custom_text.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AddStockItemButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddStockItemButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: SupportAppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: SupportAppColors.greyMidColor),
        ),
        child: const Center(
          child: Column(
            children: [
              Icon(Icons.add, size: 30, color: SupportAppColors.greyColor),
              CustomText(
                text: "Tambahkan barang",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: SupportAppColors.greyDarkColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
