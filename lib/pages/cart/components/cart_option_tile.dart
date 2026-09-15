import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../components/custom_text.dart';

class CartOptionTile extends StatelessWidget {
  final String? svgIcon;
  final IconData? icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  final Color? iconColor; 
  final Color? textColor; 

  const CartOptionTile({
    super.key,
    this.svgIcon,
    this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color finalIconColor = iconColor ?? Colors.black;
    final Color finalTextColor = textColor ?? Colors.black;

    return ListTile(
      onTap: onTap,

      leading: svgIcon != null
          ? SvgPicture.asset(
              svgIcon!,
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(
                finalIconColor,
                BlendMode.srcIn,
              ),
            )
          : Icon(icon, color: finalIconColor),

      title: CustomText(
        text: title,
        style: TextStyle(
          color: finalTextColor,
          fontWeight: FontWeight.w600,
        ),
      ),

      subtitle: subtitle != null
          ? CustomText(
              text: subtitle!,
              style: const TextStyle(fontSize: 12),
            )
          : null,

      trailing: const Icon(Icons.chevron_right),
    );
  }
}