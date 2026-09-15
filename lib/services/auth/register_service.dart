import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/auth/register_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class RegisterService {
  static const String _registerPath = ConstantApi.register;

  Future<RegisterModel> register(
    String inviteToken,
    String name,
    String password,
  ) async {
    try {
      final response = await Client.dio.post(
        _registerPath,
        data: {
          'invite_token': inviteToken,
          'name': name,
          'password': password,
        },
      );

      final body = RegisterModel.fromJson(response.data);
      final data = body.data;

      if (body.success == true && data != null) {
        return body;
      } else {
        throw Exception(body.message ?? 'Registrasi gagal');
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
        serverMessage ?? 'Registrasi gagal\n(Status: $statusCode)',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
