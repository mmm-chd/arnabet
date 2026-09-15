import 'dart:async';

import 'package:arena/components/custom_button.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomsheetfix {
  static void show(
    BuildContext context, {
    String? title,
    required List<Widget> children,
    FutureOr<bool?> Function()? onPressed,
    required VoidCallback onDismissed,
    VoidCallback? onReset,
    String? primaryButtonText,
    dynamic secondaryButtonText,
    Color? sBorderColor,
    dynamic sForegroundColor,
    dynamic sBackgroundColor,
    Color? pForegroundColor,
    dynamic pBackgroundColor,
    double? initialChildSize,
    bool? hideHeader,
    bool isScrollable = true,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final screen = MediaQuery.of(context).size;

        Widget buildScrollableContent(ScrollController? scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          );
        }

        Widget buildBody(ScrollController? scrollController) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Column(
              mainAxisSize: isScrollable ? MainAxisSize.max : MainAxisSize.min,
              children: [
                Container(
                  width: screen.width / 6,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                const CustomSpacing(height: 12),
                if (hideHeader != true)
                  CustomText(
                    text: title ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, color: Colors.grey.shade300),
                ),
                if (isScrollable)
                  Expanded(child: buildScrollableContent(scrollController))
                else
                  Flexible(child: buildScrollableContent(null)),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 18),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: onPressed != null
                        ? onReset != null
                              ? _buildTwoButtons(
                                  context,
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
                                  context,
                                  onPressed,
                                  primaryButtonText,
                                  pForegroundColor,
                                  pBackgroundColor,
                                )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          );
        }

        return AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            top: false,
            child: isScrollable
                ? DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: initialChildSize ?? 0.69,
                    minChildSize: 0.2,
                    maxChildSize: 1,
                    builder: (context, scrollController) =>
                        buildBody(scrollController),
                  )
                : ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: screen.height * 0.9),
                    child: buildBody(null),
                  ),
          ),
        );
      },
    ).then((value) {
      if (value != true) {
        Future.delayed(const Duration(milliseconds: 300), () {
          onDismissed();
        });
      }
    });
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
    VoidCallback onReset,
    String? primaryButtonText,
    dynamic secondaryButtonText,
    Color? sBorderColor,
    dynamic sForegroundColor,
    dynamic sBackgroundColor,
    Color? pForegroundColor,
    dynamic pBackgroundColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: CustomButton(
            height: 0,
            text: secondaryButtonText ?? 'Batal',
            backgroundColor: sBackgroundColor ?? Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(
                color: sBorderColor ?? AppColors.primary,
                width: 0.5,
              ),
            ),
            foregroundColor: sForegroundColor ?? AppColors.primary,
            fontSize: 16,
            onPressed: onReset,
          ),
        ),
        const CustomSpacing(width: 16),
        Expanded(
          child: CustomButton(
            text: primaryButtonText ?? 'Simpan',
            backgroundColor: pBackgroundColor ?? AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(color: sBorderColor ?? AppColors.primary),
            ),
            foregroundColor: pForegroundColor ?? Colors.white,
            fontSize: 16,
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
    dynamic pBackgroundColor,
  ) {
    return CustomButton(
      text: primaryButtonText ?? 'Simpan',
      backgroundColor: pBackgroundColor ?? Colors.amber,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      foregroundColor: pForegroundColor ?? Colors.white,
      onPressed: () => _handlePrimaryPressed(context, onPressed),
    );
  }
}
