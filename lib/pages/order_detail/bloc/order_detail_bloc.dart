import 'package:arena/pages/order_detail/bloc/order_detail_event.dart';
import 'package:arena/pages/order_detail/bloc/order_detail_state.dart';
import 'package:arena/repositories/payment/payment_repository.dart';
import 'package:arena/services/order/order_detail_service.dart';
import 'package:arena/services/order/update_order_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailBloc extends Bloc<OrderDetailEvent, OrderDetailState> {
  final OrderDetailService _orderDetailService;
  final UpdateOrderService _updateOrderService;
  final PaymentRepository _paymentRepository;

  OrderDetailBloc({
    OrderDetailService? orderDetailService,
    UpdateOrderService? updateOrderService,
    PaymentRepository? paymentRepository,
  }) : _orderDetailService = orderDetailService ?? OrderDetailService(),
       _updateOrderService = updateOrderService ?? UpdateOrderService(),
       _paymentRepository = paymentRepository ?? PaymentRepository(),
       super(const OrderDetailState()) {
    on<OrderDetailFetched>(_onFetched);
    on<OrderDetailRefreshRequested>(_onRefreshRequested);
    on<OrderDetailMarkedAsPickedUp>(_onMarkedAsPickedUp);
    on<OrderDetailStatusUpdated>(_onStatusUpdated);
    on<OrderDetailCancelled>(_onCancelled);
    on<OrderDetailPaymentConfirmed>(_onPaymentConfirmed);
  }

  Future<void> _onFetched(
    OrderDetailFetched event,
    Emitter<OrderDetailState> emit,
  ) async {
    emit(state.copyWith(status: OrderDetailStatus.loading, errorMessage: null));

    try {
      final result = await _orderDetailService.getOrderDetail(
        orderId: event.orderId,
      );

      emit(state.copyWith(status: OrderDetailStatus.ready, order: result.data));
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderDetailStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onRefreshRequested(
    OrderDetailRefreshRequested event,
    Emitter<OrderDetailState> emit,
  ) async {
    try {
      final result = await _orderDetailService.getOrderDetail(
        orderId: event.orderId,
      );

      emit(state.copyWith(status: OrderDetailStatus.ready, order: result.data));
    } catch (_) {
      // Silent refresh: biarkan data lama, tanpa notify error.
    }
  }

  Future<void> _onMarkedAsPickedUp(
    OrderDetailMarkedAsPickedUp event,
    Emitter<OrderDetailState> emit,
  ) async {
    emit(
      state.copyWith(status: OrderDetailStatus.submitting, errorMessage: null),
    );

    try {
      await _updateOrderService.markAsPickedUp(orderId: event.orderId);

      emit(state.copyWith(status: OrderDetailStatus.success));

      add(OrderDetailFetched(orderId: event.orderId));
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderDetailStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onStatusUpdated(
    OrderDetailStatusUpdated event,
    Emitter<OrderDetailState> emit,
  ) async {
    emit(
      state.copyWith(status: OrderDetailStatus.submitting, errorMessage: null),
    );

    try {
      await _updateOrderService.updateOrderStatus(
        orderId: event.orderId,
        status: event.status,
      );

      emit(state.copyWith(status: OrderDetailStatus.success));

      add(OrderDetailFetched(orderId: event.orderId));
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderDetailStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onCancelled(
    OrderDetailCancelled event,
    Emitter<OrderDetailState> emit,
  ) async {
    emit(
      state.copyWith(status: OrderDetailStatus.submitting, errorMessage: null),
    );

    try {
      await _updateOrderService.cancelOrder(orderId: event.orderId);

      emit(state.copyWith(status: OrderDetailStatus.cancelSuccess));
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderDetailStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onPaymentConfirmed(
    OrderDetailPaymentConfirmed event,
    Emitter<OrderDetailState> emit,
  ) async {
    emit(
      state.copyWith(status: OrderDetailStatus.submitting, errorMessage: null),
    );

    try {
      await _paymentRepository.confirmPayment(
        orderId: event.orderId,
        notes: event.notes,
      );

      emit(state.copyWith(status: OrderDetailStatus.success));

      add(OrderDetailFetched(orderId: event.orderId));
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderDetailStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }
}
