import 'package:arena/models/stock/stock_history_model.dart';
import 'package:equatable/equatable.dart';

enum HistoryStatus { initial, loading, loadingMore, ready, failure }

class HistoryState extends Equatable {
  final HistoryStatus status;

  final List<StockHistoryDatum> allHistories;
  final List<StockHistoryDatum> filteredHistories;

  final int? expandedIndex;
  final String selectedFilter;
  final String searchQuery;
  final String? userId;
  final String? startDate;
  final String? endDate;

  final int page;
  final int limit;
  final bool hasReachedMax;

  final String? errorMessage;

  const HistoryState({
    this.status = HistoryStatus.initial,
    this.allHistories = const [],
    this.filteredHistories = const [],
    this.expandedIndex,
    this.selectedFilter = "Semua",
    this.searchQuery = "",
    this.userId,
    this.startDate,
    this.endDate,
    this.page = 1,
    this.limit = 20,
    this.hasReachedMax = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    status,
    allHistories,
    filteredHistories,
    expandedIndex,
    selectedFilter,
    searchQuery,
    userId,
    startDate,
    endDate,
    page,
    limit,
    hasReachedMax,
    errorMessage,
  ];

  HistoryState copyWith({
    HistoryStatus? status,
    List<StockHistoryDatum>? allHistories,
    List<StockHistoryDatum>? filteredHistories,
    Object? expandedIndex = _sentinel,
    String? selectedFilter,
    String? searchQuery,
    Object? userId = _sentinel,
    Object? startDate = _sentinel,
    Object? endDate = _sentinel,
    int? page,
    int? limit,
    bool? hasReachedMax,
    Object? errorMessage = _sentinel,
  }) {
    return HistoryState(
      status: status ?? this.status,
      allHistories: allHistories ?? this.allHistories,
      filteredHistories: filteredHistories ?? this.filteredHistories,
      expandedIndex: identical(expandedIndex, _sentinel)
          ? this.expandedIndex
          : expandedIndex as int?,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      userId: identical(userId, _sentinel) ? this.userId : userId as String?,
      startDate: identical(startDate, _sentinel)
          ? this.startDate
          : startDate as String?,
      endDate: identical(endDate, _sentinel)
          ? this.endDate
          : endDate as String?,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  bool get isLoading => status == HistoryStatus.loading;
  bool get isLoadingMore => status == HistoryStatus.loadingMore;
  bool get isReady => status == HistoryStatus.ready;
  bool get isFailure => status == HistoryStatus.failure;
  bool get isEmpty => isReady && filteredHistories.isEmpty;
}

const _sentinel = Object();
