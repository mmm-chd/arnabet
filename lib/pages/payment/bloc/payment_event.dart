import 'package:arena/models/enums/enums.dart';
import 'package:equatable/equatable.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class PaymentSubmitted extends PaymentEvent {
  final String orderId;
  final PaymentMethod method;
  final int? amount;
  final String? notes;
  final String? bankCode;

  const PaymentSubmitted({
    required this.orderId,
    required this.method,
    this.amount,
    this.notes,
    this.bankCode,
  });

  @override
  List<Object?> get props => [orderId, method, amount, notes, bankCode];
}

class PaymentStatusCheckRequested extends PaymentEvent {
  final String orderId;
  final PaymentMethod method;
  final bool silent;

  const PaymentStatusCheckRequested({
    required this.orderId,
    required this.method,
    this.silent = false,
  });

  @override
  List<Object?> get props => [orderId, method, silent];
}