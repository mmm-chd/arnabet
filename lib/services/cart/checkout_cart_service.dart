import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/cart/checkout_cart_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class CheckoutCartService {
  static const _checkoutCartPath = ConstantApi.checkoutCart;
  Future<CheckoutCartModel> checkoutCart({
    required String customerName,
    required String phone,
    required String vehicle,
    required String plate,
  }) async {
    try {
      final response = await Client.dio.post(
        _checkoutCartPath,
        data: {
          "customer_name": customerName,
          "customer_phone": phone,
          "vehicle_model": vehicle,
          "vehicle_plate": plate,
        },
      );

      final body = CheckoutCartModel.fromJson(response.data);

      if (body.success == true && body.data != null) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal checkout");
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
      throw Exception(serverMessage ?? 'Gagal checkout\n(Status: $statusCode)');
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
