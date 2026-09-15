import 'dart:async';

import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/stock/stock_detail_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class StockDetailService {
  static const _stocksDetailPath = ConstantApi.stockDetail;

  Future<StockDetailModel> getStockDetail(String productId) async {
    try {
      final response = await Client.dio.get(
        _stocksDetailPath.replaceFirst("{id}", productId),
      );

      final body = StockDetailModel.fromJson(response.data);

      if (body.success == true && body.data != null) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal mengambil detail stock");
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final serverMessage = extractServerMessage(e);

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception("Waktu koneksi habis");
      }

      if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          "Tidak ada koneksi internet atau server tidak dapat dijangkau",
        );
      }

      throw Exception(
        serverMessage ?? "Gagal mengambil detail stock\n(Status: $statusCode)",
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
