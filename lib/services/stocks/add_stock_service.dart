import 'dart:async';
import 'package:arena/config/network/client.dart';
import 'package:arena/models/stock/add_stock_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';
import 'package:arena/config/network/constant_api.dart';

class AddStockService {
  static const _addStockPath = ConstantApi.addStock;
  Future<AddStockModel> addStock({
    required String productId,
    required String note,
    required List<Map<String, dynamic>> stockBatches,
  }) async {
    try {
      final payload = {
        "product_id": productId,
        "note": note,
        "stock_batches": stockBatches,
      };

      final response = await Client.dio.post(_addStockPath, data: payload);

      final body = AddStockModel.fromJson(response.data);

      if (body.success == true) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal tambah stock");
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
        serverMessage ?? 'Gagal tambah stock\n(Status: $statusCode)',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
