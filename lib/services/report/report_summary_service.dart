import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/report/summary_report_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class ReportSummaryService {
  static const _summaryPath = ConstantApi.reportsSummary;

  Future<ReportSummaryModel> getSummary({
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

      final t0 = DateTime.now();
      final response = await Client.dio.get(
        _summaryPath,
        queryParameters: queryParameters,
        options: Options(responseType: ResponseType.plain),
      );
      final t1 = DateTime.now();
      final body = parseReportSummary(response.data as String);
      final t2 = DateTime.now();
      if (body.success == true) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal memuat ringkasan laporan");
      }
    } on DioException catch (e) {
      final serverMessage = extractServerMessage(e);
      throw Exception(serverMessage ?? "Gagal memuat ringkasan laporan");
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
