import 'package:arena/repositories/order/order_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arena/models/enums/enums.dart';
import 'package:arena/pages/order_list/bloc/order_event.dart';
import 'package:arena/pages/order_list/bloc/order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _repository;
  static const _limit = 20;

  OrderStatus? _currentOrderStatus;
  PaymentStatus? _currentPaymentStatus;
  String? _currentSearch;

  OrderBloc({OrderRepository? repository})
    : _repository = repository ?? OrderRepository(),
      super(const OrderState()) {
    on<LoadOrders>(_onLoadOrders);
    on<LoadMoreOrders>(_onLoadMoreOrders);
    on<MarkOrderAsPickedUp>(_onMarkOrderAsPickedUp);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<CancelOrder>(_onCancelOrder);
    on<ConfirmPayment>(_onConfirmPayment);
  }

  Future<void> _onLoadOrders(LoadOrders event, Emitter<OrderState> emit) async {
    _currentOrderStatus = event.orderStatus;
    _currentPaymentStatus = event.paymentStatus;
    _currentSearch = event.search;

    emit(state.copyWith(status: OrderListStatus.loading));
    try {
      final result = await _repository.getOrders(
        orderStatus: _currentOrderStatus,
        paymentStatus: _currentPaymentStatus,
        search: _currentSearch,
        page: 1,
        limit: _limit,
      );
      final orders = result.data ?? [];
      emit(
        state.copyWith(
          status: OrderListStatus.ready,
          orders: orders,
          page: 1,
          hasReachedMax: orders.length < _limit,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderListStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onLoadMoreOrders(
    LoadMoreOrders event,
    Emitter<OrderState> emit,
  ) async {
    if (state.hasReachedMax ||
        state.isLoadingMore ||
        state.isLoading ||
        state.isFailure) {
      return;
    }

    emit(state.copyWith(status: OrderListStatus.loadingMore));
    try {
      final nextPage = state.page + 1;
      final result = await _repository.getOrders(
        orderStatus: _currentOrderStatus,
        paymentStatus: _currentPaymentStatus,
        search: _currentSearch,
        page: nextPage,
        limit: _limit,
      );
      final newOrders = result.data ?? [];
      emit(
        state.copyWith(
          status: OrderListStatus.ready,
          orders: [...state.orders, ...newOrders],
          page: nextPage,
          hasReachedMax: newOrders.length < _limit,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderListStatus.ready,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onMarkOrderAsPickedUp(
    MarkOrderAsPickedUp event,
    Emitter<OrderState> emit,
  ) async {
    emit(
      state.copyWith(
        processingOrderIds: {...state.processingOrderIds, event.orderId},
      ),
    );
    try {
      await _repository.markAsPickedUp(orderId: event.orderId);
      final updated = state.orders.map((o) {
        if (o.id == event.orderId) {
          return o.copyWith(orderStatus: OrderStatus.PROCESSING);
        }
        return o;
      }).toList();
      emit(
        state.copyWith(
          orders: updated,
          processingOrderIds: {...state.processingOrderIds}
            ..remove(event.orderId),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString().replaceAll("Exception: ", ""),
          processingOrderIds: {...state.processingOrderIds}
            ..remove(event.orderId),
        ),
      );
    }
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatus event,
    Emitter<OrderState> emit,
  ) async {
    try {
      await _repository.updateOrderStatus(
        orderId: event.orderId,
        status: event.orderStatus,
      );
      add(
        LoadOrders(
          orderStatus: _currentOrderStatus,
          paymentStatus: _currentPaymentStatus,
          search: _currentSearch,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onCancelOrder(
    CancelOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(
      state.copyWith(
        processingOrderIds: {...state.processingOrderIds, event.orderId},
      ),
    );
    try {
      await _repository.cancelOrder(orderId: event.orderId);
      emit(state.copyWith(processingOrderIds: {...state.processingOrderIds}));
      add(
        LoadOrders(
          orderStatus: _currentOrderStatus,
          paymentStatus: _currentPaymentStatus,
          search: _currentSearch,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString().replaceAll("Exception: ", ""),
          processingOrderIds: {...state.processingOrderIds},
        ),
      );
    }
  }

  Future<void> _onConfirmPayment(
    ConfirmPayment event,
    Emitter<OrderState> emit,
  ) async {
    emit(
      state.copyWith(
        processingOrderIds: {...state.processingOrderIds, event.orderId},
      ),
    );
    try {
      await _repository.confirmPayment(
        orderId: event.orderId,
        notes: event.notes,
      );
      emit(state.copyWith(processingOrderIds: {...state.processingOrderIds}));
      add(
        LoadOrders(
          orderStatus: _currentOrderStatus,
          paymentStatus: _currentPaymentStatus,
          search: _currentSearch,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString().replaceAll("Exception: ", ""),
          processingOrderIds: {...state.processingOrderIds},
        ),
      );
    }
  }
}
