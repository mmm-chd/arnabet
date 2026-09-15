import 'package:arena/config/network/client.dart';
import 'package:arena/models/cart/add_cart_model.dart';
import 'dart:async';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class AddCartService {
  static const _addCartPath = ConstantApi.addCart;
  Future<AddCartModel> addCart({
    required String stockId,
    required int quantity,
  }) async {
    try {
      final response = await Client.dio.post(
        _addCartPath,
        data: {"stock_id": stockId, "quantity": quantity},
      );

      final body = AddCartModel.fromJson(response.data);

      if (body.success == true && body.data != null) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal tambah cart");
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
        serverMessage ?? 'Gagal tambah cart\n(Status: $statusCode)',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
