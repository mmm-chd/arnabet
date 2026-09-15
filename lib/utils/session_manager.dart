import 'package:arena/utils/app_secure_storage.dart';
import 'package:arena/utils/app_shared_preferances.dart';

class SessionManager {
  static const _accessToken = 'access_token';

  static Future<void> saveAccessToken(String sessionId) async {
    await AppSecureStorage.write(key: _accessToken, value: sessionId);
  }

  static Future<String?> readAccessToken() async {
    final session = await AppSecureStorage.read(key: _accessToken);
    return session;
  }

  static Future<void> clearSession() async {
    await AppSecureStorage.deleteAll();
    await AppSharedPreferances.clear();
  }
}
