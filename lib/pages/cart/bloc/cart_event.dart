import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

class ChangeQuantity extends CartEvent {
  final String itemId;
  final int quantity;

  const ChangeQuantity({required this.itemId, required this.quantity});

  @override
  List<Object?> get props => [itemId, quantity];
}

class SyncQuantity extends CartEvent {
  final String itemId;
  final int quantity;

  const SyncQuantity({required this.itemId, required this.quantity});

  @override
  List<Object?> get props => [itemId, quantity];
}

class AddToCart extends CartEvent {
  final String stockId;
  final int quantity;

  const AddToCart({required this.stockId, required this.quantity});

  @override
  List<Object?> get props => [stockId, quantity];
}

class ApplyDiscount extends CartEvent {
  final int discountAmount;

  const ApplyDiscount({required this.discountAmount});

  @override
  List<Object?> get props => [discountAmount];
}

class DeleteCartItem extends CartEvent {
  final String itemId;

  const DeleteCartItem({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

class ClearCart extends CartEvent {}

class AddServiceToCart extends CartEvent {
  final int serviceId;
  final int quantity;

  const AddServiceToCart({required this.serviceId, this.quantity = 1});

  @override
  List<Object?> get props => [serviceId, quantity];
}

class Checkout extends CartEvent {
  final String customerName;
  final String phone;
  final String vehicle;
  final String plate;

  const Checkout({
    required this.customerName,
    required this.phone,
    required this.vehicle,
    required this.plate,
  });

  @override
  List<Object?> get props => [customerName, phone, vehicle, plate];
}

class PrepareCheckout extends CartEvent {}
