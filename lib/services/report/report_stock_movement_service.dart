import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/report/stock_movement_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class ReportStockMovementService {
  static const _stockMovementPath = ConstantApi.reportsStockMovement;

  Future<StockMovementModel> getStockMovement({
    required String period,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParameters = <String, dynamic>{"period": period};
      if (startDate != null && endDate != null) {
        queryParameters["start_date"] =
            DateFormat("yyyy-MM-dd").format(startDate);
        queryParameters["end_date"] = DateFormat("yyyy-MM-dd").format(endDate);
      }

      final response = await Client.dio.get(
        _stockMovementPath,
        queryParameters: queryParameters,
        options: Options(responseType: ResponseType.plain),
      );
      final body = parseStockMovement(response.data as String);
      if (body.success == true) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal memuat pergerakan stok");
      }
    } on DioException catch (e) {
      final serverMessage = extractServerMessage(e);
      throw Exception(serverMessage ?? "Gagal memuat pergerakan stok");
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
