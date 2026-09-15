import 'package:arena/repositories/dashboard/dashboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'warehouse_dashboard_event.dart';
import 'warehouse_dashboard_state.dart';

class WarehouseDashboardBloc
    extends Bloc<WarehouseDashboardEvent, WarehouseDashboardState> {
  final DashboardRepository _repository;

  WarehouseDashboardBloc({required DashboardRepository repository})
    : _repository = repository,
      super(const WarehouseDashboardState()) {
    on<LoadWarehouseDashboard>(_onLoad);
  }

  Future<void> _onLoad(
    LoadWarehouseDashboard event,
    Emitter<WarehouseDashboardState> emit,
  ) async {
    emit(
      state.copyWith(
        status: WarehouseDashboardStatus.loading,
        errorMessage: null,
      ),
    );

    try {
      final response = await _repository.getWarehouseDashboard(
        period: event.period,
      );
      emit(
        state.copyWith(
          status: WarehouseDashboardStatus.ready,
          data: response.data,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: WarehouseDashboardStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }
}
