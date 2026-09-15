import 'package:arena/models/enums/role.dart';
import 'package:arena/pages/splash/bloc/splash_event.dart';
import 'package:arena/pages/splash/bloc/splash_state.dart';
import 'package:arena/utils/app_secure_storage.dart';
import 'package:arena/utils/session_manager.dart';
import 'package:arena/services/auth/user_session.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<AppStarted>(_onAppStarted);
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<SplashState> emit,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    final token = await SessionManager.readAccessToken();
    if (token != null) {
      final roleStr = await AppSecureStorage.read(key: 'user_role');
      final role = Role.fromString(roleStr);
      UserSession.setRole(role);
      emit(SplashLoaded(role: role));
    } else {
      emit(SplashFailure('Token not found'));
    }
  }
}
