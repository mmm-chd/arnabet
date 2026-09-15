import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final int rank;
  final String name;
  final String detail;
  final String price;
  final String margin;
  final bool bigPrice;
  final double? topLeft, topRight, bottomLeft, bottomRight;

  const ProductItem({
    super.key,
    required this.rank,
    required this.name,
    required this.detail,
    required this.price,
    required this.margin,
    this.bigPrice = false,
    this.topLeft,
    this.topRight,
    this.bottomLeft,
    this.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    if (rank == 1) {
      bgColor = SupportAppColors.lightOrange;
      textColor = SupportAppColors.normalOrange;
    } else if (rank == 2) {
      bgColor = SupportAppColors.greyMidColor.withValues(alpha: 0.3);
      textColor = SupportAppColors.greyColor;
    } else if (rank == 3) {
      bgColor = SupportAppColors.lightRed;
      textColor = SupportAppColors.normalRed;
    } else {
      bgColor = SupportAppColors.greyMidColor.withValues(alpha: 0.3);
      textColor = SupportAppColors.greyColor;
    }

    return Container(
      decoration: BoxDecoration(
        color: SupportAppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeft ?? 0),
          topRight: Radius.circular(topRight ?? 0),
          bottomLeft: Radius.circular(bottomLeft ?? 0),
          bottomRight: Radius.circular(bottomRight ?? 0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: CustomText(
                  text: "$rank",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: textColor,
                  ),
                ),
              ),
            ),
            const CustomSpacing(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: SupportAppColors.greyDarkerColor,
                    ),
                  ),
                  const CustomSpacing(height: 4),
                  CustomText(
                    text: detail,
                    style: TextStyle(
                      color: SupportAppColors.greyColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(
                  text: price,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: SupportAppColors.normalGreen,
                  ),
                ),
                const CustomSpacing(height: 4),
                CustomText(
                  text: "margin $margin%",
                  style: TextStyle(
                    color: SupportAppColors.greyColor,
                    fontSize: 12,
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
