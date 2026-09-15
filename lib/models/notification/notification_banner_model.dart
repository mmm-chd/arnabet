import 'package:flutter/material.dart';

@immutable
class NotificationBannerModel {
  const NotificationBannerModel({
    required this.title,
    required this.message,
    this.icon = Icons.notifications_rounded,
    this.iconBackground = const Color(0xFFEFF3FF),
    this.iconColor,
    this.timestampLabel,
    this.duration = const Duration(seconds: 3),
    this.onTap,
  });

  final String title;

  final String message;

  final IconData icon;

  final Color iconBackground;

  final Color? iconColor;

  final String? timestampLabel;

  final Duration duration;

  final VoidCallback? onTap;

  factory NotificationBannerModel.fromNotification({
    required String title,
    required String message,
    IconData icon = Icons.notifications_rounded,
    Color iconBackground = const Color(0xFFEFF3FF),
    VoidCallback? onTap,
  }) {
    return NotificationBannerModel(
      title: title,
      message: message,
      icon: icon,
      iconBackground: iconBackground,
      timestampLabel: 'Baru saja',
      onTap: onTap,
    );
  }
}