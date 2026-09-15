import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/notification/notification_list_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class NotificationListService {
  static const String _getNotificationPath = ConstantApi.notifications;

  Future<NotificationListModel> getNotifications({
    String unreadOnly = 'true',
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'unread_only': unreadOnly,
        'page': page,
        'limit': limit,
      };

      final response = await Client.dio.get(
        _getNotificationPath,
        queryParameters: queryParameters,
      );
      final body = NotificationListModel.fromJson(response.data);

      if (body.success == true && body.data != null) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal mengambil data notifikasi");
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
        serverMessage ??
            'Gagal mengambil data notifikasi\n(Status: $statusCode)',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
