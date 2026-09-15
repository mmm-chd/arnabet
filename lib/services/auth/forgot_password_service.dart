import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/auth/request_reset_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class ForgotPasswordService {
  static const String _requestResetPath = ConstantApi.requestReset;
  static const String _resetPasswordPath = ConstantApi.resetPassword;

  Future<RequestResetModel> requestReset({required String email}) async {
    try {
      final response = await Client.dio.post(
        _requestResetPath,
        data: {'email': email},
      );
      return RequestResetModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(extractServerMessage(e));
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<RequestResetModel> resetPassword({
    required String email,
    required String password,
    required String otp,
  }) async {
    try {
      final response = await Client.dio.post(
        _resetPasswordPath,
        data: {'email': email, 'password': password, 'otp': otp},
      );
      return RequestResetModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        throw Exception(
          'Terlalu banyak percobaan reset password, coba beberapa saat lagi',
        );
      }
      throw Exception(extractServerMessage(e));
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
