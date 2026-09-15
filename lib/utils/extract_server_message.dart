import 'package:dio/dio.dart';

String? extractServerMessage(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map) {
        return data['message']?.toString();
      }
    } catch (_) {}
    return null;
  }