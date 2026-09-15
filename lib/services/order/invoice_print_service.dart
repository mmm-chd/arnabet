import 'dart:convert';
import 'dart:typed_data';

import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:image/image.dart' as img;
import 'package:pdfx/pdfx.dart';

class InvoicePrintService {
  static const int printWidthPx = 384;

  Future<Uint8List> fetchInvoicePdf({
    required String orderId,
    required bool hideName,
  }) async {
    final path = ConstantApi.invoice.replaceFirst('{id}', orderId);
    try {
      final response = await Client.dio.get(
        path,
        queryParameters: {'hide_name': hideName ? '1' : '0'},
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 60),
          headers: {'Accept': 'application/pdf'},
        ),
      );

      final bytes = Uint8List.fromList(response.data ?? <int>[]);
      if (bytes.isEmpty) {
        throw Exception('File invoice kosong');
      }

      if (_looksLikeJson(bytes)) {
        final url = _extractDownloadUrl(bytes);
        if (url == null) {
          throw Exception(
            'Respons invoice tidak mengandung file PDF atau URL yang valid',
          );
        }
        final download = await Client.dio.get(
          url,
          options: Options(
            responseType: ResponseType.bytes,
            receiveTimeout: const Duration(seconds: 60),
          ),
        );
        final pdfBytes = Uint8List.fromList(download.data ?? <int>[]);
        if (pdfBytes.isEmpty) {
          throw Exception('File invoice kosong');
        }
        return pdfBytes;
      }

      return bytes;
    } on DioException catch (e) {
      throw Exception(extractServerMessage(e) ?? 'Gagal mengambil invoice');
    }
  }

  Future<void> printInvoicePdf({
    required Printer printer,
    required Uint8List pdfBytes,
    int targetWidth = printWidthPx,
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    final images = await renderInvoicePages(pdfBytes, targetWidth: targetWidth);

    final allBytes = <int>[];
    for (var i = 0; i < images.length; i++) {
      if (i > 0) {
        allBytes.addAll(generator.feed(2));
      }
      allBytes.addAll(generator.imageRaster(images[i]));
    }
    allBytes.addAll(generator.cut());
    await FlutterThermalPrinter.instance.printData(
      printer,
      allBytes,
      longData: true,
    );
  }

  Future<List<img.Image>> renderInvoicePages(
    Uint8List pdfBytes, {
    int targetWidth = printWidthPx,
  }) async {
    final document = await PdfDocument.openData(pdfBytes);
    try {
      final images = <img.Image>[];

      for (
        var pageNumber = 1;
        pageNumber <= document.pagesCount;
        pageNumber++
      ) {
        final page = await document.getPage(pageNumber);
        try {
          final renderWidth = targetWidth.toDouble();
          final renderHeight = (page.height * targetWidth / page.width).round();
          final rendered = await page.render(
            width: renderWidth,
            height: renderHeight.toDouble(),
            format: PdfPageImageFormat.png,
            backgroundColor: '#FFFFFF',
          );

          if (rendered == null) continue;

          var image = img.decodeImage(rendered.bytes);
          if (image == null) continue;

          final compatibleWidth = (image.width / 8).ceil() * 8;
          if (image.width != compatibleWidth) {
            image = img.copyResize(image, width: compatibleWidth);
          }
          image = img.grayscale(image);

          images.add(image);
        } finally {
          await page.close();
        }
      }

      if (images.isEmpty) {
        throw Exception('Gagal merender invoice');
      }

      return images;
    } finally {
      await document.close();
    }
  }

  bool _looksLikeJson(Uint8List bytes) {
    final head = utf8
        .decode(
          bytes.sublist(0, bytes.length < 16 ? bytes.length : 16),
          allowMalformed: true,
        )
        .trimLeft();
    return head.startsWith('{') || head.startsWith('[');
  }

  String? _extractDownloadUrl(Uint8List bytes) {
    try {
      final decoded = jsonDecode(utf8.decode(bytes, allowMalformed: true));
      return _findUrl(decoded);
    } catch (_) {
      return null;
    }
  }

  String? _findUrl(Object? value) {
    if (value is String) {
      if (value.startsWith('http')) return value;
      return null;
    }
    if (value is Map) {
      for (final entry in value.entries) {
        if (entry.value is String &&
            (entry.key == 'url' ||
                entry.key == 'file_url' ||
                entry.key == 'fileUrl' ||
                entry.key == 'download_url' ||
                entry.key == 'downloadUrl' ||
                entry.key == 'pdf_url' ||
                entry.key == 'pdfUrl')) {
          final url = entry.value as String;
          if (url.startsWith('http')) return url;
        }
        final nested = _findUrl(entry.value);
        if (nested != null) return nested;
      }
    }
    if (value is List) {
      for (final item in value) {
        final nested = _findUrl(item);
        if (nested != null) return nested;
      }
    }
    return null;
  }
}
