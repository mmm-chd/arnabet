import 'dart:async';

import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomSheetV2 {
  static Future<bool?> show(
    BuildContext context, {
    String? title,
    List<Widget>? children,
    Widget? child,
    bool isScrollable = false,
    FutureOr<bool?> Function()? onSave,
    VoidCallback? onRefresh,
    ValueListenable<bool>? isRefreshing,
    VoidCallback? onCancel,
    VoidCallback? onDismissed,
    String cancelText = 'Batal',
    String saveText = 'Simpan',
    ValueNotifier<bool>? isSaveEnabled,
    bool hideHeader = false,
    Color? cancelColor,
    Color? saveColor,
    double initialChildSize = 0.69,
    double minChildSize = 0.2,
    double maxChildSize = 1.0,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: SupportAppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final screen = MediaQuery.of(sheetContext).size;

        final content =
            child ??
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children ?? const [],
            );

        return AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: SafeArea(
            top: false,
            child: isScrollable
                ? DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: initialChildSize,
                    minChildSize: minChildSize,
                    maxChildSize: maxChildSize,
                    builder: (context, scrollController) {
                      return Column(
                        children: [
                          _buildHeader(
                            sheetContext,
                            screen,
                            title,
                            hideHeader,
                            onSave,
                            onRefresh,
                            isRefreshing,
                            onCancel,
                            cancelText,
                            saveText,
                            isSaveEnabled,
                            cancelColor,
                            saveColor,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              controller: scrollController,
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                16,
                                16,
                                24,
                              ),
                              child: content,
                            ),
                          ),
                        ],
                      );
                    },
                  )
                : ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: screen.height * 0.9),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHeader(
                          sheetContext,
                          screen,
                          title,
                          hideHeader,
                          onSave,
                          onRefresh,
                          isRefreshing,
                          onCancel,
                          cancelText,
                          saveText,
                          isSaveEnabled,
                          cancelColor,
                          saveColor,
                        ),
                        Flexible(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                            child: content,
                          ),
                        ),
                      ],
                    ),
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

  static Widget _buildHeader(
    BuildContext context,
    Size screen,
    String? title,
    bool hideHeader,
    FutureOr<bool?> Function()? onSave,
    VoidCallback? onRefresh,
    ValueListenable<bool>? isRefreshing,
    VoidCallback? onCancel,
    String cancelText,
    String saveText,
    ValueNotifier<bool>? isSaveEnabled,
    Color? cancelColor,
    Color? saveColor,
  ) {
    return Column(
      children: [
        const CustomSpacing(height: 12),
        Container(
          width: screen.width / 6,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        if (!hideHeader) ...[
          const CustomSpacing(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _buildAction(
                      text: cancelText,
                      color: cancelColor ?? SupportAppColors.greyDarkColor,
                      fontWeight: FontWeight.w500,
                      onTap: () {
                        onCancel?.call();
                        context.pop(false);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: CustomText(
                    text: title ?? '',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                Flexible(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: onRefresh != null
                        ? _buildRefreshAction(onRefresh, isRefreshing)
                        : onSave == null
                        ? const SizedBox.shrink()
                        : _buildSaveAction(
                            context,
                            onSave,
                            saveText,
                            isSaveEnabled,
                            saveColor,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const CustomSpacing(height: 12),
        Divider(height: 1, color: Colors.grey.shade300),
      ],
    );
  }

  static Widget _buildSaveAction(
    BuildContext context,
    FutureOr<bool?> Function() onSave,
    String saveText,
    ValueNotifier<bool>? isSaveEnabled,
    Color? saveColor,
  ) {
    Widget build(bool enabled) {
      return _buildAction(
        text: saveText,
        color: enabled
            ? (saveColor ?? AppColors.primary)
            : SupportAppColors.greyColor,
        fontWeight: FontWeight.w600,
        onTap: enabled ? () => _handleSave(context, onSave) : null,
      );
    }

    if (isSaveEnabled == null) return build(true);

    return ValueListenableBuilder<bool>(
      valueListenable: isSaveEnabled,
      builder: (context, enabled, _) => build(enabled),
    );
  }

  static Widget _buildRefreshAction(
    VoidCallback onRefresh,
    ValueListenable<bool>? isRefreshing,
  ) {
    Widget build(bool refreshing) {
      return InkWell(
        onTap: refreshing ? null : onRefresh,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (refreshing)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
              else
                const Icon(
                  Icons.refresh_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              const CustomSpacing(width: 4),
              const CustomText(
                text: 'Refresh',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (isRefreshing == null) return build(false);

    return ValueListenableBuilder<bool>(
      valueListenable: isRefreshing,
      builder: (context, refreshing, _) => build(refreshing),
    );
  }

  static Widget _buildAction({
    required String text,
    required Color color,
    required FontWeight fontWeight,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: CustomText(
          text: text,
          maxLines: 1,
          style: TextStyle(fontSize: 15, color: color, fontWeight: fontWeight),
        ),
      ),
    );
  }

  static Future<void> _handleSave(
    BuildContext context,
    FutureOr<bool?> Function() onSave,
  ) async {
    final result = await onSave();
    final shouldClose = result ?? true;
    if (shouldClose && context.mounted) context.pop(true);
  }
}
