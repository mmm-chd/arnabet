import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TopStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String percent;
  final String? direction;
  final double? valueFontSize, titleFontSize, percentFontSize;

  const TopStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.percent,
    this.direction,
    this.valueFontSize,
    this.titleFontSize,
    this.percentFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDown = direction == "down";
    final bool isNeutral = direction == null;
    final Color accentColor = isNeutral
        ? SupportAppColors.normalOrange
        : isDown
            ? SupportAppColors.normalRed
            : SupportAppColors.normalGreen;
    final Color bgColor = isNeutral
        ? SupportAppColors.lightOrange
        : accentColor.withValues(alpha: 0.1);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SupportAppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: value,
            style: TextStyle(
              fontSize: valueFontSize ?? 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const CustomSpacing(height: 4),
          CustomText(
            text: title,
            style: TextStyle(
              fontSize: titleFontSize ?? 12,
              color: Colors.grey[600],
            ),
          ),
          const CustomSpacing(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                isNeutral
                    ? SvgPicture.asset(
                        CustomIcons.trendNeutral,
                        width: 14,
                        height: 14,
                        colorFilter: ColorFilter.mode(
                          accentColor,
                          BlendMode.srcIn,
                        ),
                      )
                    : isDown
                        ? SvgPicture.asset(
                            CustomIcons.trendDown,
                            width: 14,
                            height: 14,
                            colorFilter: ColorFilter.mode(
                              accentColor,
                              BlendMode.srcIn,
                            ),
                          )
                        : Icon(
                            Icons.arrow_upward,
                            size: 14,
                            color: accentColor,
                          ),
                const CustomSpacing(width: 4),
                CustomText(
                  text: isNeutral ? "Stabil" : percent,
                  style: TextStyle(
                    fontSize: percentFontSize ?? 12,
                    color: accentColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
