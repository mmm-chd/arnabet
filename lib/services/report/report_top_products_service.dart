import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/report/top_products_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class ReportTopProductsService {
  static const _topProductsPath = ConstantApi.reportsTopProducts;

  Future<TopProductsModel> getTopProducts({
    required String period,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParameters = <String, dynamic>{"period": period, "limit": 50};
      if (startDate != null && endDate != null) {
        queryParameters["start_date"] =
            DateFormat("yyyy-MM-dd").format(startDate);
        queryParameters["end_date"] = DateFormat("yyyy-MM-dd").format(endDate);
      }

      final response = await Client.dio.get(
        _topProductsPath,
        queryParameters: queryParameters,
        options: Options(responseType: ResponseType.plain),
      );
      final body = parseTopProducts(response.data as String);
      if (body.success == true) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal memuat produk terlaris");
      }
    } on DioException catch (e) {
      final serverMessage = extractServerMessage(e);
      throw Exception(serverMessage ?? "Gagal memuat produk terlaris");
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
