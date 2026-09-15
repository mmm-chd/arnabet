import 'dart:async';
import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/stock/update_stock_request_model.dart';
import 'package:arena/models/stock/update_stock_response_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class UpdateStockService {
  static const _updateStockPath = ConstantApi.updateStock;

  Future<UpdateStockResponseModel> updateStock(
    String stockId,
    UpdateStockRequestModel request,
  ) async {
    try {
      final path = _updateStockPath.replaceFirst("{id}", stockId);

      final response = await Client.dio.patch(path, data: request.toMap());

      final body = UpdateStockResponseModel.fromJson(response.data);

      if (body.success == true) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal memperbarui stock");
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
        serverMessage ?? 'Gagal memperbarui stock\n(Status: $statusCode)',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
