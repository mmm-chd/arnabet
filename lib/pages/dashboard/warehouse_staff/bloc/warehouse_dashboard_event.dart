import 'package:equatable/equatable.dart';

abstract class WarehouseDashboardEvent extends Equatable {
  const WarehouseDashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadWarehouseDashboard extends WarehouseDashboardEvent {
  final String period;

  const LoadWarehouseDashboard({this.period = "1M"});

  @override
  List<Object?> get props => [period];
}
