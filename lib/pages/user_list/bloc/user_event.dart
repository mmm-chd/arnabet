import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserList extends UserEvent {
  final String? roleId;

  const LoadUserList({this.roleId});

  @override
  List<Object?> get props => [roleId];
}

class LoadMoreUsers extends UserEvent {
  const LoadMoreUsers();
}

class FilterUser extends UserEvent {
  final String keyword;

  const FilterUser(this.keyword);

  @override
  List<Object?> get props => [keyword];
}

class SearchUser extends UserEvent {
  final String keyword;

  const SearchUser(this.keyword);

  @override
  List<Object?> get props => [keyword];
}
