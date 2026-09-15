import 'package:arena/helper/currency_local_formatter.dart';
import 'package:equatable/equatable.dart';
import '../../../models/cart/cart_list_model.dart';

enum CartListStatus { initial, loading, ready, submitting, success, failure }

enum CheckoutStatus { idle, submitting, success, failure }

class CartState extends Equatable {
  final CartListStatus status;
  final CartListData? cartListData;
  final List<Map<String, dynamic>>? orderItems;
  final String message;
  final Set<String> syncingItemIds;
  final CheckoutStatus checkoutStatus;
  final String checkoutMessage;

  const CartState({
    this.status = CartListStatus.initial,
    this.cartListData,
    this.orderItems,
    this.message = '',
    this.syncingItemIds = const {},
    this.checkoutStatus = CheckoutStatus.idle,
    this.checkoutMessage = '',
  });

  @override
  List<Object?> get props => [
    status,
    cartListData,
    orderItems,
    message,
    syncingItemIds,
    checkoutStatus,
    checkoutMessage,
  ];

  CartState copyWith({
    CartListStatus? status,
    CartListData? cartListData,
    List<Map<String, dynamic>>? orderItems,
    String? message,
    Set<String>? syncingItemIds,
    CheckoutStatus? checkoutStatus,
    String? checkoutMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      cartListData: cartListData ?? this.cartListData,
      orderItems: orderItems ?? this.orderItems,
      message: message ?? this.message,
      syncingItemIds: syncingItemIds ?? this.syncingItemIds,
      checkoutStatus: checkoutStatus ?? this.checkoutStatus,
      checkoutMessage: checkoutMessage ?? this.checkoutMessage,
    );
  }

  bool get isLoading => status == CartListStatus.loading;
  bool get isReady => status == CartListStatus.ready;
  bool get isSubmitting => status == CartListStatus.submitting;
  bool get isFailure => status == CartListStatus.failure;
  bool get isSuccess => status == CartListStatus.success;

  bool get isCheckoutSubmitting => checkoutStatus == CheckoutStatus.submitting;
  bool get isCheckoutSuccess => checkoutStatus == CheckoutStatus.success;
  bool get isCheckoutFailure => checkoutStatus == CheckoutStatus.failure;

  bool get hasCartListModel => cartListData?.items?.isNotEmpty ?? false;

  bool isSyncing(String itemId) => syncingItemIds.contains(itemId);

  bool isServiceInCart(int? serviceId) {
    if (serviceId == null) return false;
    return (cartListData?.items ?? const []).any(
      (item) => item.itemType == 'SERVICE' && item.serviceId == serviceId,
    );
  }

  int get rawTotalHarga => cartListData?.subtotal ?? 0;

  int get discountAmount => cartListData?.discount ?? 0;

  bool get hasDiscount => discountAmount > 0;

  int get finalTotalHarga => cartListData?.total ?? 0;

  String get displayRawTotalHarga => rawTotalHarga.toLocaleCurrency();

  String get displayTotalHarga => finalTotalHarga.toLocaleCurrency();
}