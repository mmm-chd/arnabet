import 'dart:async';
import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/stock/stock_list_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class StockListService {
  static const _stocksPath = ConstantApi.stocks;
  Future<StockListModel> getStocks({
    String? stockStatus,
    String? search,
    String? brandName,
    String? sortBy,
    int page = 1, 
    int limit = 20,
  }) async {
    try {
      final queryParameters = {
        'stock_status': stockStatus,
        'search': search,
        'page': page,
        'limit': limit,
        'sort_by': sortBy,
      };
      if (brandName != null && brandName.isNotEmpty) {
        queryParameters['brand_name'] = brandName;
      }
      final response = await Client.dio.get(
        _stocksPath,
        queryParameters: queryParameters,
      );

      final body = StockListModel.fromJson(response.data);

      if (body.success == true && body.data != null) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal mengambil data stock");
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
        serverMessage ?? 'Gagal mengambil data stock\n(Status: $statusCode)',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
