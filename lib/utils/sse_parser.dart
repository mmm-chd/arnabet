import 'dart:convert';
import 'package:flutter/foundation.dart';

extension SseParser on Stream<String> {
  Stream<Map<String, dynamic>> parseSseData() async* {
    await for (final line in this) {
      if (!line.startsWith('data:')) continue;

      try {
        final jsonString = line.substring(5).trim();
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        yield json;
      } catch (_) {
      }
    }
  }
}
