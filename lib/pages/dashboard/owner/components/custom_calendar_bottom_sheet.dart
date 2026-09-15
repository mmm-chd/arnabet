import 'package:arena/components/custom_button.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/custom_timeline_item.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangeResult {
  final DateTime? start;
  final DateTime? end;
  final int? periodIndex;

  DateRangeResult(this.start, this.end) : periodIndex = null;

  DateRangeResult.period(int index)
    : periodIndex = index,
      start = null,
      end = null;

  bool get isPeriodic => periodIndex != null;
}

(DateTime, DateTime) _rangeForPeriod(int index) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  switch (index) {
    case 0:
      return (today, today);
    case 1:
      return (today.subtract(const Duration(days: 6)), today);
    case 2:
      return (DateTime(now.year, now.month - 1, now.day), today);
    case 3:
      return (DateTime(now.year, now.month - 6, now.day), today);
    case 4:
      return (DateTime(now.year - 1, now.month, now.day), today);
    default:
      return (today, today);
  }
}

class CustomCalendarBottomSheet {
  static Future<DateRangeResult?> showRange(
    BuildContext context, {
    DateTime? initialStart,
    DateTime? initialEnd,
    int? initialPeriodIndex,
    List<String>? periodLabels,
  }) {
    return showModalBottomSheet<DateRangeResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: SupportAppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _RangeCalendarBottomSheet(
        initialStart: initialStart,
        initialEnd: initialEnd,
        initialPeriodIndex: initialPeriodIndex,
        periodLabels: periodLabels,
      ),
    );
  }
}

class _RangeCalendarBottomSheet extends StatefulWidget {
  final DateTime? initialStart;
  final DateTime? initialEnd;
  final int? initialPeriodIndex;
  final List<String>? periodLabels;

  const _RangeCalendarBottomSheet({
    this.initialStart,
    this.initialEnd,
    this.initialPeriodIndex,
    this.periodLabels,
  });

  @override
  State<_RangeCalendarBottomSheet> createState() =>
      _RangeCalendarBottomSheetState();
}

class _RangeCalendarBottomSheetState extends State<_RangeCalendarBottomSheet> {
  late DateTime? startDate;
  late DateTime? endDate;
  late final DateRangePickerController _controller;

  bool get _hasRange => startDate != null && endDate != null;

  String _format(DateTime d) => "${d.day}/${d.month}/${d.year}";

  @override
  void initState() {
    super.initState();
    startDate = widget.initialStart;
    endDate = widget.initialEnd;
    _controller = DateRangePickerController();
    if (startDate != null && endDate != null) {
      _controller.selectedRange = PickerDateRange(startDate, endDate);
    } else if (widget.initialPeriodIndex != null) {
      final (s, e) = _rangeForPeriod(widget.initialPeriodIndex!);
      startDate = s;
      endDate = e;
      _controller.selectedRange = PickerDateRange(s, e);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _reset() {
    setState(() {
      startDate = null;
      endDate = null;
    });
    _controller.selectedRange = null;
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      child: Container(
        height: screen.height * 0.72,
        decoration: const BoxDecoration(
          color: SupportAppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const CustomSpacing(height: 12),

            /// drag handle
            Container(
              width: screen.width / 6,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(24),
              ),
            ),

            const CustomSpacing(height: 12),

            /// header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const CustomText(
                    text: "Pilih Rentang Tanggal",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: SupportAppColors.greyDarkerColor,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.close,
                        size: 22,
                        color: SupportAppColors.greyDarkColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const CustomSpacing(height: 12),
            const Divider(height: 1, color: SupportAppColors.greyMidColor),
            const CustomSpacing(height: 12),

            /// periodic filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 48,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: SupportAppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: SupportAppColors.greyMidColor),
                ),
                child: CustomTimelineItem(
                  selectedIndex: widget.initialPeriodIndex ?? -1,
                  onChanged: (index) =>
                      Navigator.pop(context, DateRangeResult.period(index)),
                  labels:
                      widget.periodLabels ??
                      const ["1D", "1W", "1M", "6M", "1Y"],
                ),
              ),
            ),

            const CustomSpacing(height: 12),

            /// selected range summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: SupportAppColors.greyMidTermColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 18,
                      color: SupportAppColors.greyDarkColor,
                    ),
                    const CustomSpacing(width: 8),
                    Expanded(
                      child: _RangeLabel(
                        label: "Mulai",
                        value: startDate != null
                            ? _format(startDate!)
                            : "--/--/----",
                      ),
                    ),
                    const CustomSpacing(width: 8),
                    const Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: SupportAppColors.greyColor,
                    ),
                    const CustomSpacing(width: 8),
                    Expanded(
                      child: _RangeLabel(
                        label: "Selesai",
                        value: endDate != null
                            ? _format(endDate!)
                            : "--/--/----",
                        alignEnd: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const CustomSpacing(height: 12),

            /// calendar
            Expanded(
              child: SfDateRangePicker(
                controller: _controller,
                selectionMode: DateRangePickerSelectionMode.range,
                backgroundColor: Colors.transparent,
                onSelectionChanged: (args) {
                  final range = args.value as PickerDateRange;
                  setState(() {
                    startDate = range.startDate;
                    endDate = range.endDate;
                  });
                },
                todayHighlightColor: AppColors.primary,
                startRangeSelectionColor: AppColors.primary,
                endRangeSelectionColor: AppColors.primary,
                rangeSelectionColor: AppColors.primary.withValues(alpha: 0.25),
                selectionShape: DateRangePickerSelectionShape.circle,
                monthViewSettings: const DateRangePickerMonthViewSettings(
                  showTrailingAndLeadingDates: true,
                ),
                headerStyle: const DateRangePickerHeaderStyle(
                  textAlign: TextAlign.center,
                  backgroundColor: Colors.transparent,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: SupportAppColors.greyDarkerColor,
                  ),
                ),
              ),
            ),

            const CustomSpacing(height: 12),

            /// actions
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  TextButton(
                    onPressed: _hasRange ? _reset : null,
                    style: TextButton.styleFrom(
                      foregroundColor: SupportAppColors.greyDarkColor,
                      disabledForegroundColor: SupportAppColors.greyColor,
                    ),
                    child: const CustomText(
                      text: "Reset",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const CustomSpacing(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: "Pilih",
                      backgroundColor: _hasRange
                          ? AppColors.primary
                          : SupportAppColors.greyMidColor,
                      foregroundColor: Colors.white,
                      onPressed: _hasRange
                          ? () {
                              Navigator.pop(
                                context,
                                DateRangeResult(startDate!, endDate!),
                              );
                            }
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RangeLabel extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;

  const _RangeLabel({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    final alignment = alignEnd
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: alignment,
      children: [
        CustomText(
          text: label,
          style: const TextStyle(
            fontSize: 10,
            color: SupportAppColors.greyColor,
          ),
        ),
        CustomText(
          text: value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: SupportAppColors.greyDarkerColor,
          ),
        ),
      ],
    );
  }
}
