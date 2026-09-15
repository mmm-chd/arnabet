import 'package:arena/components/animations/animated_expandable_content.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';

import 'package:arena/models/product/product_list_model.dart';
import 'product_size_chip.dart';

class ProductCard extends StatefulWidget {
  final ProductListDatum brand;
  final ProductModel model;

  final bool isSelected;
  final bool selectionMode;

  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ProductCard({
    super.key,
    required this.brand,
    required this.model,
    required this.isSelected,
    required this.selectionMode,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isExpanded = false;

  @override
  void didUpdateWidget(ProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected && isExpanded) {
      setState(() => isExpanded = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final validVariants = (widget.model.variants)
        .where(
          (variant) =>
              (variant.size?.isNotEmpty ?? false) ||
              (variant.ring?.isNotEmpty ?? false),
        )
        .toList();
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? SupportAppColors.lightRed
              : SupportAppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: widget.isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (widget.selectionMode) ...[
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: widget.isSelected
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: widget.brand.displayBrandName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: SupportAppColors.greyColor,
                        ),
                      ),

                      const CustomSpacing(height: 6),

                      CustomText(
                        text: widget.model.displayModelName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  children: [
                    CustomText(
                      text: "${validVariants.length} variant",
                      style: const TextStyle(
                        fontSize: 13,
                        color: SupportAppColors.greyColor,
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },

                      icon: AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: const Icon(Icons.keyboard_arrow_down_rounded),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            AnimatedExpandableContent(
              expanded: isExpanded,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      color: SupportAppColors.greyMidColor,
                      height: 1,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: validVariants.isNotEmpty
                          ? Wrap(
                              spacing: 2,
                              runSpacing: 2,
                              children: validVariants.map((variant) {
                                return ProductSizeChip(
                                  text:
                                      "${variant.displaySize} ${variant.displayRing}",
                                );
                              }).toList(),
                            )
                          : const CustomText(
                              text: "Tidak ada varian",
                              style: TextStyle(
                                fontSize: 13,
                                color: SupportAppColors.greyColor,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
