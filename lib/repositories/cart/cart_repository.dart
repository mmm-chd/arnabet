import 'package:arena/models/cart/add_cart_model.dart';
import 'package:arena/models/cart/cart_list_model.dart';
import 'package:arena/services/cart/add_cart_service.dart';
import 'package:arena/services/cart/add_service_cart_service.dart';
import 'package:arena/models/cart/checkout_cart_model.dart';
import 'package:arena/services/cart/cart_list_service.dart';
import 'package:arena/services/cart/checkout_cart_service.dart';
import 'package:arena/services/cart/clear_cart_service.dart';
import 'package:arena/services/cart/delete_cart_item_service.dart';
import 'package:arena/services/cart/discount_cart_service.dart';
import 'package:arena/services/cart/update_cart_service.dart';

class CartRepository {
  final CartListService _cartListService;
  final AddCartService _addCartService;
  final AddServiceCartService _addServiceCartService;
  final UpdateCartService _updateCartService;
  final DiscountCartService _discountCartService;
  final DeleteCartItemService _deleteCartItemService;
  final ClearCartService _clearCartService;
  final CheckoutCartService _checkoutCartService;

  CartRepository({
    CartListService? cartListService,
    AddCartService? addCartService,
    AddServiceCartService? addServiceCartService,
    UpdateCartService? updateCartService,
    DiscountCartService? discountCartService,
    DeleteCartItemService? deleteCartItemService,
    ClearCartService? clearCartService,
    CheckoutCartService? checkoutCartService,
  })  : _cartListService = cartListService ?? CartListService(),
        _addCartService = addCartService ?? AddCartService(),
        _addServiceCartService =
            addServiceCartService ?? AddServiceCartService(),
        _updateCartService = updateCartService ?? UpdateCartService(),
        _discountCartService = discountCartService ?? DiscountCartService(),
        _deleteCartItemService =
            deleteCartItemService ?? DeleteCartItemService(),
        _clearCartService = clearCartService ?? ClearCartService(),
        _checkoutCartService = checkoutCartService ?? CheckoutCartService();

  Future<AddCartModel> updateCartItem({
    required String itemId,
    required int quantity,
  }) {
    return _updateCartService.updateCartItem(
      itemId: itemId,
      quantity: quantity,
    );
  }

  Future<CartListModel> getCart() {
    return _cartListService.getCart();
  }

  Future<AddCartModel> addToCart({
    required String stockId,
    required int quantity,
  }) {
    return _addCartService.addCart(stockId: stockId, quantity: quantity);
  }

  Future<AddCartModel> addServiceToCart({
    required int serviceId,
    required int quantity,
  }) {
    return _addServiceCartService.addService(
      serviceId: serviceId,
      quantity: quantity,
    );
  }

  Future<AddCartModel> applyDiscount({required int discountAmount}) {
    return _discountCartService.applyDiscount(discountAmount: discountAmount);
  }

  Future<AddCartModel> deleteCartItem({required String itemId}) {
    return _deleteCartItemService.deleteCartItem(itemId: itemId);
  }

  Future<AddCartModel> clearCart() {
    return _clearCartService.clearCart();
  }

  Future<CheckoutCartModel> checkoutCart({
    required String customerName,
    required String phone,
    required String vehicle,
    required String plate,
  }) {
    return _checkoutCartService.checkoutCart(
      customerName: customerName,
      phone: phone,
      vehicle: vehicle,
      plate: plate,
    );
  }
}
