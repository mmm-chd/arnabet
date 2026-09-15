import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboard extends DashboardEvent {
  final String period;

  const LoadDashboard({this.period = "1M"});

  @override
  List<Object?> get props => [period];
}

class RefreshDashboard extends DashboardEvent {
  final String period;

  const RefreshDashboard({this.period = "1M"});

  @override
  List<Object?> get props => [period];
}
