import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/report/stock_health_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class ReportStockHealthService {
  static const _stockHealthPath = ConstantApi.reportsStockHealth;

  Future<StockHealthModel> getStockHealth({
    required String period,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParameters = <String, dynamic>{"period": period};
      if (startDate != null && endDate != null) {
        queryParameters["start_date"] = DateFormat(
          "yyyy-MM-dd",
        ).format(startDate);
        queryParameters["end_date"] = DateFormat("yyyy-MM-dd").format(endDate);
      }

      final response = await Client.dio.get(
        _stockHealthPath,
        queryParameters: queryParameters,
        options: Options(responseType: ResponseType.plain),
      );
      final body = parseStockHealth(response.data as String);
      if (body.success == true) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal memuat kesehatan stok");
      }
    } on DioException catch (e) {
      final serverMessage = extractServerMessage(e);
      throw Exception(serverMessage ?? "Gagal memuat kesehatan stok");
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
