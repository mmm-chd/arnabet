import 'dart:async';
import 'package:arena/config/network/client.dart';
import 'package:arena/models/enums/enums.dart';
import 'package:arena/models/order/order_list_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';
import 'package:arena/config/network/constant_api.dart';

class OrderListService {
  static const _ordersPath = ConstantApi.orders;

  Future<OrderListModel> getOrders({
    OrderStatus? orderStatus,
    PaymentStatus? paymentStatus,
    PaymentMethod? paymentMethod,
    String? search,
    String? startDate,
    String? endDate,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await Client.dio.get(
        _ordersPath,
        queryParameters: {
          'order_status': orderStatus?.name,
          'payment_status': paymentStatus?.name,
          'payment_method': paymentMethod?.name,
          'search': search,
          'start_date': startDate,
          'end_date': endDate,
          'page': page,
          'limit': limit,
        },
      );
      final body = OrderListModel.fromJson(response.data);

      if (body.success == true && body.data != null) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal mengambil data order");
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
        serverMessage ?? 'Gagal mengambil data order\n(Status: $statusCode)',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
