import 'package:arena/repositories/report/report_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository _repository;

  ReportBloc({required ReportRepository repository})
    : _repository = repository,
      super(const ReportState()) {
    on<LoadReportSummary>(_onLoadReportSummary);
    on<LoadTopProducts>(_onLoadTopProducts);
    on<LoadStockHealth>(_onLoadStockHealth);
    on<LoadStockMovement>(_onLoadStockMovement);
    on<ClearInactiveReportData>(_onClearInactiveReportData);
  }

  void _onClearInactiveReportData(
    ClearInactiveReportData event,
    Emitter<ReportState> emit,
  ) {
    emit(
      ReportState(
        status: state.status,
        report: event.activeTab == 0 ? state.report : null,
        topProducts: event.activeTab == 1 ? state.topProducts : null,
        stockHealth: event.activeTab == 2 ? state.stockHealth : null,
        stockMovement: event.activeTab == 3 ? state.stockMovement : null,
        errorMessage: state.errorMessage,
      ),
    );
  }

  Future<void> _onLoadTopProducts(
    LoadTopProducts event,
    Emitter<ReportState> emit,
  ) async {
    if (state.topProducts == null) {
      emit(state.copyWith(status: ReportStatus.loading, errorMessage: null));
    }

    try {
      final response = await _repository.getTopProducts(
        period: event.period,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      emit(
        state.copyWith(
          status: ReportStatus.ready,
          topProducts: response.data,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ReportStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onLoadStockHealth(
    LoadStockHealth event,
    Emitter<ReportState> emit,
  ) async {
    if (state.stockHealth == null) {
      emit(state.copyWith(status: ReportStatus.loading, errorMessage: null));
    }

    try {
      final response = await _repository.getStockHealth(
        period: event.period,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      emit(
        state.copyWith(
          status: ReportStatus.ready,
          stockHealth: response.data,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ReportStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onLoadReportSummary(
    LoadReportSummary event,
    Emitter<ReportState> emit,
  ) async {
    if (state.report == null) {
      emit(state.copyWith(status: ReportStatus.loading, errorMessage: null));
    }

    try {
      final t0 = DateTime.now();
      final response = await _repository.getSummary(
        period: event.period,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      emit(
        state.copyWith(
          status: ReportStatus.ready,
          report: response.data,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ReportStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onLoadStockMovement(
    LoadStockMovement event,
    Emitter<ReportState> emit,
  ) async {
    if (state.stockMovement == null) {
      emit(state.copyWith(status: ReportStatus.loading, errorMessage: null));
    }

    try {
      final response = await _repository.getStockMovement(
        period: event.period,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      emit(
        state.copyWith(
          status: ReportStatus.ready,
          stockMovement: response.data,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ReportStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }
}
