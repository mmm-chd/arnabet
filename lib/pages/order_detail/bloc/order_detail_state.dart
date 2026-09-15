import 'package:arena/models/order/order_detail_model.dart';
import 'package:equatable/equatable.dart';

enum OrderDetailStatus {
  initial,
  loading,
  ready,
  submitting,
  success,
  cancelSuccess,
  failure,
}

class OrderDetailState extends Equatable {
  final OrderDetailStatus status;
  final OrderDetailData? order;
  final String? errorMessage;

  const OrderDetailState({
    this.status = OrderDetailStatus.initial,
    this.order,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, order, errorMessage];

  OrderDetailState copyWith({
    OrderDetailStatus? status,
    OrderDetailData? order,
    Object? errorMessage = _sentinel,
  }) {
    return OrderDetailState(
      status: status ?? this.status,
      order: order ?? this.order,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  bool get isInitial => status == OrderDetailStatus.initial;
  bool get isLoading => status == OrderDetailStatus.loading;
  bool get isReady => status == OrderDetailStatus.ready;
  bool get isSubmitting => status == OrderDetailStatus.submitting;
  bool get isFailure => status == OrderDetailStatus.failure;
  bool get isSuccess => status == OrderDetailStatus.success;
  bool get isCancelSuccess => status == OrderDetailStatus.cancelSuccess;

  List<OrderDetailItem> get orders => order?.items ?? const [];

  bool get hasOrders => orders.isNotEmpty;
}

const _sentinel = Object();
