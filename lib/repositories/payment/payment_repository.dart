import 'package:arena/models/enums/enums.dart';
import 'package:arena/models/payments/pay_order_model.dart';
import 'package:arena/services/payment/payment_service.dart';

class PaymentRepository {
  final PaymentService _paymentService;

  PaymentRepository({PaymentService? paymentService})
    : _paymentService = paymentService ?? PaymentService();

  Future<PayOrderModel> payOrder({
    required String orderId,
    required PaymentMethod method,
    int? amount,
    String? notes,
    String? bankCode,
  }) {
    return _paymentService.payOrder(
      orderId: orderId,
      method: method,
      amount: amount,
      notes: notes,
      bankCode: bankCode,
    );
  }

  Future<PayOrderModel> confirmPayment({
    required String orderId,
    String? notes,
  }) {
    return _paymentService.confirmPayment(orderId: orderId, notes: notes);
  }

  Future<PayOrderModel> getQRISStatus({required String orderId}) {
    return _paymentService.getQRISStatus(orderId: orderId);
  }

  Future<PayOrderModel> getVAStatus({required String orderId}) {
    return _paymentService.getVAStatus(orderId: orderId);
  }

  Future<PayOrderModel> getStatus({
    required String orderId,
    required PaymentMethod method,
  }) {
    if (method == PaymentMethod.QRIS) {
      return getQRISStatus(orderId: orderId);
    }
    return getVAStatus(orderId: orderId);
  }
}
