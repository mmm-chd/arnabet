import 'package:arena/models/enums/role.dart';
import 'package:arena/utils/app_secure_storage.dart';

class UserSession {
  UserSession._();

  static Role? _cachedRole;

  static Role get role => _cachedRole ?? Role.unknown;

  static void setRole(Role role) {
    _cachedRole = role;
  }

  static Future<Role> getOrFetchRole() async {
    if (_cachedRole != null && _cachedRole != Role.unknown) {
      return _cachedRole!;
    }

    try {
      final roleStr = await AppSecureStorage.read(key: 'user_role');
      final role = Role.fromString(roleStr);
      _cachedRole = role;
      return role;
    } catch (_) {
      _cachedRole = Role.unknown;
      return Role.unknown;
    }
  }

  static void clear() {
    _cachedRole = null;
  }
}
