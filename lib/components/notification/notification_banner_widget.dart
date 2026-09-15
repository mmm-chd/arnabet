import 'package:arena/models/notification/notification_banner_model.dart';
import 'package:flutter/material.dart';

/// Pure presentational widget for a single notification banner.
///
/// This widget has no animation or timing logic of its own — it simply
/// renders [model] plus a [progress] value (1.0 -> 0.0) that drives the
/// thin countdown bar at the bottom. Animation/timing lives one layer up,
/// in `NotificationBannerOverlay`, so this widget stays easy to preview,
/// test, and reuse (e.g. in a Storybook-style widget catalog).
class NotificationBannerWidget extends StatelessWidget {
  const NotificationBannerWidget({
    super.key,
    required this.model,
    this.progress = 1.0,
    this.onDismiss,
  });

  final NotificationBannerModel model;

  /// 1.0 = just shown, 0.0 = about to disappear.
  final double progress;

  /// Called after a tap, so the host can start the exit animation.
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final iconColor = model.iconColor ?? colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            model.onTap?.call();
            onDismiss?.call();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: model.iconBackground,
                        child: Icon(model.icon, color: iconColor, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    model.title,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (model.timestampLabel != null) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    model.timestampLabel!,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: colorScheme.outline,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              model.message,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Thin auto-dismiss countdown bar.
                SizedBox(
                  height: 2.5,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          Container(color: colorScheme.surfaceContainerHighest),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 120),
                            curve: Curves.linear,
                            width:
                                constraints.maxWidth * progress.clamp(0.0, 1.0),
                            color: colorScheme.primary,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
