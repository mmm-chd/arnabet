import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arena/repositories/cart/cart_repository.dart';
import 'package:arena/usecases/cart/build_order_items_use_case.dart';
import 'package:arena/models/cart/cart_list_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _repository;
  final BuildOrderItemsUseCase _buildOrderItemsUseCase;
  final Duration debounceDuration;
  final Map<String, Timer> _debounceTimers = {};

  CartBloc({
    required CartRepository repository,
    BuildOrderItemsUseCase? buildOrderItemsUseCase,
    this.debounceDuration = const Duration(milliseconds: 700),
  }) : _repository = repository,
       _buildOrderItemsUseCase =
           buildOrderItemsUseCase ?? BuildOrderItemsUseCase(),
       super(CartState()) {
    on<LoadCart>(_onLoadCart);
    on<ChangeQuantity>(_onChangeQuantity);
    on<SyncQuantity>(_onSyncQuantity);
    on<AddToCart>(_onAddToCart);
    on<AddServiceToCart>(_onAddServiceToCart);
    on<ApplyDiscount>(_onApplyDiscount);
    on<DeleteCartItem>(_onDeleteCartItem);
    on<ClearCart>(_onClearCart);
    on<Checkout>(_onCheckout);
    on<PrepareCheckout>(_onPrepareCheckout);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(
      state.copyWith(
        status: CartListStatus.loading,
        checkoutStatus: CheckoutStatus.idle,
      ),
    );
    try {
      final response = await _repository.getCart();
      emit(
        state.copyWith(
          status: CartListStatus.ready,
          cartListData: response.data!,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          message: e.toString().replaceAll("Exception: ", ""),
          status: CartListStatus.failure,
        ),
      );
    }
  }

  void _onChangeQuantity(ChangeQuantity event, Emitter<CartState> emit) {
    final cart = state.cartListData;
    if (cart == null) return;

    final items = cart.items ?? [];
    final index = items.indexWhere((e) => e.id == event.itemId);
    if (index == -1) return;

    final quantity = event.quantity < 1 ? 1 : event.quantity;
    final currentItem = items[index];
    final unitPrice = currentItem.unitPrice ?? 0;
    final updatedItem = currentItem.copyWith(
      quantity: quantity,
      subtotal: unitPrice * quantity,
    );

    final updatedItems = List<Item>.from(items);
    updatedItems[index] = updatedItem;
    final updatedSubtotal = updatedItems.fold<int>(
      0,
      (sum, e) => sum + (e.subtotal ?? 0),
    );

    emit(
      state.copyWith(
        status: CartListStatus.ready,
        cartListData: cart.copyWith(
          items: updatedItems,
          subtotal: updatedSubtotal,
          total: _clampTotal(updatedSubtotal, cart.discount ?? 0),
        ),
        syncingItemIds: {...state.syncingItemIds, event.itemId},
      ),
    );

    _debounceTimers[event.itemId]?.cancel();
    _debounceTimers[event.itemId] = Timer(debounceDuration, () {
      add(SyncQuantity(itemId: event.itemId, quantity: quantity));
    });
  }

  Future<void> _onSyncQuantity(
    SyncQuantity event,
    Emitter<CartState> emit,
  ) async {
    _debounceTimers.remove(event.itemId);
    try {
      await _repository.updateCartItem(
        itemId: event.itemId,
        quantity: event.quantity,
      );
      final cart = await _repository.getCart();
      final syncing = {...state.syncingItemIds}..remove(event.itemId);
      emit(
        state.copyWith(
          status: CartListStatus.ready,
          cartListData: cart.data!,
          syncingItemIds: syncing,
        ),
      );
    } catch (e) {
      final syncing = {...state.syncingItemIds}..remove(event.itemId);
      final message = e.toString().replaceAll("Exception: ", "");
      try {
        final cart = await _repository.getCart();
        emit(
          state.copyWith(
            status: CartListStatus.ready,
            cartListData: cart.data!,
            syncingItemIds: syncing,
            message: message,
          ),
        );
      } catch (_) {
        emit(
          state.copyWith(
            status: CartListStatus.ready,
            syncingItemIds: syncing,
            message: message,
          ),
        );
      }
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartListStatus.loading));
    try {
      final response = await _repository.addToCart(
        stockId: event.stockId,
        quantity: event.quantity,
      );
      final message =
          response.message ?? "Berhasil menambahkan barang ke keranjang";
      emit(state.copyWith(message: message, status: CartListStatus.success));

      final cart = await _repository.getCart();
      emit(
        state.copyWith(cartListData: cart.data!, status: CartListStatus.ready),
      );
    } catch (e) {
      emit(
        state.copyWith(
          message: e.toString().replaceAll("Exception: ", ""),
          status: CartListStatus.failure,
        ),
      );
    }
  }

  Future<void> _onApplyDiscount(
    ApplyDiscount event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartListStatus.loading));
    try {
      final response = await _repository.applyDiscount(
        discountAmount: event.discountAmount,
      );
      final message = response.message ?? "Diskon berhasil diterapkan";
      final cart = await _repository.getCart();
      emit(
        state.copyWith(
          status: CartListStatus.ready,
          cartListData: cart.data!,
          message: message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CartListStatus.ready,
          message: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onDeleteCartItem(
    DeleteCartItem event,
    Emitter<CartState> emit,
  ) async {
    _debounceTimers[event.itemId]?.cancel();
    _debounceTimers.remove(event.itemId);
    emit(
      state.copyWith(
        syncingItemIds: {...state.syncingItemIds, event.itemId},
      ),
    );
    try {
      final response = await _repository.deleteCartItem(itemId: event.itemId);
      final message = response.message ?? "Barang berhasil dihapus";
      final cart = await _repository.getCart();
      final syncing = {...state.syncingItemIds}..remove(event.itemId);
      emit(
        state.copyWith(
          status: CartListStatus.ready,
          cartListData: cart.data!,
          syncingItemIds: syncing,
          message: message,
        ),
      );
    } catch (e) {
      // Pertahankan tampilan cart, cukup tampilkan pesan error via snackbar.
      final syncing = {...state.syncingItemIds}..remove(event.itemId);
      emit(
        state.copyWith(
          status: CartListStatus.ready,
          syncingItemIds: syncing,
          message: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartListStatus.loading));
    try {
      final response = await _repository.clearCart();
      final message = response.message ?? "Keranjang berhasil dikosongkan";
      final cart = await _repository.getCart();
      emit(
        state.copyWith(
          status: CartListStatus.ready,
          cartListData: cart.data!,
          message: message,
        ),
      );
    } catch (e) {
      // Pertahankan tampilan cart, cukup tampilkan pesan error via snackbar.
      emit(
        state.copyWith(
          status: CartListStatus.ready,
          message: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onAddServiceToCart(
    AddServiceToCart event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartListStatus.loading));
    try {
      final response = await _repository.addServiceToCart(
        serviceId: event.serviceId,
        quantity: event.quantity,
      );
      final message =
          response.message ?? "Berhasil menambahkan layanan ke keranjang";
      emit(state.copyWith(message: message, status: CartListStatus.success));

      final cart = await _repository.getCart();
      emit(
        state.copyWith(cartListData: cart.data!, status: CartListStatus.ready),
      );
    } catch (e) {
      emit(
        state.copyWith(
          message: e.toString().replaceAll("Exception: ", ""),
          status: CartListStatus.failure,
        ),
      );
    }
  }

  int _clampTotal(int subtotal, int discount) {
    final total = subtotal - discount;
    return total > 0 ? total : 0;
  }

  Future<void> _onCheckout(Checkout event, Emitter<CartState> emit) async {
    emit(state.copyWith(checkoutStatus: CheckoutStatus.submitting));
    try {
      final response = await _repository.checkoutCart(
        customerName: event.customerName,
        phone: event.phone,
        vehicle: event.vehicle,
        plate: event.plate,
      );
      final message = response.message ?? "Order berhasil dibuat";
      emit(
        state.copyWith(
          checkoutStatus: CheckoutStatus.success,
          checkoutMessage: message,
        ),
      );
      add(LoadCart());
    } catch (e) {
      emit(
        state.copyWith(
          checkoutStatus: CheckoutStatus.failure,
          checkoutMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  void _onPrepareCheckout(PrepareCheckout event, Emitter<CartState> emit) {
    final cart = state.cartListData;
    if (cart == null || cart.items == null || cart.items!.isEmpty) return;

    final orderItems = _buildOrderItemsUseCase.execute(cart);
    emit(
      state.copyWith(orderItems: orderItems, status: CartListStatus.success),
    );
  }

  @override
  Future<void> close() {
    for (final timer in _debounceTimers.values) {
      timer.cancel();
    }
    return super.close();
  }
}
