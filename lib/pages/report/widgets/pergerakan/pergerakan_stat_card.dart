import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter_svg/svg.dart';

class PergerakanStatCard extends StatelessWidget {
  final String value;
  final String title;
  final String subtitle;
  final Color textColor;
  final Color backgroundColor;
  final IconData icon;
  final double? trendPercentage;
  final String? trendDirection;

  const PergerakanStatCard({
    super.key,
    required this.value,
    required this.title,
    required this.subtitle,
    required this.textColor,
    required this.backgroundColor,
    required this.icon,
    this.trendPercentage,
    this.trendDirection,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasTrend = trendPercentage != null;
    final bool isNeutral = !hasTrend;
    final bool isDown = trendDirection == "down";
    final Color trendColor = isNeutral
        ? SupportAppColors.normalOrange
        : isDown
        ? SupportAppColors.normalRed
        : SupportAppColors.normalGreen;
    final Color trendBg = isNeutral
        ? SupportAppColors.lightOrange
        : trendColor.withValues(alpha: 0.1);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: SupportAppColors.greyDarkerColor.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: textColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 18, color: textColor),
              ),
              const CustomSpacing(width: 10),
              Expanded(
                child: CustomText(
                  text: title,
                  style: TextStyle(
                    fontSize: 13,
                    color: SupportAppColors.greyColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const CustomSpacing(height: 12),
          CustomText(
            text: value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: SupportAppColors.greyDarkerColor,
            ),
          ),
          const CustomSpacing(height: 2),
          CustomText(
            text: subtitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const CustomSpacing(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: trendBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                isNeutral
                    ? SvgPicture.asset(
                        CustomIcons.trendNeutral,
                        width: 13,
                        height: 13,
                        colorFilter: ColorFilter.mode(
                          trendColor,
                          BlendMode.srcIn,
                        ),
                      )
                    : isDown
                    ? SvgPicture.asset(
                        CustomIcons.trendDown,
                        width: 13,
                        height: 13,
                        colorFilter: ColorFilter.mode(
                          trendColor,
                          BlendMode.srcIn,
                        ),
                      )
                    : Icon(Icons.trending_up, size: 13, color: trendColor),
                const CustomSpacing(width: 8),
                CustomText(
                  text: isNeutral ? "Stabil" : _trendLabel(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: trendColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _trendLabel() {
    final pct = trendPercentage ?? 0;
    final abs = pct.abs().toStringAsFixed(1);
    return pct < 0 ? "-$abs%" : "+$abs%";
  }
}
