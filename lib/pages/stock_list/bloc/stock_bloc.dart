import 'package:arena/models/stock/stock_list_model.dart';
import 'package:arena/repositories/stock/stock_repository.dart';
import 'package:arena/usecases/stock/filter_stocks_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'stock_event.dart';
import 'stock_state.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  final StockRepository _repository;
  final FilterStocksUseCase _filterStocksUseCase;

  String? _currentStatusName;
  String _currentSearch = '';
  String? _currentBrandName;
  String _currentSortBy = 'expiry';

  List<StockListDatum> allStocks = [];

  StockBloc({
    required StockRepository repository,
    FilterStocksUseCase? filterStocksUseCase,
  }) : _repository = repository,
       _filterStocksUseCase = filterStocksUseCase ?? FilterStocksUseCase(),
       super(StockState()) {
    on<LoadStock>(_loadStocks);
    on<LoadMoreStocks>(_onLoadMoreStocks);
    on<LoadDotStatusRules>(_loadDotStatusRules);
    on<UpdateDotStatusRule>(_updateDotStatusRule);
    on<LoadStockStatusRules>(_loadStockStatusRules);
    on<UpdateStockStatusRule>(_updateStockStatusRule);
    on<CreateStock>(_createStock);
    on<FilterStock>(_filterStocks);
    on<SearchStock>(_filterStocks);
    on<ChangeSortBy>(_changeSortBy);
  }

  Future<void> _loadStocks(LoadStock event, Emitter<StockState> emit) async {
    emit(state.copyWith(status: StockListStatus.loading));

    _currentStatusName = null;
    _currentSearch = '';
    _currentBrandName = event.brandName;
    if (event.sortBy != null) {
      _currentSortBy = event.sortBy!;
    }

    try {
      final response = await _repository.getStocks(
        stockStatus: _currentStatusName ?? '',
        search: _currentSearch,
        brandName: _currentBrandName ?? "",
        sortBy: _currentSortBy,
        limit: state.limit,
        page: 1,
      );
      final stocks = response.data ?? [];
      allStocks = stocks;

      emit(
        state.copyWith(
          status: StockListStatus.ready,
          totalStock: allStocks.length,
          totalIn: 122,
          totalOut: 543,
          stocks: stocks,
          page: 1,
          hasReachedMax: stocks.length < state.limit,
          selectedStatusName: null,
          sortBy: _currentSortBy,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: StockListStatus.failure,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onLoadMoreStocks(
    LoadMoreStocks event,
    Emitter<StockState> emit,
  ) async {
    if (state.hasReachedMax ||
        state.isLoadingMore ||
        state.isLoading ||
        state.isFailure) {
      return;
    }

    emit(state.copyWith(status: StockListStatus.loadingMore));
    try {
      final nextPage = state.page + 1;
      final response = await _repository.getStocks(
        stockStatus: _currentStatusName ?? '',
        search: _currentSearch,
        brandName: _currentBrandName ?? "",
        sortBy: _currentSortBy,
        page: nextPage,
        limit: state.limit,
      );
      final newStocks = response.data ?? [];
      allStocks = [...allStocks, ...newStocks];

      emit(
        state.copyWith(
          status: StockListStatus.ready,
          stocks: [...state.stocks, ...newStocks],
          page: nextPage,
          hasReachedMax: newStocks.length < state.limit,
          sortBy: _currentSortBy,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: StockListStatus.ready,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _loadDotStatusRules(
    LoadDotStatusRules event,
    Emitter<StockState> emit,
  ) async {
    emit(
      state.copyWith(
        dotStatusRulesLoading: true,
        errorMessage: null,
      ),
    );
    try {
      final response = await _repository.getDotStatusRules();
      emit(
        state.copyWith(
          dotStatusRulesLoading: false,
          dotStatusRules: response.data ?? [],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          dotStatusRulesLoading: false,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _updateDotStatusRule(
    UpdateDotStatusRule event,
    Emitter<StockState> emit,
  ) async {
    try {
      await _repository.updateDotStatusRule(
        id: event.id,
        minMonth: event.minMonth,
        maxMonth: event.maxMonth,
      );
      add(LoadDotStatusRules());
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _loadStockStatusRules(
    LoadStockStatusRules event,
    Emitter<StockState> emit,
  ) async {
    emit(
      state.copyWith(
        stockStatusRulesLoading: true,
        errorMessage: null,
      ),
    );
    try {
      final response = await _repository.getStockStatusRules();
      emit(
        state.copyWith(
          stockStatusRulesLoading: false,
          stockStatusRules: response.data ?? [],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          stockStatusRulesLoading: false,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _updateStockStatusRule(
    UpdateStockStatusRule event,
    Emitter<StockState> emit,
  ) async {
    try {
      await _repository.updateStockStatusRule(
        id: event.id,
        minQty: event.minQty,
        maxQty: event.maxQty,
      );
      add(LoadStockStatusRules());
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _createStock(CreateStock event, Emitter<StockState> emit) async {
    try {
      await _repository.addStock(
        productId: event.productId,
        note: event.note,
        stockBatches: event.stockBatches,
      );
      add(LoadStock(brandName: _currentBrandName));
    } catch (e) {
      emit(
        state.copyWith(
          status: StockListStatus.failure,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  void _filterStocks(StockEvent event, Emitter<StockState> emit) {
    if (!state.isReady && !state.isLoadingMore) return;

    String? statusName = _currentStatusName;
    String? brandName = _currentBrandName;
    String keyword = _currentSearch;

    switch (event) {
      case FilterStock e:
        statusName = e.statusName;
        brandName = e.brandName;
        if (e.keyword.isNotEmpty) keyword = e.keyword;
        break;
      case SearchStock e:
        keyword = e.keyword;
        break;
      default:
        break;
    }

    _currentStatusName = statusName;
    _currentBrandName = brandName;
    _currentSearch = keyword;

    final filtered = _filterStocksUseCase.execute(
      allStocks: allStocks,
      brandName: brandName,
      statusName: statusName,
      keyword: keyword,
      sortBy: _currentSortBy,
    );

    emit(
      state.copyWith(
        status: StockListStatus.ready,
        stocks: filtered,
        selectedStatusName: statusName,
        sortBy: _currentSortBy,
      ),
    );
  }

  Future<void> _changeSortBy(ChangeSortBy event, Emitter<StockState> emit) async {
    _currentSortBy = event.sortBy;
    
    emit(state.copyWith(status: StockListStatus.loading));
    try {
      final response = await _repository.getStocks(
        stockStatus: _currentStatusName ?? '',
        search: _currentSearch,
        brandName: _currentBrandName ?? "",
        sortBy: _currentSortBy,
        limit: state.limit,
        page: 1,
      );
      final stocks = response.data ?? [];
      allStocks = stocks;

      emit(
        state.copyWith(
          status: StockListStatus.ready,
          totalStock: allStocks.length,
          totalIn: 122,
          totalOut: 543,
          stocks: stocks,
          page: 1,
          hasReachedMax: stocks.length < state.limit,
          sortBy: _currentSortBy,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: StockListStatus.failure,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }
}
