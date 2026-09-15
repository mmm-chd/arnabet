// pages/history/bloc/history_bloc.dart
import 'package:arena/models/stock/stock_history_model.dart';
import 'package:arena/repositories/stock/stock_repository.dart';
import 'package:arena/usecases/stock/filter_history_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final StockRepository _repository;
  final FilterHistoryUseCase _filterHistoryUseCase;

  HistoryBloc({
    required StockRepository repository,
    FilterHistoryUseCase? filterHistoryUseCase,
  }) : _repository = repository,
       _filterHistoryUseCase = filterHistoryUseCase ?? FilterHistoryUseCase(),
       super(const HistoryState()) {
    on<LoadHistory>(_onLoadHistory);
    on<LoadMoreHistory>(_onLoadMoreHistory);
    on<FilterHistory>(_onFilterHistory);
    on<SearchHistory>(_onSearchHistory);
    on<ToggleExpand>(_onToggleExpand);
  }

  Future<void> _onLoadHistory(
    LoadHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(
      state.copyWith(
        status: HistoryStatus.loading,
        userId: event.userId,
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );
    try {
      final historyModel = await _repository.getStockHistory(
        page: 1,
        limit: state.limit,
        userId: event.userId,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      final rawData = historyModel.data ?? [];
      final totalPages = historyModel.meta?.pagination?.totalPages ?? 1;

      _sortByDateDesc(rawData);

      final filtered = _filterHistoryUseCase.execute(
        all: rawData,
        filter: state.selectedFilter,
        query: state.searchQuery,
      );

      emit(
        state.copyWith(
          status: HistoryStatus.ready,
          allHistories: rawData,
          filteredHistories: filtered,
          page: 1,
          hasReachedMax: 1 >= totalPages,
          expandedIndex: null,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HistoryStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onLoadMoreHistory(
    LoadMoreHistory event,
    Emitter<HistoryState> emit,
  ) async {
    if (!state.isReady || state.hasReachedMax || state.isLoadingMore) return;

    emit(state.copyWith(status: HistoryStatus.loadingMore));
    try {
      final result = await _fetchNextPage();
      final filtered = _filterHistoryUseCase.execute(
        all: result.combined,
        filter: state.selectedFilter,
        query: state.searchQuery,
      );

      emit(
        state.copyWith(
          status: HistoryStatus.ready,
          allHistories: result.combined,
          filteredHistories: filtered,
          page: result.page,
          hasReachedMax: result.hasReachedMax,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: HistoryStatus.ready));
    }
  }

  Future<void> _onFilterHistory(
    FilterHistory event,
    Emitter<HistoryState> emit,
  ) async {
    if (!state.isReady && !state.isLoadingMore) return;

    final newFilter = state.selectedFilter == event.filter
        ? "Semua"
        : event.filter;
    await _ensureFullyLoadedThenApply(emit, newFilter, state.searchQuery);
  }

  Future<void> _onSearchHistory(
    SearchHistory event,
    Emitter<HistoryState> emit,
  ) async {
    if (!state.isReady && !state.isLoadingMore) return;

    await _ensureFullyLoadedThenApply(emit, state.selectedFilter, event.query);
  }

  void _onToggleExpand(ToggleExpand event, Emitter<HistoryState> emit) {
    if (!state.isReady) return;

    emit(
      state.copyWith(
        expandedIndex: state.expandedIndex == event.index ? null : event.index,
      ),
    );
  }

  Future<void> _ensureFullyLoadedThenApply(
    Emitter<HistoryState> emit,
    String filter,
    String query,
  ) async {
    var combined = state.allHistories;
    var page = state.page;
    var hasReachedMax = state.hasReachedMax;

    if (!hasReachedMax) {
      emit(state.copyWith(status: HistoryStatus.loadingMore));
      try {
        while (!hasReachedMax) {
          final result = await _fetchNextPageFrom(combined, page);
          combined = result.combined;
          page = result.page;
          hasReachedMax = result.hasReachedMax;
        }
      } catch (e) {
        emit(
          state.copyWith(
            status: HistoryStatus.ready,
            errorMessage: e.toString().replaceAll("Exception: ", ""),
          ),
        );
        return;
      }
    }

    final filtered = _filterHistoryUseCase.execute(
      all: combined,
      filter: filter,
      query: query,
    );

    emit(
      state.copyWith(
        status: HistoryStatus.ready,
        allHistories: combined,
        selectedFilter: filter,
        searchQuery: query,
        filteredHistories: filtered,
        page: page,
        hasReachedMax: hasReachedMax,
        expandedIndex: null,
        errorMessage: null,
      ),
    );
  }

  Future<_PageResult> _fetchNextPage() =>
      _fetchNextPageFrom(state.allHistories, state.page);

  Future<_PageResult> _fetchNextPageFrom(
    List<dynamic> currentAll,
    int currentPage,
  ) async {
    final nextPage = currentPage + 1;
    final historyModel = await _repository.getStockHistory(
      page: nextPage,
      limit: state.limit,
      userId: state.userId,
      startDate: state.startDate,
      endDate: state.endDate,
    );
    final newData = historyModel.data ?? [];
    final totalPages = historyModel.meta?.pagination?.totalPages ?? nextPage;

    final combined = [...currentAll, ...newData].cast<StockHistoryDatum>();
    _sortByDateDesc(combined);

    return _PageResult(
      combined: combined,
      page: nextPage,
      hasReachedMax: nextPage >= totalPages || newData.isEmpty,
    );
  }

  void _sortByDateDesc(List<dynamic> list) {
    list.sort((a, b) {
      final dateA = a.createdAt;
      final dateB = b.createdAt;
      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;
      return dateB.compareTo(dateA);
    });
  }
}

class _PageResult {
  final List<StockHistoryDatum> combined;
  final int page;
  final bool hasReachedMax;

  _PageResult({
    required this.combined,
    required this.page,
    required this.hasReachedMax,
  });
}
