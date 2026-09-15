import 'dart:async';

import 'package:arena/components/custom_button.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDialog {
  static Future<bool?> show(
    BuildContext context, {
    String? title,
    String? message,
    List<Widget>? children,
    Widget? icon,
    FutureOr<bool?> Function()? onPressed,
    VoidCallback? onReset,
    VoidCallback? onDismissed,
    String? primaryButtonText,
    String? secondaryButtonText,
    Color? sBorderColor,
    Color? sForegroundColor,
    Color? sBackgroundColor,
    Color? pForegroundColor,
    Color? pBackgroundColor,
    bool barrierDismissible = true,
  }) {
    final hasSecondary = secondaryButtonText != null || onReset != null;

    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: SupportAppColors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (icon != null) ...[
                  Center(child: icon),
                  const CustomSpacing(height: 16),
                ],
                if (title != null)
                  CustomText(
                    text: title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (message != null) ...[
                          const CustomSpacing(height: 8),
                          CustomText(
                            text: message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: SupportAppColors.greyDarkColor,
                            ),
                          ),
                        ],
                        if (children != null) ...[
                          const CustomSpacing(height: 16),
                          ...children,
                        ],
                      ],
                    ),
                  ),
                ),
                if (onPressed != null) ...[
                  const CustomSpacing(height: 24),
                  hasSecondary
                      ? _buildTwoButtons(
                          dialogContext,
                          onPressed,
                          onReset,
                          primaryButtonText,
                          secondaryButtonText,
                          sBorderColor,
                          sForegroundColor,
                          sBackgroundColor,
                          pForegroundColor,
                          pBackgroundColor,
                        )
                      : _buildOneButton(
                          dialogContext,
                          onPressed,
                          primaryButtonText,
                          pForegroundColor,
                          pBackgroundColor,
                        ),
                ],
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if (value != true && onDismissed != null) {
        Future.delayed(const Duration(milliseconds: 300), onDismissed);
      }
      return value;
    });
  }

  static Future<bool?> confirmDelete(
    BuildContext context, {
    required String title,
    required String message,
    String primaryButtonText = 'Hapus',
    String secondaryButtonText = 'Batal',
    FutureOr<bool?> Function()? onPressed,
  }) {
    return show(
      context,
      title: title,
      message: message,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      pBackgroundColor: AppColors.error,
      sBorderColor: SupportAppColors.greyMidColor,
      sForegroundColor: SupportAppColors.greyDarkerColor,
      onPressed: onPressed ?? () => true,
    );
  }

  static Future<bool?> info(
    BuildContext context, {
    String? title,
    String? message,
    List<Widget>? children,
    String primaryButtonText = 'Mengerti',
  }) {
    return show(
      context,
      title: title,
      message: message,
      children: children,
      primaryButtonText: primaryButtonText,
      onPressed: () => true,
    );
  }

  static Future<void> _handlePrimaryPressed(
    BuildContext context,
    FutureOr<bool?> Function() onPressed,
  ) async {
    final result = await onPressed();
    final shouldClose = result ?? true;
    if (shouldClose && context.mounted) context.pop(true);
  }

  static Widget _buildTwoButtons(
    BuildContext context,
    FutureOr<bool?> Function() onPressed,
    VoidCallback? onReset,
    String? primaryButtonText,
    String? secondaryButtonText,
    Color? sBorderColor,
    Color? sForegroundColor,
    Color? sBackgroundColor,
    Color? pForegroundColor,
    Color? pBackgroundColor,
  ) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            width: 4,
            text: secondaryButtonText ?? 'Batal',
            backgroundColor: sBackgroundColor ?? SupportAppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(
                color: sBorderColor ?? AppColors.primary,
                width: 0.5,
              ),
            ),
            foregroundColor: sForegroundColor ?? AppColors.primary,
            fontSize: 16,
            elevation: 0,
            onPressed: () {
              onReset?.call();
              context.pop(false);
            },
          ),
        ),
        const CustomSpacing(width: 12),
        Expanded(
          child: CustomButton(
            width: 4,
            text: primaryButtonText ?? 'Simpan',
            backgroundColor: pBackgroundColor ?? AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            foregroundColor: pForegroundColor ?? SupportAppColors.white,
            fontSize: 16,
            elevation: 0,
            onPressed: () => _handlePrimaryPressed(context, onPressed),
          ),
        ),
      ],
    );
  }

  static Widget _buildOneButton(
    BuildContext context,
    FutureOr<bool?> Function() onPressed,
    String? primaryButtonText,
    Color? pForegroundColor,
    Color? pBackgroundColor,
  ) {
    return CustomButton(
      text: primaryButtonText ?? 'Mengerti',
      backgroundColor: pBackgroundColor ?? AppColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      foregroundColor: pForegroundColor ?? SupportAppColors.white,
      fontSize: 16,
      elevation: 0,
      onPressed: () => _handlePrimaryPressed(context, onPressed),
    );
  }
}
