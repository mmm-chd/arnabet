import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/custom_timeline_item.dart';
import 'package:arena/pages/dashboard/owner/components/custom_calendar_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';

class CustomTimelineFilter extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final Function(DateTime, DateTime) onDateRangeSelected;
  final DateTime? startDate;
  final DateTime? endDate;
  final EdgeInsetsGeometry? padding;
  final List<String>? labels;
  final bool hideDatePicker;

  const CustomTimelineFilter({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    required this.onDateRangeSelected,
    this.startDate,
    this.endDate,
    this.padding,
    this.labels,
    this.hideDatePicker = true,
  });

  bool get isActive => startDate != null && endDate != null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: SupportAppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: (startDate == null && endDate == null)
                  ? CustomTimelineItem(
                      selectedIndex: selectedIndex,
                      onChanged: onChanged,
                      labels: labels ?? const ["1D", "1W", "1M", "6M", "1Y"],
                      isActive: !isActive,
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: SupportAppColors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text:
                                        startDate!.toIso8601String().split('T').first,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color:
                                              SupportAppColors.greyDarkerColor,
                                        ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward,
                                    size: 16,
                                    color: SupportAppColors.greyColor,
                                  ),
                                  CustomText(
                                    text:
                                        endDate!.toIso8601String().split('T').first,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color:
                                              SupportAppColors.greyDarkerColor,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          if (!hideDatePicker) ...[
            const CustomSpacing(width: 8),
            InkWell(
              onTap: () async {
                final result = await CustomCalendarBottomSheet.showRange(
                  context,
                  initialStart: startDate,
                  initialEnd: endDate,
                  initialPeriodIndex: selectedIndex,
                  periodLabels: labels ?? const ["1D", "1W", "1M", "6M", "1Y"],
                );

                if (result != null) {
                  if (result.isPeriodic) {
                    onChanged(result.periodIndex!);
                  } else {
                    onDateRangeSelected(result.start!, result.end!);
                  }
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Ink(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isActive
                      ? SupportAppColors.lightRed
                      : SupportAppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(
                    Icons.calendar_month_outlined,
                    size: 24,
                    color: isActive
                        ? SupportAppColors.normalRed
                        : SupportAppColors.greyDarkerColor,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
