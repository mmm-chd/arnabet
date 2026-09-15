import 'dart:async';
import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/stock/adjust_stock_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class AdjustStockService {
  static const _adjustStockPath = ConstantApi.adjustStock;

  Future<AdjustStockModel> adjustStock({
    required String stockId,
    required int newQuantity,
    required String reason,
  }) async {
    try {
      final payload = {
        "stock_id": stockId,
        "new_quantity": newQuantity,
        "reason": reason,
      };

      final response = await Client.dio.patch(_adjustStockPath, data: payload);

      final body = AdjustStockModel.fromJson(response.data);

      if (body.success == true) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal menyesuaikan stock");
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
        serverMessage ?? 'Gagal menyesuaikan stock\n(Status: $statusCode)',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
