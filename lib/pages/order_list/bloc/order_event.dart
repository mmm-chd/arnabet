import 'package:arena/models/enums/enums.dart';
import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrderEvent {
  final OrderStatus? orderStatus;
  final PaymentStatus? paymentStatus;
  final String? search;

  const LoadOrders({this.orderStatus, this.paymentStatus, this.search});

  @override
  List<Object?> get props => [orderStatus, paymentStatus, search];
}

class LoadMoreOrders extends OrderEvent {
  const LoadMoreOrders();
}

class MarkOrderAsPickedUp extends OrderEvent {
  final String orderId;

  const MarkOrderAsPickedUp({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class UpdateOrderStatus extends OrderEvent {
  final String orderId;
  final OrderStatus orderStatus;

  const UpdateOrderStatus({required this.orderId, required this.orderStatus});

  @override
  List<Object?> get props => [orderId];
}

class CancelOrder extends OrderEvent {
  final String orderId;

  const CancelOrder({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class ConfirmPayment extends OrderEvent {
  final String orderId;
  final String? notes;

  const ConfirmPayment({required this.orderId, this.notes});

  @override
  List<Object?> get props => [orderId, notes];
}
