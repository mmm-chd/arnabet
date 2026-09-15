import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/enums/enums.dart';
import 'package:arena/models/payments/pay_order_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class PaymentService {
  static const _payOrderPath = ConstantApi.payOrder;
  static const _confirmPaymentPath = ConstantApi.confirmPayment;
  static const _qrisStatusPath = ConstantApi.qrisPaymentStatus;
  static const _vaStatusPath = ConstantApi.vaPaymentStatus;

  Future<PayOrderModel> confirmPayment({
    required String orderId,
    String? notes,
  }) async {
    try {
      final response = await Client.dio.post(
        _confirmPaymentPath.replaceFirst("{id}", orderId),
        data: {
          if (notes != null && notes.isNotEmpty) "notes": notes,
        },
      );

      final body = PayOrderModel.fromJson(response.data);

      if (body.success == true && body.data != null) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal mengonfirmasi pembayaran");
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final serverMessage = extractServerMessage(e);
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception('Waktu koneksi habis');
      }
      if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Tidak ada koneksi internet atau server tidak dapat dijangkau',
        );
      }
      throw Exception(
        serverMessage ??
            'Gagal mengonfirmasi pembayaran\n(Status: $statusCode)',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<PayOrderModel> payOrder({
    required String orderId,
    required PaymentMethod method,
    int? amount,
    String? notes,
    String? bankCode,
  }) async {
    try {
      final response = await Client.dio.post(
        _payOrderPath.replaceFirst("{id}", orderId),
        data: {
          "method": paymentMethodValues.reverse[method],
          if (amount != null) "amount": amount,
          if (notes != null && notes.isNotEmpty) "notes": notes,
          if (bankCode != null && bankCode.isNotEmpty) "bank_code": bankCode,
        },
      );

      final body = PayOrderModel.fromJson(response.data);

      if (body.success == true && body.data != null) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal memproses pembayaran");
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final serverMessage = extractServerMessage(e);
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception('Waktu koneksi habis');
      }
      if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Tidak ada koneksi internet atau server tidak dapat dijangkau',
        );
      }
      throw Exception(
        serverMessage ?? 'Gagal memproses pembayaran\n(Status: $statusCode)',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<PayOrderModel> getQRISStatus({required String orderId}) async {
    return _getPaymentStatus(
      path: _qrisStatusPath.replaceFirst("{id}", orderId),
      fallbackMessage: "Gagal memeriksa status QRIS",
    );
  }

  Future<PayOrderModel> getVAStatus({required String orderId}) async {
    return _getPaymentStatus(
      path: _vaStatusPath.replaceFirst("{id}", orderId),
      fallbackMessage: "Gagal memeriksa status Virtual Account",
    );
  }

  Future<PayOrderModel> _getPaymentStatus({
    required String path,
    required String fallbackMessage,
  }) async {
    try {
      final response = await Client.dio.get(path);

      final body = PayOrderModel.fromJson(response.data);

      if (body.success == true && body.data != null) {
        return body;
      } else {
        throw Exception(body.message ?? fallbackMessage);
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final serverMessage = extractServerMessage(e);
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception('Waktu koneksi habis');
      }
      if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Tidak ada koneksi internet atau server tidak dapat dijangkau',
        );
      }
      throw Exception(serverMessage ?? '$fallbackMessage\n(Status: $statusCode)');
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}