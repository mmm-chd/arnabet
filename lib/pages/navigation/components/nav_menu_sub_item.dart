import 'package:arena/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';

class NavMenuSubItem extends StatelessWidget {
  final bool selected;
  final String title;
  final VoidCallback? onTap;

  const NavMenuSubItem({
    super.key,
    required this.title,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Material(
        color: selected ? SupportAppColors.lightRed : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: CustomText(
              text: title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: selected ? SupportAppColors.normalRed : SupportAppColors.greyDarkerColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
