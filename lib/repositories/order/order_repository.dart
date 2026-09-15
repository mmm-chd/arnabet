import 'package:arena/models/enums/enums.dart';
import 'package:arena/models/order/order_list_model.dart';
import 'package:arena/repositories/payment/payment_repository.dart';
import 'package:arena/services/order/order_list_service.dart';
import 'package:arena/services/order/update_order_service.dart';

class OrderRepository {
  final OrderListService _orderListService;
  final UpdateOrderService _updateOrderService;
  final PaymentRepository _paymentRepository;

  OrderRepository({
    OrderListService? orderListService,
    UpdateOrderService? updateOrderService,
    PaymentRepository? paymentRepository,
  }) : _orderListService = orderListService ?? OrderListService(),
       _updateOrderService = updateOrderService ?? UpdateOrderService(),
       _paymentRepository = paymentRepository ?? PaymentRepository();

  Future<void> confirmPayment({
    required String orderId,
    String? notes,
  }) async {
    await _paymentRepository.confirmPayment(orderId: orderId, notes: notes);
  }

  Future<OrderListModel> getOrders({
    OrderStatus? orderStatus,
    PaymentStatus? paymentStatus,
    PaymentMethod? paymentMethod,
    String? search,
    String? startDate,
    String? endDate,
    int page = 1,
    int limit = 20,
  }) {
    return _orderListService.getOrders(
      orderStatus: orderStatus,
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
      search: search,
      startDate: startDate,
      endDate: endDate,
      page: page,
      limit: limit,
    );
  }

  Future<void> markAsPickedUp({required String orderId}) {
    return _updateOrderService.markAsPickedUp(orderId: orderId);
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) {
    return _updateOrderService.updateOrderStatus(
      orderId: orderId,
      status: status,
    );
  }

  Future<void> cancelOrder({required String orderId}) {
    return _updateOrderService.cancelOrder(orderId: orderId);
  }
}
