import 'dart:async';

import 'package:arena/components/custom_button.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomsheet {
  static void show(
    BuildContext context, {
    String? title,
    ValueNotifier<bool>? selected,
    required List<Widget> children,
    FutureOr<bool?> Function()? onPressed,
    required VoidCallback onDismissed,
    VoidCallback? onReset,
    String? primaryButtonText,
    secondaryButtonText,
    Color? sBorderColor,
    sForegroundColor,
    sBackgroundColor,
    Color? pForegroundColor,
    pBackgroundColor,
    double? initialChildSize,
    bool? hideHeader,
  }) {
    final screen = MediaQuery.of(context).size;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: SupportAppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            top: false,
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: initialChildSize ?? 0.65,
              minChildSize: 0.3,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: Column(
                    children: [
                      Column(
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
                          hideHeader != null && hideHeader == true
                              ? const SizedBox.shrink()
                              : Column(
                                  children: [
                                    CustomText(
                                      text: title ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Divider(height: 1, color: Colors.grey.shade300),
                      ),

                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: children,
                          ),
                        ),
                      ),

                      _buildButtonArea(
                        context,
                        selected,
                        onPressed,
                        onReset,
                        primaryButtonText,
                        secondaryButtonText,
                        sBorderColor,
                        sForegroundColor,
                        sBackgroundColor,
                        pForegroundColor,
                        pBackgroundColor,
                      ),
                    ],
                  ),
                );
              },
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

  static Widget _buildButtonArea(
    BuildContext context,
    ValueNotifier<bool>? selected,
    VoidCallback? onPressed,
    VoidCallback? onReset,
    String? primaryButtonText,
    secondaryButtonText,
    Color? sBorderColor,
    sForegroundColor,
    sBackgroundColor,
    Color? pForegroundColor,
    pBackgroundColor,
  ) {
    Widget buildContent(bool isSelected) {
      return AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: onPressed != null && !isSelected
            ? Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
                decoration: BoxDecoration(
                  color: SupportAppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: onReset != null
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
                      ),
              )
            : const SizedBox.shrink(),
      );
    }

    if (selected == null) {
      return buildContent(false);
    }

    return ValueListenableBuilder<bool>(
      valueListenable: selected,
      builder: (context, isSelected, _) => buildContent(isSelected),
    );
  }

  static Widget _buildTwoButtons(
    BuildContext context,
    VoidCallback onPressed,
    VoidCallback onReset,
    String? primaryButtonText,
    secondaryButtonText,
    Color? sBorderColor,
    sForegroundColor,
    sBackgroundColor,
    Color? pForegroundColor,
    pBackgroundColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: CustomButton(
            text: secondaryButtonText ?? 'Reset',
            backgroundColor: sBackgroundColor ?? SupportAppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
              side: BorderSide(color: sBorderColor ?? AppColors.primary),
            ),
            foregroundColor: sForegroundColor ?? AppColors.primary,
            onPressed: () {
              onReset();
              context.pop(false);
            },
          ),
        ),
        const CustomSpacing(width: 16),
        Expanded(
          child: CustomButton(
            text: primaryButtonText ?? 'Tampilkan',
            backgroundColor: pBackgroundColor ?? AppColors.primary,
            foregroundColor: pForegroundColor ?? SupportAppColors.white,
            onPressed: () {
              onPressed();
              context.pop(true);
            },
          ),
        ),
      ],
    );
  }

  static Widget _buildOneButton(
    BuildContext context,
    VoidCallback onPressed,
    String? primaryButtonText,
    Color? pForegroundColor,
    pBackgroundColor,
  ) {
    return CustomButton(
      text: primaryButtonText ?? 'Apply',
      backgroundColor: pBackgroundColor ?? AppColors.primary,
      foregroundColor: pForegroundColor ?? SupportAppColors.white,
      onPressed: () {
        onPressed();
        context.pop(true);
      },
    );
  }
}
