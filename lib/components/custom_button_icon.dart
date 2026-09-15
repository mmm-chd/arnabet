import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:flutter/material.dart';

class CustomButtonIcon extends StatelessWidget {
  final String text;
  final IconData icon;
  final double? margin, height, width, borderRadius, iconSize, elevation;
  final Color? backgroundColor, foregroundColor, iconColor;
  final VoidCallback? onPressed;
  final OutlinedBorder? shape;

  const CustomButtonIcon({
    super.key,
    required this.text,
    required this.icon,
    this.margin,
    this.backgroundColor,
    this.foregroundColor,
    this.iconColor,
    this.onPressed,
    this.shape,
    this.height,
    this.width,
    this.borderRadius,
    this.iconSize,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: margin ?? 0.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: elevation ?? 1.0,
          padding: EdgeInsets.symmetric(
            vertical: height ?? 8.0,
            horizontal: width ?? 32.0,
          ),
          shape:
              shape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 16.0),
              ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: iconColor ?? foregroundColor ?? Colors.white,
              size: iconSize ?? 18.0,
            ),
            const CustomSpacing(width: 8),
            CustomText(
              text: text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
