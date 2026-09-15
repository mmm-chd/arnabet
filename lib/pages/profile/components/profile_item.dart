import 'package:arena/components/custom_spacing.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:arena/components/custom_text.dart';
import 'package:flutter_svg/svg.dart';

class ProfileItem extends StatelessWidget {
  final String icon;
  final String title;
  final bool isLogout;
  final VoidCallback? onTap;
  final double? radiusTop;
  final double? radiusBottom;

  const ProfileItem({
    super.key,
    required this.icon,
    required this.title,
    this.isLogout = false,
    this.onTap,
    this.radiusTop,
    this.radiusBottom,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radiusTop ?? 0),
          topRight: Radius.circular(radiusTop ?? 0),
          bottomLeft: Radius.circular(radiusBottom ?? 0),
          bottomRight: Radius.circular(radiusBottom ?? 0),
        ),
        child: Ink(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: SupportAppColors.lightRed,
                  ),
                  child: SvgPicture.asset(
                    icon,
                    colorFilter: ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const CustomSpacing(width: 16),
                Expanded(
                  child: CustomText(
                    text: title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isLogout
                          ? AppColors.primary
                          : SupportAppColors.greyDarkerColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: isLogout
                      ? AppColors.primary
                      : SupportAppColors.greyColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
