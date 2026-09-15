import 'package:equatable/equatable.dart';

abstract class InboxEvent extends Equatable {
  const InboxEvent();

  @override
  List<Object> get props => [];
}

class LoadInbox extends InboxEvent {}

class SearchInbox extends InboxEvent {
  final String query;

  const SearchInbox(this.query);

  @override
  List<Object> get props => [query];
}

class MarkAsRead extends InboxEvent {
  final int id;

  const MarkAsRead(this.id);

  @override
  List<Object> get props => [id];
}

class DeleteInbox extends InboxEvent {
  final int id;
  const DeleteInbox(this.id);
  @override
  List<Object> get props => [id];
}

class FilterInbox extends InboxEvent {
  final String type;

  const FilterInbox(this.type);

  @override
  List<Object> get props => [type];
}
