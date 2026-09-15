import 'package:arena/models/customer/customer_list_model.dart';
import 'package:equatable/equatable.dart';

enum CustomerStatus { initial, loading, loadingMore, ready, failure }

class CustomerState extends Equatable {
  final CustomerStatus status;

  final List<CustomerListDatum> customers;

  final String searchQuery;

  final int page;
  final int limit;
  final int totalCustomer;
  final bool hasReachedMax;

  final String? errorMessage;

  const CustomerState({
    this.status = CustomerStatus.initial,
    this.customers = const [],
    this.searchQuery = "",
    this.page = 1,
    this.limit = 10,
    this.totalCustomer = 0,
    this.hasReachedMax = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    status,
    customers,
    searchQuery,
    page,
    limit,
    totalCustomer,
    hasReachedMax,
    errorMessage,
  ];

  CustomerState copyWith({
    CustomerStatus? status,
    List<CustomerListDatum>? customers,
    String? searchQuery,
    int? page,
    int? limit,
    int? totalCustomer,
    bool? hasReachedMax,
    Object? errorMessage = _sentinel,
  }) {
    return CustomerState(
      status: status ?? this.status,
      customers: customers ?? this.customers,
      searchQuery: searchQuery ?? this.searchQuery,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      totalCustomer: totalCustomer ?? this.totalCustomer,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  bool get isLoading => status == CustomerStatus.loading;
  bool get isLoadingMore => status == CustomerStatus.loadingMore;
  bool get isReady =>
      status == CustomerStatus.ready || status == CustomerStatus.loadingMore;
  bool get isFailure => status == CustomerStatus.failure && customers.isEmpty;
  bool get isEmpty => isReady && customers.isEmpty;
}

const _sentinel = Object();
