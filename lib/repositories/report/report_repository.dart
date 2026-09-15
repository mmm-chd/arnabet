import 'package:arena/models/report/summary_report_model.dart';
import 'package:arena/models/report/top_products_model.dart';
import 'package:arena/models/report/stock_movement_model.dart';
import 'package:arena/models/report/stock_health_model.dart';
import 'package:arena/services/report/report_summary_service.dart';
import 'package:arena/services/report/report_top_products_service.dart';
import 'package:arena/services/report/report_stock_movement_service.dart';
import 'package:arena/services/report/report_stock_health_service.dart';

class ReportRepository {
  final ReportSummaryService _summaryService;
  final ReportTopProductsService _topProductsService;
  final ReportStockHealthService _stockHealthService;
  final ReportStockMovementService _stockMovementService;

  ReportRepository({
    ReportSummaryService? summaryService,
    ReportTopProductsService? topProductsService,
    ReportStockHealthService? stockHealthService,
    ReportStockMovementService? stockMovementService,
  })  : _summaryService = summaryService ?? ReportSummaryService(),
        _topProductsService = topProductsService ?? ReportTopProductsService(),
        _stockHealthService = stockHealthService ?? ReportStockHealthService(),
        _stockMovementService = stockMovementService ?? ReportStockMovementService();

  Future<ReportSummaryModel> getSummary({
    required String period,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _summaryService.getSummary(
      period: period,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<TopProductsModel> getTopProducts({
    required String period,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _topProductsService.getTopProducts(
      period: period,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<StockHealthModel> getStockHealth({
    required String period,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _stockHealthService.getStockHealth(
      period: period,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<StockMovementModel> getStockMovement({
    required String period,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _stockMovementService.getStockMovement(
      period: period,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
