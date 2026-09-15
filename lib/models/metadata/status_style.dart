import 'package:flutter/material.dart';

class StatusStyle {
  final Color background;
  final Color foreground;
  final IconData? icon;
  final String? customIcon;

  const StatusStyle({
    required this.background,
    required this.foreground,
    this.icon,
    this.customIcon,
  });
}
