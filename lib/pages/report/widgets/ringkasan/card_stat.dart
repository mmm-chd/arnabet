import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter_svg/svg.dart';

class CardStat extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;

  final String? trend;
  final bool trendDown;
  final bool trendUp;
  final bool neutral;

  final bool isGrid;
  final Color? valueColor;
  final double? fontSize;

  const CardStat({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.trend,
    this.trendDown = false,
    this.trendUp = false,
    this.neutral = false,
    this.isGrid = false,
    this.valueColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: SupportAppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: value,
                style: TextStyle(
                  fontSize: fontSize ?? 16,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? SupportAppColors.greyDarkerColor,
                ),
              ),
              const CustomSpacing(height: 2),
              CustomText(
                text: title,
                style: TextStyle(
                  fontSize: 12,
                  color: SupportAppColors.greyColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (subtitle != null) ...[
                const CustomSpacing(height: 2),
                CustomText(
                  text: subtitle!,
                  style: TextStyle(
                    fontSize: 11,
                    color: SupportAppColors.greyColor,
                  ),
                ),
              ],
            ],
          ),
          if (trend != null) ...[
            const CustomSpacing(height: 8),
            _trend(context),
          ],
        ],
      ),
    );
  }

  Widget _trend(BuildContext context) {
    Color bgColor;
    Color textColor;
    String iconPath;

    if (neutral) {
      bgColor = SupportAppColors.lightOrange;
      textColor = SupportAppColors.normalOrange;
      iconPath = CustomIcons.trendNeutral;
    } else if (trendDown) {
      bgColor = SupportAppColors.lightRed;
      textColor = SupportAppColors.normalRed;
      iconPath = CustomIcons.trendDown;
    } else if (trendUp) {
      bgColor = SupportAppColors.lightGreen;
      textColor = SupportAppColors.normalGreen;
      iconPath = CustomIcons.trendUp;
    } else {
      bgColor = SupportAppColors.lightOrange;
      textColor = SupportAppColors.normalOrange;
      iconPath = CustomIcons.trendNeutral;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
          ),
          const CustomSpacing(width: 8),
          CustomText(
            text: neutral ? "Stabil" : trend!,
            style: TextStyle(
              fontSize: 15,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
