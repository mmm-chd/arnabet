import 'package:arena/models/order/order_list_model.dart';
import 'package:equatable/equatable.dart';

enum OrderListStatus {
  initial,
  loading,
  loadingMore,
  ready,
  submitting,
  success,
  failure,
}

class OrderState extends Equatable {
  final OrderListStatus status;
  final List<OrderListDatum> orders;
  final String? errorMessage;
  final int page;
  final bool hasReachedMax;
  final Set<String> processingOrderIds;

  const OrderState({
    this.status = OrderListStatus.initial,
    this.orders = const [],
    this.errorMessage,
    this.page = 1,
    this.hasReachedMax = false,
    this.processingOrderIds = const {},
  });

  @override
  List<Object?> get props => [
    status,
    orders,
    errorMessage,
    page,
    hasReachedMax,
    processingOrderIds,
  ];

  OrderState copyWith({
    OrderListStatus? status,
    List<OrderListDatum>? orders,
    Object? errorMessage = _sentinel,
    int? page,
    bool? hasReachedMax,
    Set<String>? processingOrderIds,
  }) {
    return OrderState(
      status: status ?? this.status,
      orders: List.unmodifiable(orders ?? this.orders),
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      processingOrderIds: processingOrderIds ?? this.processingOrderIds,
    );
  }

  bool get isInitial => status == OrderListStatus.initial;
  bool get isLoading => status == OrderListStatus.loading;
  bool get isLoadingMore => status == OrderListStatus.loadingMore;
  bool get isReady => status == OrderListStatus.ready;
  bool get isSubmitting => status == OrderListStatus.submitting;
  bool get isFailure => status == OrderListStatus.failure;
  bool get isSuccess => status == OrderListStatus.success;

  bool get hasOrders => orders.isNotEmpty;
}

const _sentinel = Object();
