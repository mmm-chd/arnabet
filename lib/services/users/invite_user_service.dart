import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/user/add_user_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class InviteUserService {
  static const _intitePath = ConstantApi.invite;
  Future<AddUserModel> invite(String email, String role) async {
    try {
      final response = await Client.dio.post(
        _intitePath,
        data: {"email": email, "role": role},
      );

      final body = AddUserModel.fromJson(response.data);

      if (body.success == true) {
        return body;
      } else {
        throw Exception("Gagal menambahkan user");
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
        serverMessage ?? 'Gagal menambahkan user\n(Status: $statusCode)',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
