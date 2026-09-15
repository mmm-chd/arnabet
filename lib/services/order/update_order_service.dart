import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/enums/enums.dart';
import 'package:arena/models/order/add_order_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class UpdateOrderService {
  static const _updateOrderStatusPath = ConstantApi.updateOrderStatus;
  static const _markAsPickedUpPath = ConstantApi.markAsPickedUp;
  static const _cancelOrderPath = ConstantApi.cancelOrder;
  Future<AddOrderModel> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    try {
      final response = await Client.dio.patch(
        _updateOrderStatusPath,
        queryParameters: {"order_id": orderId},
        data: {"status": status.name},
      );

      final body = AddOrderModel.fromJson(response.data);

      if (body.success == true) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal update status order");
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
        serverMessage ?? 'Gagal update status order\n(Status: $statusCode)',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<AddOrderModel> markAsPickedUp({required String orderId}) async {
    try {
      final response = await Client.dio.patch(
        _markAsPickedUpPath.replaceFirst("{id}", orderId),
      );

      final body = AddOrderModel.fromJson(response.data);

      if (body.success == true) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal menandai sebagai diambil");
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
            'Gagal menandai sebagai diambil\n(Status: $statusCode)',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<AddOrderModel> cancelOrder({required String orderId}) async {
    try {
      final response = await Client.dio.patch(
        _cancelOrderPath.replaceFirst("{id}", orderId),
      );

      final body = AddOrderModel.fromJson(response.data);

      if (body.success == true) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal membatalkan order");
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
        serverMessage ?? 'Gagal membatalkan order\n(Status: $statusCode)',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}