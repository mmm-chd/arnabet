import 'package:arena/models/dashboard/dashboard_model.dart';
import 'package:equatable/equatable.dart';

enum DashboardStatus { initial, loading, ready, failure }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final DashboardData? dashboard;
  final String? errorMessage;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.dashboard,
    this.errorMessage,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardData? dashboard,
    Object? errorMessage = _sentinel,
  }) {
    return DashboardState(
      status: status ?? this.status,
      dashboard: dashboard ?? this.dashboard,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  bool get isInitial => status == DashboardStatus.initial;
  bool get isLoading => status == DashboardStatus.loading;
  bool get isReady => status == DashboardStatus.ready;
  bool get isFailure => status == DashboardStatus.failure;

  @override
  List<Object?> get props => [status, dashboard, errorMessage];
}

const _sentinel = Object();
