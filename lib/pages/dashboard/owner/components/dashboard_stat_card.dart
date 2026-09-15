import 'package:arena/components/custom_spacing.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? percent;
  final bool isDown;
  final String? unit;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    this.percent,
    this.isDown = false,
    this.unit = "pcs",
  });

  @override
  Widget build(BuildContext context) {
    final trendDownIcon = CustomIcons.trendDown;
    final trendUpIcon = CustomIcons.trendUp;
    final bool isNeutral = percent == null;

    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SupportAppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: SupportAppColors.greyDarkerColor,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (unit != null && unit!.isNotEmpty)
                CustomText(
                  text: unit!,
                  style: TextStyle(
                    color: SupportAppColors.greyColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),

          const CustomSpacing(height: 4),

          CustomText(
            text: title,
            style: TextStyle(fontSize: 14, color: SupportAppColors.greyColor),
          ),

          const CustomSpacing(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            decoration: BoxDecoration(
              color: isNeutral
                  ? SupportAppColors.lightOrange
                  : isDown
                      ? SupportAppColors.lightRed
                      : SupportAppColors.lightGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  isNeutral
                      ? CustomIcons.trendNeutral
                      : isDown
                          ? trendDownIcon
                          : trendUpIcon,
                  fit: BoxFit.cover,
                  width: 24,
                  height: 24,
                  colorFilter: isNeutral
                      ? ColorFilter.mode(
                          SupportAppColors.normalOrange,
                          BlendMode.srcIn,
                        )
                      : null,
                ),
                const CustomSpacing(width: 12),
                CustomText(
                  text: isNeutral ? "Stabil" : percent!,
                  style: TextStyle(
                    fontSize: 14,
                    color: isNeutral
                        ? SupportAppColors.normalOrange
                        : isDown
                            ? SupportAppColors.normalRed
                            : SupportAppColors.normalGreen,
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
