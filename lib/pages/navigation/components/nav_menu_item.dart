import 'package:arena/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter_svg/svg.dart';

class NavMenuItem extends StatelessWidget {
  final IconData? icon;
  final String? svgIcon;
  final String title;
  final bool selected;
  final VoidCallback? onTap;
  final Widget? trailing;

  const NavMenuItem({
    super.key,
    this.icon,
    this.svgIcon,
    required this.title,
    this.selected = false,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: selected ? SupportAppColors.lightRed : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        leading: svgIcon != null
            ? RepaintBoundary(
                child: SvgPicture.asset(
                  svgIcon ?? "",
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    selected ? primary : SupportAppColors.greyDarkColor,
                    BlendMode.srcIn,
                  ),
                ),
              )
            : Icon(
                icon,
                size: 22,
                color: selected ? primary : SupportAppColors.greyDarkColor,
              ),
        title: CustomText(
          text: title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: selected ? primary : SupportAppColors.greyDarkerColor,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
