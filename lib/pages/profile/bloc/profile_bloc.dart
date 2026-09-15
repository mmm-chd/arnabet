import 'package:arena/pages/profile/bloc/profile_event.dart';
import 'package:arena/pages/profile/bloc/profile_state.dart';
import 'package:arena/repositories/auth/auth_repository.dart';
import 'package:arena/utils/app_secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository;

  ProfileBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<LogoutProfileEvent>(_onLogoutProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final profile = await _authRepository.getProfile();
      final profileData = profile.data;

      final roleLocal =
          await AppSecureStorage.read(key: "user_role") ?? "Unknown";

      emit(
        ProfileLoaded(
          name: profileData!.name ?? "Unknown",
          email: profileData.email ?? "Unknown",
          role: profileData.role?.toUpperCase() ?? roleLocal.toUpperCase(),
          imageUrl: profileData.image,
        ),
      );
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onLogoutProfile(
    LogoutProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await _authRepository.logout();
      emit(ProfileLogoutSuccess());
    } catch (e) {
      emit(ProfileError(message: "Gagal logout"));
    }
  }
}
