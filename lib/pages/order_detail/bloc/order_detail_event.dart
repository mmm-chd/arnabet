import 'package:arena/models/enums/enums.dart';
import 'package:equatable/equatable.dart';

sealed class OrderDetailEvent extends Equatable {
  const OrderDetailEvent();

  @override
  List<Object?> get props => [];
}

class OrderDetailFetched extends OrderDetailEvent {
  final String orderId;

  const OrderDetailFetched({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class OrderDetailRefreshRequested extends OrderDetailEvent {
  final String orderId;

  const OrderDetailRefreshRequested({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class OrderDetailMarkedAsPickedUp extends OrderDetailEvent {
  final String orderId;

  const OrderDetailMarkedAsPickedUp({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class OrderDetailStatusUpdated extends OrderDetailEvent {
  final String orderId;
  final OrderStatus status;

  const OrderDetailStatusUpdated({required this.orderId, required this.status});

  @override
  List<Object?> get props => [orderId, status];
}

class OrderDetailCancelled extends OrderDetailEvent {
  final String orderId;

  const OrderDetailCancelled({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class OrderDetailPaymentConfirmed extends OrderDetailEvent {
  final String orderId;
  final String? notes;

  const OrderDetailPaymentConfirmed({required this.orderId, this.notes});

  @override
  List<Object?> get props => [orderId, notes];
}
