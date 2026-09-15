import 'package:arena/pages/stock_detail/bloc/stock_detail_event.dart';
import 'package:arena/pages/stock_detail/bloc/stock_detail_state.dart';
import 'package:arena/repositories/stock/stock_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StockDetailBloc extends Bloc<StockDetailEvent, StockDetailState> {
  final StockRepository _stockRepository;

  StockDetailBloc({StockRepository? stockRepository})
      : _stockRepository = stockRepository ?? StockRepository(),
        super(const StockDetailState()) {
    on<StockDetailFetched>(_onFetched);
    on<AdjustStockSubmitted>(_onAdjustStock);
    on<UpdateStockSubmitted>(_onUpdateStock);
  }

  Future<void> _onFetched(
    StockDetailFetched event,
    Emitter<StockDetailState> emit,
  ) async {
    emit(state.copyWith(status: StockDetailStatus.loading, errorMessage: null));

    try {
      final detailResult =
          await _stockRepository.getStockDetail(event.productId);

      emit(
        state.copyWith(
          status: StockDetailStatus.ready,
          stock: detailResult.data,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: StockDetailStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onAdjustStock(
    AdjustStockSubmitted event,
    Emitter<StockDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        isAdjusting: true,
        errorMessage: null,
        adjustSuccessMessage: null,
      ),
    );

    try {
      final result = await _stockRepository.adjustStock(
        stockId: event.stockId,
        newQuantity: event.newQuantity,
        reason: event.reason,
      );

      final detailResult =
          await _stockRepository.getStockDetail(event.productId);

      emit(
        state.copyWith(
          status: StockDetailStatus.ready,
          stock: detailResult.data,
          isAdjusting: false,
          adjustSuccessMessage: result.message ?? "Stock berhasil disesuaikan",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isAdjusting: false,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onUpdateStock(
    UpdateStockSubmitted event,
    Emitter<StockDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        isUpdating: true,
        errorMessage: null,
        updateSuccessMessage: null,
      ),
    );

    try {
      final result = await _stockRepository.updateStock(
        event.stockId,
        event.request,
      );

      final detailResult =
          await _stockRepository.getStockDetail(event.productId);

      emit(
        state.copyWith(
          status: StockDetailStatus.ready,
          stock: detailResult.data,
          isUpdating: false,
          updateSuccessMessage: result.message ?? "Batch berhasil diperbarui",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isUpdating: false,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }
}