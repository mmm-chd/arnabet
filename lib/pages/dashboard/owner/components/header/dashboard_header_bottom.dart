import 'package:arena/components/custom_timeline_filter.dart';
import 'package:flutter/material.dart';

class DashboardHeaderBottom extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final List<String>? labels;

  final Function(DateTime, DateTime) onDateRangeSelected;
  final DateTime? startDate;
  final DateTime? endDate;

  const DashboardHeaderBottom({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    required this.onDateRangeSelected,
    this.startDate,
    this.endDate,
    this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTimelineFilter(
      selectedIndex: selectedIndex,
      onChanged: onChanged,
      onDateRangeSelected: onDateRangeSelected,
      startDate: startDate,
      endDate: endDate,
      labels: labels,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
    );
  }
}
