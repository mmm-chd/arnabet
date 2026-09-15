import 'dart:io';

import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

const _exportPrefix = "arena-ban-ringkasan-";

enum ReportExportFormat { pdf, excel }

extension ReportExportFormatX on ReportExportFormat {
  String get query => this == ReportExportFormat.pdf ? "pdf" : "xlsx";
  String get extension => this == ReportExportFormat.pdf ? "pdf" : "xlsx";
}

class ReportExportService {
  static const _summaryPath = ConstantApi.reportsSummary;
  Future<String> exportSummary({
    required String period,
    required ReportExportFormat format,
    DateTime? startDate,
    DateTime? endDate,
    void Function(int received, int total)? onProgress,
  }) async {
    final dir = await getTemporaryDirectory();
    final fileName = "$_exportPrefix$period.${format.extension}";
    final savePath = "${dir.path}/$fileName";
    final file = File(savePath);

    try {
      await _cleanupStaleExports(dir.path, keep: fileName);

      final queryParameters = <String, dynamic>{
        "period": period,
        "format": format.query,
      };
      if (startDate != null && endDate != null) {
        queryParameters["start_date"] =
            DateFormat("yyyy-MM-dd").format(startDate);
        queryParameters["end_date"] = DateFormat("yyyy-MM-dd").format(endDate);
      }

      await Client.dio.download(
        _summaryPath,
        savePath,
        queryParameters: queryParameters,
        onReceiveProgress: onProgress,
      );

      if (!await file.exists() || await file.length() == 0) {
        throw Exception("File laporan kosong");
      }

      return file.path;
    } on DioException catch (e) {
      final serverMessage = extractServerMessage(e);
      await _deleteIfExists(file);
      throw Exception(serverMessage ?? "Gagal mengekspor laporan");
    } catch (e) {
      await _deleteIfExists(file);
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<void> _cleanupStaleExports(
    String dirPath, {
    required String keep,
  }) async {
    try {
      final dir = Directory(dirPath);
      if (!await dir.exists()) return;
      await for (final entity in dir.list()) {
        if (entity is! File) continue;
        if (!entity.uri.pathSegments.last.startsWith(_exportPrefix)) continue;
        if (entity.uri.pathSegments.last == keep) continue;
        try {
          await entity.delete();
        } catch (_) {}
      }
    } catch (_) {}
  }

  Future<void> _deleteIfExists(File file) async {
    try {
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }
}
