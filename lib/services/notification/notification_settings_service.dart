import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/notification/notification_settings_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class NotificationSettingsService {
  static const String _settingsPath = ConstantApi.notificationSettings;

  Future<NotificationSettingsModel> getSettings() async {
    try {
      final response = await Client.dio.get(_settingsPath);

      final body = NotificationSettingsModel.fromJson(response.data);

      if (body.success == true && body.data != null) {
        return body;
      }
      throw Exception(body.message ?? "Gagal mengambil pengaturan notifikasi");
    } on DioException catch (e) {
      throw _mapDioError(e, "Gagal mengambil pengaturan notifikasi");
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<NotificationSettingsModel> updateSettings({
    required bool masterInApp,
    required bool masterEmail,
    required List<NotificationSettingItem> settings,
  }) async {
    try {
      final response = await Client.dio.put(
        _settingsPath,
        data: {
          "master_in_app": masterInApp,
          "master_email": masterEmail,
          "settings": settings
              .map((s) {
                final json = s.toJson();
                if (!NotificationSettingsData.emailSupportedTypes.contains(s.type)) {
                  json.remove('enabled_email');
                }
                return json;
              })
              .toList(),
        },
      );

      final body = NotificationSettingsModel.fromJson(response.data);

      if (body.success == true) {
        return body;
      }
      throw Exception(body.message ?? "Gagal memperbarui pengaturan notifikasi");
    } on DioException catch (e) {
      throw _mapDioError(e, "Gagal memperbarui pengaturan notifikasi");
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Exception _mapDioError(DioException e, String fallbackMessage) {
    final statusCode = e.response?.statusCode;
    final serverMessage = extractServerMessage(e);
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return Exception('Waktu koneksi habis');
    }
    if (e.type == DioExceptionType.connectionError) {
      return Exception(
        'Tidak ada koneksi internet atau server tidak dapat dijangkau',
      );
    }
    return Exception(
      serverMessage ?? '$fallbackMessage\n(Status: $statusCode)',
    );
  }
}