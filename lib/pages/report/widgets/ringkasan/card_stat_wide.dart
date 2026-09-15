import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter_svg/svg.dart';

class CardStatWide extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final String? trend;
  final bool trendDown;
  final bool trendUp;
  final bool neutral;
  final Color? valueColor;

  const CardStatWide({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.trend,
    this.trendDown = false,
    this.trendUp = false,
    this.neutral = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SupportAppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(
                  text: value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? SupportAppColors.greyDarkerColor,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (trend != null) _trend(context),
            ],
          ),
          const CustomSpacing(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: CustomText(
                  text: title,
                  style: TextStyle(
                    color: SupportAppColors.greyColor,
                    fontSize: 14,
                  ),
                ),
              ),
              if (subtitle != null)
                CustomText(
                  text: subtitle!,
                  style: TextStyle(
                    color: SupportAppColors.greyColor,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            height: 18,
            width: 18,
            colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
          ),
          const CustomSpacing(width: 6),
          CustomText(
            text: neutral ? "Stabil" : trend!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
