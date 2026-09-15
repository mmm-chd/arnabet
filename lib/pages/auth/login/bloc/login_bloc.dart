import 'dart:async';

import 'package:arena/helper/login_error_mapper.dart';
import 'package:arena/models/enums/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:arena/repositories/auth/auth_repository.dart';
import 'package:arena/models/enums/role.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  String _email = '';
  String _password = '';

  LoginBloc({required this.authRepository}) : super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<TogglePasswordVisibility>(_onTogglePassword);
    on<LoginValidate>(_onValidate);
    on<LoginClearError>(_onClearError);
    on<LoginReset>(_onReset);
  }

  String? _validateEmail(String email) {
    final trimmed = email.trim();

    if (trimmed.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    if (trimmed.length > 254) {
      return 'Email terlalu panjang';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (password.length < 6) {
      return 'Password minimal 6 karakter';
    }

    if (password.length > 128) {
      return 'Password terlalu panjang';
    }

    if (password.contains(' ')) {
      return 'Password tidak boleh mengandung spasi';
    }

    return null;
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    _email = event.email.trim();

    emit(state.copyWith(status: PageStatus.initial, emailError: null));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    _password = event.password;

    emit(state.copyWith(status: PageStatus.initial, passwordError: null));
  }

  void _onTogglePassword(
    TogglePasswordVisibility event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void _onValidate(LoginValidate event, Emitter<LoginState> emit) {
    String? emailError = state.emailError;
    String? passwordError = state.passwordError;

    if (event.email != null) {
      emailError = _validateEmail(event.email!);
    }
    if (event.password != null) {
      passwordError = _validatePassword(event.password!);
    }

    emit(state.copyWith(emailError: emailError, passwordError: passwordError));
  }

  void _onClearError(LoginClearError event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        emailError: event.clearEmail ? null : state.emailError,
        passwordError: event.clearPassword ? null : state.passwordError,
      ),
    );
  }

  void _onReset(LoginReset event, Emitter<LoginState> emit) {
    _email = '';
    _password = '';
    emit(
      state.copyWith(
        emailError: null,
        passwordError: null,
        isPasswordVisible: false,
        status: PageStatus.initial,
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final emailError = _validateEmail(_email);
    final passwordError = _validatePassword(_password);

    if (emailError != null || passwordError != null) {
      emit(
        state.copyWith(emailError: emailError, passwordError: passwordError),
      );
      return;
    }

    emit(state.copyWith(status: PageStatus.loading));

    try {
      final result = await authRepository.login(_email.trim(), _password);
      final userRole = Role.fromString(result.data!.user!.role);

      emit(
        state.copyWith(
          status: PageStatus.success,
          message: 'Login berhasil, selamat datang ${result.data!.user!.name}',
          role: userRole,
        ),
      );
    } catch (e) {
      final errorMsg = LoginErrorMapper.map(e);
      emit(
        state.copyWith(
          status: PageStatus.failure,
          message: errorMsg,
          isPasswordVisible: state.isPasswordVisible,
          emailError: "",
          passwordError: errorMsg,
        ),
      );
    }
  }
}
