import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeThumbColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
  final Color? trackOutlineColor;
  final double? trackOutlineWidth;

  const CustomSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.activeThumbColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.trackOutlineColor = Colors.transparent,
    this.trackOutlineWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: activeThumbColor,
      activeTrackColor: activeTrackColor,
      inactiveThumbColor: inactiveThumbColor,
      inactiveTrackColor: inactiveTrackColor,
      trackOutlineColor: trackOutlineColor != null
          ? WidgetStatePropertyAll(trackOutlineColor)
          : null,
      trackOutlineWidth: trackOutlineWidth != null
          ? WidgetStatePropertyAll(trackOutlineWidth)
          : null,
    );
  }
}
