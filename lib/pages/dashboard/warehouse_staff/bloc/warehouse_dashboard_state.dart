import 'package:arena/models/dashboard/warehouse_dashboard_model.dart';
import 'package:equatable/equatable.dart';

enum WarehouseDashboardStatus { initial, loading, ready, failure }

class WarehouseDashboardState extends Equatable {
  final WarehouseDashboardStatus status;
  final WarehouseDashboardData? data;
  final String? errorMessage;

  const WarehouseDashboardState({
    this.status = WarehouseDashboardStatus.initial,
    this.data,
    this.errorMessage,
  });

  WarehouseDashboardState copyWith({
    WarehouseDashboardStatus? status,
    WarehouseDashboardData? data,
    Object? errorMessage = _sentinel,
  }) {
    return WarehouseDashboardState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  bool get isInitial => status == WarehouseDashboardStatus.initial;
  bool get isLoading => status == WarehouseDashboardStatus.loading;
  bool get isReady => status == WarehouseDashboardStatus.ready;
  bool get isFailure => status == WarehouseDashboardStatus.failure;

  @override
  List<Object?> get props => [status, data, errorMessage];
}

const _sentinel = Object();
