import 'package:arena/models/auth/login_model.dart';
import 'package:arena/models/auth/profile_model.dart';
import 'package:arena/models/auth/register_model.dart';
import 'package:arena/models/auth/request_reset_model.dart';
import 'package:arena/services/auth/forgot_password_service.dart';
import 'package:arena/services/auth/log_in_out_service.dart';
import 'package:arena/services/auth/profile_service.dart';
import 'package:arena/services/auth/register_service.dart';

class AuthRepository {
  final LogInOutService _logInOutService;
  final RegisterService _registerService;
  final ProfileService _profileService;
  final ForgotPasswordService _forgotPasswordService;

  AuthRepository({
    LogInOutService? logInOutService,
    RegisterService? registerService,
    ProfileService? profileService,
    ForgotPasswordService? forgotPasswordService,
  })  : _logInOutService = logInOutService ?? LogInOutService(),
        _registerService = registerService ?? RegisterService(),
        _profileService = profileService ?? ProfileService(),
        _forgotPasswordService =
            forgotPasswordService ?? ForgotPasswordService();

  Future<LoginModel> login(String email, String password) {
    return _logInOutService.login(email, password);
  }

  Future<void> verifyPassword({
    required String email,
    required String password,
  }) {
    return _logInOutService.verifyPassword(email, password);
  }

  Future<void> logout() {
    return _logInOutService.logout();
  }

  Future<RegisterModel> register(
    String inviteToken,
    String name,
    String password,
  ) {
    return _registerService.register(inviteToken, name, password);
  }

  Future<ProfileModel> getProfile() {
    return _profileService.getProfile();
  }

  Future<ProfileModel> updateProfile(String name) {
    return _profileService.updateProfile(name);
  }

  Future<RequestResetModel> requestReset({required String email}) {
    return _forgotPasswordService.requestReset(email: email);
  }

  Future<RequestResetModel> resetPassword({
    required String email,
    required String password,
    required String otp,
  }) {
    return _forgotPasswordService.resetPassword(
      email: email,
      password: password,
      otp: otp,
    );
  }
}
