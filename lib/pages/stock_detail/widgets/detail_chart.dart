import 'package:arena/components/charts/double_bar_chart.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_timeline_item.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';

class DetailChart extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const DetailChart({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        DoubleBarChart(bottomLeft: 0, bottomRight: 0),
        CustomSpacing(height: 2),
        Container(
          height: 48,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: SupportAppColors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: CustomTimelineItem(
            selectedIndex: selectedIndex,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
