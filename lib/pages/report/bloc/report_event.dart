import 'package:equatable/equatable.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object?> get props => [];
}

class LoadReportSummary extends ReportEvent {
  final String period;
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadReportSummary({required this.period, this.startDate, this.endDate});

  @override
  List<Object?> get props => [period, startDate, endDate];
}


class LoadTopProducts extends ReportEvent {
  final String period;
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadTopProducts({
    required this.period,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [period, startDate, endDate];
}

class LoadStockHealth extends ReportEvent {
  final String period;
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadStockHealth({
    required this.period,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [period, startDate, endDate];
}

class LoadStockMovement extends ReportEvent {
  final String period;
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadStockMovement({
    required this.period,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [period, startDate, endDate];
}

class ClearInactiveReportData extends ReportEvent {
  final int activeTab;

  const ClearInactiveReportData({required this.activeTab});

  @override
  List<Object?> get props => [activeTab];
}
