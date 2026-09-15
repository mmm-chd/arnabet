import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/stock/dot_status_rule_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class DotStatusRuleService {
  static const _dotStatusRulesPath = ConstantApi.dotStatusRules;
  static const _updateDotStatusRulePath = ConstantApi.updateDotStatusRules;

  Future<DotStatusRuleModel> getDotStatusRules() async {
    try {
      final response = await Client.dio.get(_dotStatusRulesPath);

      final body = DotStatusRuleModel.fromJson(response.data);

      if (body.success == true && body.data != null) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal mengambil data dot");
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
        serverMessage ?? 'Gagal mengambil data dot\n(Status: $statusCode)',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<String> updateDotStatusRule({
    required String id,
    int? minMonth,
    int? maxMonth,
  }) async {
    try {
      final response = await Client.dio.patch(
        _updateDotStatusRulePath.replaceFirst("{id}", id),
        data: {"min_month": minMonth, "max_month": maxMonth},
      );

      final body = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};

      if (body["success"] == true) {
        return body["message"]?.toString() ?? "Rule berhasil diperbarui";
      }
      throw Exception(body["message"]?.toString() ?? "Gagal memperbarui rule");
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
        serverMessage ?? 'Gagal memperbarui rule\n(Status: $statusCode)',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
