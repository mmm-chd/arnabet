import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/stock/stock_status_rule_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class StockStatusRuleService {
  static const String _stockStatusRulesPath = ConstantApi.stockStatusRules;
  static const String _updateStockStatusRulePath =
      ConstantApi.updateStockStatusRule;

  Future<StockStatusRuleModel> getStockStatusRules() async {
    try {
      final response = await Client.dio.get(_stockStatusRulesPath);

      final body = StockStatusRuleModel.fromJson(response.data);

      if (body.success == true && body.data != null) {
        return body;
      }
      throw Exception(body.message ?? "Gagal mengambil data threshold stock");
    } on DioException catch (e) {
      throw _mapDioError(e, "Gagal mengambil data threshold stock");
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<String> updateStockStatusRule({
    required String id,
    int? minQty,
    int? maxQty,
  }) async {
    try {
      final response = await Client.dio.patch(
        _updateStockStatusRulePath.replaceFirst("{id}", id),
        data: {"min_qty": minQty, "max_qty": maxQty},
      );

      final body = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};

      if (body["success"] == true) {
        return body["message"]?.toString() ?? "Threshold stock berhasil diperbarui";
      }
      throw Exception(
        body["message"]?.toString() ?? "Gagal memperbarui threshold stock",
      );
    } on DioException catch (e) {
      throw _mapDioError(e, "Gagal memperbarui threshold stock");
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Exception _mapDioError(DioException e, String fallbackMessage) {
    final statusCode = e.response?.statusCode;
    final serverMessage = extractServerMessage(e);
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return Exception('Waktu koneksi habis');
    }
    if (e.type == DioExceptionType.connectionError) {
      return Exception(
        'Tidak ada koneksi internet atau server tidak dapat dijangkau',
      );
    }
    return Exception(
      serverMessage ?? '$fallbackMessage\n(Status: $statusCode)',
    );
  }
}