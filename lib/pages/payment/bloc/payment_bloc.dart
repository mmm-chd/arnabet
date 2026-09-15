import 'package:arena/models/enums/enums.dart';
import 'package:arena/pages/payment/bloc/payment_event.dart';
import 'package:arena/pages/payment/bloc/payment_state.dart';
import 'package:arena/repositories/payment/payment_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _repository;

  PaymentBloc({PaymentRepository? repository})
    : _repository = repository ?? PaymentRepository(),
      super(const PaymentState()) {
    on<PaymentSubmitted>(_onSubmitted);
    on<PaymentStatusCheckRequested>(_onStatusCheckRequested);
  }

  Future<void> _onSubmitted(
    PaymentSubmitted event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(status: PaymentStatusUi.submitting, errorMessage: null));
    try {
      final result = await _repository.payOrder(
        orderId: event.orderId,
        method: event.method,
        amount: event.amount,
        notes: event.notes,
        bankCode: event.bankCode,
      );

      final payment = result.data!;

      if (event.method.isOnlinePayment) {
        emit(
          state.copyWith(
            status: payment.isPaid
                ? PaymentStatusUi.paid
                : PaymentStatusUi.awaitingOnlinePayment,
            payment: payment,
          ),
        );
      } else {
        emit(state.copyWith(status: PaymentStatusUi.paid, payment: payment));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: PaymentStatusUi.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onStatusCheckRequested(
    PaymentStatusCheckRequested event,
    Emitter<PaymentState> emit,
  ) async {
    if (!event.silent) {
      emit(state.copyWith(status: PaymentStatusUi.checkingStatus));
    }
    try {
      final result = await _repository.getStatus(
        orderId: event.orderId,
        method: event.method,
      );
      final payment = result.data!;

      if (payment.isPaid) {
        emit(state.copyWith(status: PaymentStatusUi.paid, payment: payment));
      } else if (payment.isFailedOrExpired) {
        emit(
          state.copyWith(
            status: PaymentStatusUi.failure,
            payment: payment,
            errorMessage: payment.status?.name == 'EXPIRED'
                ? 'Pembayaran telah kedaluwarsa'
                : 'Pembayaran gagal',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: PaymentStatusUi.awaitingOnlinePayment,
            payment: payment,
          ),
        );
      }
    } catch (e) {
      if (!event.silent) {
        emit(
          state.copyWith(
            status: PaymentStatusUi.failure,
            errorMessage: e.toString().replaceAll("Exception: ", ""),
          ),
        );
      }
    }
  }
}