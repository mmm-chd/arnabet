import 'package:arena/models/report/summary_report_model.dart';
import 'package:arena/models/report/top_products_model.dart';
import 'package:arena/models/report/stock_health_model.dart';
import 'package:arena/models/report/stock_movement_model.dart';
import 'package:equatable/equatable.dart';

enum ReportStatus { initial, loading, ready, failure }

class ReportState extends Equatable {
  final ReportStatus status;
  final ReportSummaryData? report;
  final TopProductsData? topProducts;
  final StockHealthData? stockHealth;
  final StockMovementData? stockMovement;
  final String? errorMessage;

  const ReportState({
    this.status = ReportStatus.initial,
    this.report,
    this.topProducts,
    this.stockHealth,
    this.stockMovement,
    this.errorMessage,
  });

  ReportState copyWith({
    ReportStatus? status,
    ReportSummaryData? report,
    TopProductsData? topProducts,
    StockHealthData? stockHealth,
    StockMovementData? stockMovement,
    Object? errorMessage = _sentinel,
  }) {
    return ReportState(
      status: status ?? this.status,
      report: report ?? this.report,
      topProducts: topProducts ?? this.topProducts,
      stockHealth: stockHealth ?? this.stockHealth,
      stockMovement: stockMovement ?? this.stockMovement,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  bool get isInitial => status == ReportStatus.initial;
  bool get isLoading => status == ReportStatus.loading;
  bool get isReady => status == ReportStatus.ready;
  bool get isFailure => status == ReportStatus.failure;

  @override
  List<Object?> get props => [
    status,
    report,
    topProducts,
    stockHealth,
    stockMovement,
    errorMessage,
  ];
}

const _sentinel = Object();
