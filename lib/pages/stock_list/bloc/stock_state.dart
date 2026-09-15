import 'package:arena/models/stock/dot_status_rule_model.dart';
import 'package:arena/models/stock/stock_list_model.dart';
import 'package:arena/models/stock/stock_status_rule_model.dart';
import 'package:equatable/equatable.dart';

enum StockListStatus {
  initial,
  loading,
  loadingMore,
  ready,
  submitting,
  success,
  failure,
}

class StockState extends Equatable {
  final StockListStatus status;

  final int totalStock;
  final int totalIn;
  final int totalOut;

  final List<StockListDatum> stocks;
  final List<Datum> dotStatusRules;
  final bool dotStatusRulesLoading;
  final List<StockStatusRuleItem> stockStatusRules;
  final bool stockStatusRulesLoading;
  final String? selectedStatusName;
  final String sortBy;

  final String? errorMessage;
  final int page;
  final int limit;
  final bool hasReachedMax;

  const StockState({
    this.status = StockListStatus.initial,
    this.totalStock = 0,
    this.totalIn = 0,
    this.totalOut = 0,
    this.stocks = const [],
    this.dotStatusRules = const [],
    this.dotStatusRulesLoading = false,
    this.stockStatusRules = const [],
    this.stockStatusRulesLoading = false,
    this.selectedStatusName,
    this.sortBy = 'expiry',
    this.errorMessage,
    this.page = 1,
    this.limit = 20,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [
    status,
    totalStock,
    totalIn,
    totalOut,
    stocks,
    dotStatusRules,
    dotStatusRulesLoading,
    stockStatusRules,
    stockStatusRulesLoading,
    selectedStatusName,
    sortBy,
    errorMessage,
    page,
    limit,
    hasReachedMax,
  ];

  StockState copyWith({
    StockListStatus? status,
    int? totalStock,
    int? totalIn,
    int? totalOut,
    List<StockListDatum>? stocks,
    List<Datum>? dotStatusRules,
    bool? dotStatusRulesLoading,
    List<StockStatusRuleItem>? stockStatusRules,
    bool? stockStatusRulesLoading,
    Object? selectedStatusName = _sentinel,
    Object? sortBy = _sentinel,
    Object? errorMessage = _sentinel,
    int? page,
    int? limit,
    bool? hasReachedMax,
  }) {
    return StockState(
      status: status ?? this.status,
      totalStock: totalStock ?? this.totalStock,
      totalIn: totalIn ?? this.totalIn,
      totalOut: totalOut ?? this.totalOut,
      stocks: List.unmodifiable(stocks ?? this.stocks),
      dotStatusRules: dotStatusRules ?? this.dotStatusRules,
      dotStatusRulesLoading:
          dotStatusRulesLoading ?? this.dotStatusRulesLoading,
      stockStatusRules: stockStatusRules ?? this.stockStatusRules,
      stockStatusRulesLoading:
          stockStatusRulesLoading ?? this.stockStatusRulesLoading,
      selectedStatusName: identical(selectedStatusName, _sentinel)
          ? this.selectedStatusName
          : selectedStatusName as String?,
      sortBy: identical(sortBy, _sentinel) ? this.sortBy : sortBy as String,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  bool get isLoading => status == StockListStatus.loading;
  bool get isLoadingMore => status == StockListStatus.loadingMore;
  bool get isReady => status == StockListStatus.ready;
  bool get isFailure => status == StockListStatus.failure;
}

const _sentinel = Object();
