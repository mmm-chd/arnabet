import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadHistory extends HistoryEvent {
  final String? userId;
  final String? startDate;
  final String? endDate;

  const LoadHistory({this.userId, this.startDate, this.endDate});

  @override
  List<Object?> get props => [userId, startDate, endDate];
}

class LoadMoreHistory extends HistoryEvent {
  const LoadMoreHistory();
}

class ToggleExpand extends HistoryEvent {
  final int index;

  const ToggleExpand(this.index);

  @override
  List<Object?> get props => [index];
}

class FilterHistory extends HistoryEvent {
  final String filter;

  const FilterHistory(this.filter);

  @override
  List<Object?> get props => [filter];
}

class SearchHistory extends HistoryEvent {
  final String query;

  const SearchHistory(this.query);

  @override
  List<Object?> get props => [query];
}