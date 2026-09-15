import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/design/status_color_config.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class StockItem extends StatelessWidget {
  final int index;
  final String name;
  final String spec;
  final String status;
  final String qty;
  final double? topLeft, topRight, bottomLeft, bottomRight;

  const StockItem({
    super.key,
    required this.index,
    required this.name,
    required this.spec,
    required this.status,
    required this.qty,
    this.topLeft,
    this.topRight,
    this.bottomLeft,
    this.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    final style = StockConfig.getStyleByName(status);

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: SupportAppColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: style.foreground),
              ),
              alignment: Alignment.center,
              child: CustomText(
                text: index.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: style.foreground,
                ),
              ),
            ),
            const CustomSpacing(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const CustomSpacing(height: 2),
                  CustomText(
                    text: spec,
                    style: TextStyle(
                      fontSize: 12,
                      color: SupportAppColors.greyColor,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: style.background,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: style.foreground,
                          shape: BoxShape.circle,
                        ),
                      ),
                      CustomText(
                        text: status,
                        style: TextStyle(
                          color: style.foreground,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const CustomSpacing(height: 6),
                CustomText(
                  text: qty,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: style.foreground,
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
