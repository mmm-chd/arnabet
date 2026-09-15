import 'package:arena/models/payments/pay_order_model.dart';
import 'package:equatable/equatable.dart';

enum PaymentStatusUi {
  initial,
  loading,
  submitting,
  awaitingOnlinePayment,
  checkingStatus,
  paid,
  failure,
}

class PaymentState extends Equatable {
  final PaymentStatusUi status;
  final PayOrderData? payment;
  final String? errorMessage;

  const PaymentState({
    this.status = PaymentStatusUi.initial,
    this.payment,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, payment, errorMessage];

  PaymentState copyWith({
    PaymentStatusUi? status,
    PayOrderData? payment,
    Object? errorMessage = _sentinel,
  }) {
    return PaymentState(
      status: status ?? this.status,
      payment: payment ?? this.payment,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  bool get isSubmitting => status == PaymentStatusUi.submitting;
  bool get isLoading => status == PaymentStatusUi.loading;
  bool get isAwaitingOnlinePayment =>
      status == PaymentStatusUi.awaitingOnlinePayment;
  bool get isCheckingStatus => status == PaymentStatusUi.checkingStatus;
  bool get isPaid => status == PaymentStatusUi.paid;
  bool get isFailure => status == PaymentStatusUi.failure;
}

const _sentinel = Object();