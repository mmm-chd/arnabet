import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class UserService {
  static const String _updateActivationPath = ConstantApi.updateUserActivation;
  static const String _updateRolePath = ConstantApi.updateUserRole;

  Future<bool> updateUserActivation({
    required String userId,
    required bool isActive,
  }) async {
    try {
      final path = _updateActivationPath.replaceAll('{id}', userId);
      final response = await Client.dio.patch(
        path,
        data: {'is_active': isActive},
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      final msg = extractServerMessage(e);
      throw Exception(msg ?? 'Gagal mengubah status user');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<bool> updateUserRole({
    required String userId,
    required String role,
  }) async {
    try {
      final path = _updateRolePath.replaceAll('{id}', userId);
      final response = await Client.dio.patch(path, data: {'role': role});
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      final msg = extractServerMessage(e);
      throw Exception(msg ?? 'Gagal mengubah role user');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
