import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/brand/brand_list_model.dart';
import 'package:flutter/material.dart';

class BrandCard extends StatelessWidget {
  final BrandListDatum brand;

  final bool isSelected;
  final bool selectionMode;

  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const BrandCard({
    super.key,
    required this.brand,
    required this.isSelected,
    required this.selectionMode,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? SupportAppColors.lightRed
              : SupportAppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (selectionMode) ...[
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: SupportAppColors.white,
                            size: 14,
                          )
                        : null,
                  ),
                  const CustomSpacing(width: 12),
                ],
                Expanded(
                  child: CustomText(
                    text: brand.displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                const Icon(
                  Icons.inventory_2_outlined,
                  size: 12,
                  color: SupportAppColors.greyColor,
                ),
                const CustomSpacing(width: 8),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: 'Jumlah Produk',
                        style: TextStyle(
                          fontSize: 12,
                          color: SupportAppColors.greyColor,
                        ),
                      ),
                      CustomText(
                        text: brand.displayProductCount,
                        style: const TextStyle(
                          fontSize: 12,
                          color: SupportAppColors.greyDarkerColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const CustomSpacing(height: 2),
            Row(
              children: [
                const Icon(
                  Icons.edit_calendar_outlined,
                  size: 12,
                  color: SupportAppColors.greyColor,
                ),
                const CustomSpacing(width: 8),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Terakhir diperbarui',
                        style: const TextStyle(
                          fontSize: 12,
                          color: SupportAppColors.greyColor,
                        ),
                      ),
                      CustomText(
                        text: brand.displayUpdatedAt,
                        style: const TextStyle(
                          fontSize: 12,
                          color: SupportAppColors.greyDarkerColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const CustomSpacing(height: 2),
            Row(
              children: [
                const Icon(
                  Icons.add_box_outlined,
                  size: 12,
                  color: SupportAppColors.greyColor,
                ),
                const CustomSpacing(width: 8),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Dibuat pada',
                        style: const TextStyle(
                          fontSize: 12,
                          color: SupportAppColors.greyColor,
                        ),
                      ),
                      CustomText(
                        text: brand.displayCreatedAt,
                        style: const TextStyle(
                          fontSize: 12,
                          color: SupportAppColors.greyDarkerColor,
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
}
