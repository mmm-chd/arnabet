import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppSnackBar {
  static void success({
    required BuildContext context,
    required String message,
  }) {
    _show(
      context,
      message,
      SupportAppColors.normalGreen,
      textColor: SupportAppColors.lightGreen,
    );
  }

  static void error({required BuildContext context, required String message}) {
    _show(context, message, AppColors.error, textColor: SupportAppColors.white);
  }

  static void warning({
    required BuildContext context,
    required String message,
  }) {
    _show(
      context,
      message,
      SupportAppColors.lightMidOrange,
      textColor: SupportAppColors.normalOrange,
    );
  }

  static void info({required BuildContext context, required String message}) {
    _show(
      context,
      message,
      SupportAppColors.secondarySoftBlue,
      textColor: SupportAppColors.lightBlueHelper,
    );
  }

  static void _show(
    BuildContext context,
    String message,
    Color backgroundColor, {
    Color textColor = Colors.black,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyle(color: textColor)),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1200),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
  }
}
