import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/auth/login_model.dart';
import 'package:arena/utils/app_secure_storage.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:arena/utils/session_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LogInOutService {
  static const _loginPath = ConstantApi.login;
  static const _logoutPath = ConstantApi.logout;

  Future<LoginModel> login(String email, String password) async {
    try {
      final response = await Client.dio.post(
        _loginPath,
        data: {'email': email, 'password': password},
      );

      final body = LoginModel.fromJson(response.data);
      final data = body.data;

      if (body.success == true && data != null) {
        await SessionManager.saveAccessToken(data.accessToken!);
        await AppSecureStorage.write(key: 'user_id', value: data.user!.id);
        await AppSecureStorage.write(key: 'user_role', value: data.user!.role);
        await AppSecureStorage.write(
          key: 'user_email',
          value: data.user!.email!,
        );
        return body;
      } else {
        throw Exception(body.message ?? 'Login gagal');
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final serverMessage = extractServerMessage(e);

      if (e.response?.statusCode == 500 ||
          e.response?.statusCode == 502 ||
          e.response?.statusCode == 530) {
        throw Exception(
          'Server sedang dalam pemeliharaan, coba beberapa saat lagi',
        );
      }

      if (e.response?.statusCode == 429) {
        throw Exception(
          'Terlalu banyak percobaan login, coba beberapa saat lagi',
        );
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception('Waktu koneksi habis');
      }
      if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Tidak dapat terhubung ke server. Tidak ada koneksi internet atau server tidak dapat dijangkau.',
        );
      }
      throw Exception(serverMessage ?? 'Login gagal\n(Status: $statusCode)');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Verifies a password by calling the login endpoint WITHOUT persisting the
  /// resulting session, used to confirm the current password during a change.
  Future<void> verifyPassword(String email, String password) async {
    try {
      final response = await Client.dio.post(
        _loginPath,
        data: {'email': email, 'password': password},
      );

      final body = LoginModel.fromJson(response.data);
      if (body.success != true) {
        throw Exception(body.message ?? 'Password saat ini salah');
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      if (statusCode == 401) {
        throw Exception('Password saat ini salah');
      }
      if (e.response?.statusCode == 429) {
        throw Exception(
          'Terlalu banyak percobaan login, coba beberapa saat lagi',
        );
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception('Waktu koneksi habis');
      }
      if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Tidak dapat terhubung ke server. Tidak ada koneksi internet atau server tidak dapat dijangkau.',
        );
      }
      throw Exception(
        extractServerMessage(e) ?? 'Login gagal\n(Status: $statusCode)',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> logout() async {
    try {
      await Client.dio.post(_logoutPath);
    } on DioException catch (_) {
    } catch (_) {
    } finally {
      await SessionManager.clearSession();
    }
  }
}
