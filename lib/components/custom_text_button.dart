import 'package:flutter/material.dart';

class CustomTextbutton extends StatelessWidget {
  final String text;
  final double? margin;
  final Color? foregroundColor;
  final VoidCallback? onPressed;
  final OutlinedBorder? shape;

  const CustomTextbutton({
    super.key,
    required this.text,
    this.margin,
    this.foregroundColor,
    this.onPressed,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: margin ?? 0.0),
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: foregroundColor,
          padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 32.0),
          shape:
              shape ??
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        ),
        child: Text(text, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
