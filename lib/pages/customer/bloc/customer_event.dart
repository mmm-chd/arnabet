import 'package:equatable/equatable.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomer extends CustomerEvent {
  const LoadCustomer();
}

class LoadMoreCustomer extends CustomerEvent {
  const LoadMoreCustomer();
}

class SearchCustomer extends CustomerEvent {
  final String keyword;

  const SearchCustomer(this.keyword);

  @override
  List<Object?> get props => [keyword];
}