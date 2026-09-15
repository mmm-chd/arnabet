import 'dart:async';
import 'dart:convert';

import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/notification/notification_sse_model.dart';
import 'package:arena/utils/sse_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NotificationSseService {
  static const String _path = ConstantApi.notificationsSse;

  Stream<NotificationSSEModel> unreadCount() async* {
    try {
      final response = await Client.dio.get(
        _path,
        options: Options(
          responseType: ResponseType.stream,
          headers: const {'Accept': 'text/event-stream'},
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      final Stream<Uint8List> rawStream = response.data.stream;

      final stream = rawStream
          .transform(
            StreamTransformer<Uint8List, List<int>>.fromHandlers(
              handleData: (data, sink) => sink.add(data),
            ),
          )
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      await for (final json in stream.parseSseData()) {
        try {
          yield NotificationSSEModel.fromJson(json);
        } catch (_) {
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
