import 'dart:async';
import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/cart/add_cart_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class AddServiceCartService {
  static const _addServiceCartPath = ConstantApi.addCartService;
  Future<AddCartModel> addService({
    required int serviceId,
    required int quantity,
  }) async {
    try {
      final response = await Client.dio.post(
        _addServiceCartPath,
        data: {"service_id": serviceId, "quantity": quantity},
      );

      final body = AddCartModel.fromJson(response.data);

      if (body.success == true && body.data != null) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal tambah layanan ke cart");
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
        serverMessage ?? 'Gagal tambah layanan ke cart\n(Status: $statusCode)',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}