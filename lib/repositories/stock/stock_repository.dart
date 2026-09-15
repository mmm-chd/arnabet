import 'package:arena/models/stock/add_stock_model.dart';
import 'package:arena/models/stock/adjust_stock_model.dart';
import 'package:arena/models/stock/dot_status_rule_model.dart';
import 'package:arena/models/stock/stock_detail_model.dart';
import 'package:arena/models/stock/stock_history_model.dart';
import 'package:arena/models/stock/stock_list_model.dart';
import 'package:arena/models/stock/stock_status_rule_model.dart';
import 'package:arena/models/stock/update_stock_request_model.dart';
import 'package:arena/models/stock/update_stock_response_model.dart';
import 'package:arena/services/stocks/add_stock_service.dart';
import 'package:arena/services/stocks/adjust_stock_service.dart';
import 'package:arena/services/stocks/dot_status_rule_service.dart';
import 'package:arena/services/stocks/stock_detail_service.dart';
import 'package:arena/services/stocks/stock_history_service.dart';
import 'package:arena/services/stocks/stock_list_service.dart';
import 'package:arena/services/stocks/stock_status_rule_service.dart';
import 'package:arena/services/stocks/update_stock_service.dart';

class StockRepository {
  final StockListService _stockListService;
  final StockDetailService _stockDetailService;
  final AddStockService _addStockService;
  final AdjustStockService _adjustStockService;
  final UpdateStockService _updateStockService;
  final StockHistoryService _stockHistoryService;
  final DotStatusRuleService _dotStatusRuleService;
  final StockStatusRuleService _stockStatusRuleService;

  StockRepository({
    StockListService? stockListService,
    StockDetailService? stockDetailService,
    AddStockService? addStockService,
    AdjustStockService? adjustStockService,
    UpdateStockService? updateStockService,
    StockHistoryService? stockHistoryService,
    DotStatusRuleService? dotStatusRuleService,
    StockStatusRuleService? stockStatusRuleService,
  }) : _stockListService = stockListService ?? StockListService(),
       _stockDetailService = stockDetailService ?? StockDetailService(),
       _addStockService = addStockService ?? AddStockService(),
       _adjustStockService = adjustStockService ?? AdjustStockService(),
       _updateStockService = updateStockService ?? UpdateStockService(),
       _stockHistoryService = stockHistoryService ?? StockHistoryService(),
       _dotStatusRuleService = dotStatusRuleService ?? DotStatusRuleService(),
       _stockStatusRuleService =
           stockStatusRuleService ?? StockStatusRuleService();

  Future<StockListModel> getStocks({
    required String stockStatus,
    required String search,
    required String brandName,
    required String sortBy,
    required int limit,
    required int page,
  }) => _stockListService.getStocks(
    stockStatus: stockStatus,
    search: search,
    brandName: brandName,
    sortBy: sortBy,
    limit: limit,
    page: page,
  );

  Future<StockDetailModel> getStockDetail(String productId) {
    return _stockDetailService.getStockDetail(productId);
  }

  Future<AddStockModel> addStock({
    required String productId,
    required String note,
    required List<Map<String, dynamic>> stockBatches,
  }) {
    return _addStockService.addStock(
      productId: productId,
      note: note,
      stockBatches: stockBatches,
    );
  }

  Future<AdjustStockModel> adjustStock({
    required String stockId,
    required int newQuantity,
    required String reason,
  }) {
    return _adjustStockService.adjustStock(
      stockId: stockId,
      newQuantity: newQuantity,
      reason: reason,
    );
  }

  Future<StockHistoryModel> getStockHistory({
    String search = '',
    String type = '',
    int page = 1,
    int limit = 10,
    String? userId,
    String? startDate,
    String? endDate,
  }) => _stockHistoryService.getStockHistory(
    search: search,
    type: type,
    page: page,
    limit: limit,
    userId: userId,
    startDate: startDate,
    endDate: endDate,
  );

  Future<UpdateStockResponseModel> updateStock(
    String stockId,
    UpdateStockRequestModel request,
  ) {
    return _updateStockService.updateStock(stockId, request);
  }

  Future<DotStatusRuleModel> getDotStatusRules() =>
      _dotStatusRuleService.getDotStatusRules();

  Future<String> updateDotStatusRule({
    required String id,
    int? minMonth,
    int? maxMonth,
  }) => _dotStatusRuleService.updateDotStatusRule(
    id: id,
    minMonth: minMonth,
    maxMonth: maxMonth,
  );

  Future<StockStatusRuleModel> getStockStatusRules() =>
      _stockStatusRuleService.getStockStatusRules();

  Future<String> updateStockStatusRule({
    required String id,
    int? minQty,
    int? maxQty,
  }) => _stockStatusRuleService.updateStockStatusRule(
    id: id,
    minQty: minQty,
    maxQty: maxQty,
  );
}
