import 'package:arena/repositories/auth/auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepository _repository;

  ForgotPasswordBloc({required AuthRepository repository})
    : _repository = repository,
      super(const ForgotPasswordState(step: ForgotPasswordStep.email)) {
    on<ForgotPasswordEmailChanged>(_onEmailChanged);
    on<ForgotPasswordSendEmail>(_onSendEmail);
    on<ForgotPasswordCodeChanged>(_onCodeChanged);
    on<ForgotPasswordVerifyCode>(_onVerifyCode);
    on<ForgotPasswordResendCode>(_onResendCode);
    on<ForgotPasswordNewPasswordChanged>(_onNewPasswordChanged);
    on<ForgotPasswordConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<ForgotPasswordReset>(_onReset);
    on<ForgotPasswordStepBack>(_onStepBack);
    on<ForgotPasswordTogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<ForgotPasswordValidate>(_onValidate);
  }

  void _onEmailChanged(
    ForgotPasswordEmailChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(
      state.copyWith(email: event.email, emailError: null, errorMessage: null),
    );
  }

  void _onValidate(
    ForgotPasswordValidate event,
    Emitter<ForgotPasswordState> emit,
  ) {
    if (event.email != null) {
      if (event.email!.isEmpty) {
        emit(state.copyWith(emailError: 'Email tidak boleh kosong'));
      } else if (!RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      ).hasMatch(event.email!)) {
        emit(state.copyWith(emailError: 'Format email tidak valid'));
      } else {
        emit(state.copyWith(emailError: null));
      }
    }

    if (event.code != null) {
      if (event.code!.isEmpty) {
        emit(state.copyWith(codeError: 'Kode tidak boleh kosong'));
      } else if (event.code!.length < 6) {
        emit(state.copyWith(codeError: 'Kode harus 6 digit'));
      } else {
        emit(state.copyWith(codeError: null));
      }
    }

    if (event.newPassword != null) {
      if (event.newPassword!.isEmpty) {
        emit(state.copyWith(passwordError: 'Password tidak boleh kosong'));
      } else if (event.newPassword!.length < 8) {
        emit(state.copyWith(passwordError: 'Password minimal 8 karakter'));
      } else {
        emit(state.copyWith(passwordError: null));
      }
    }

    if (event.confirmPassword != null) {
      if (event.confirmPassword!.isEmpty) {
        emit(
          state.copyWith(
            confirmPasswordError: 'Konfirmasi password tidak boleh kosong',
          ),
        );
      } else if (event.confirmPassword != state.newPassword) {
        emit(state.copyWith(confirmPasswordError: 'Password tidak cocok'));
      } else {
        emit(state.copyWith(confirmPasswordError: null));
      }
    }
  }

  void _onTogglePasswordVisibility(
    ForgotPasswordTogglePasswordVisibility event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> _onSendEmail(
    ForgotPasswordSendEmail event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (event.email.isEmpty) {
      emit(state.copyWith(emailError: 'Email tidak boleh kosong'));
      return;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(event.email)) {
      emit(state.copyWith(emailError: 'Format email tidak valid'));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null, emailError: null));
    try {
      final result = await _repository.requestReset(email: event.email);
      if (result.success == false) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.message ?? 'Gagal mengirim email',
          ),
        );
        return;
      }
      await Future.delayed(const Duration(seconds: 2));
      emit(
        state.copyWith(
          step: ForgotPasswordStep.verification,
          isLoading: false,
          isCodeSent: true,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal mengirim email. Coba lagi.',
        ),
      );
    }
  }

  void _onCodeChanged(
    ForgotPasswordCodeChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(state.copyWith(code: event.code, codeError: null, errorMessage: null));
  }

  Future<void> _onVerifyCode(
    ForgotPasswordVerifyCode event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (event.code.isEmpty) {
      emit(state.copyWith(codeError: 'Kode tidak boleh kosong'));
      return;
    }
    if (event.code.length < 6) {
      emit(state.copyWith(codeError: 'Kode harus 6 digit'));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null, codeError: null));
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(
        state.copyWith(
          step: ForgotPasswordStep.reset,
          isCodeVerified: true,
          isLoading: false,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Terjadi kesalahan. Coba lagi.',
        ),
      );
    }
  }

  Future<void> _onResendCode(
    ForgotPasswordResendCode event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(
        state.copyWith(isLoading: false, isCodeSent: true, errorMessage: null),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal mengirim ulang kode',
        ),
      );
    }
  }

  void _onNewPasswordChanged(
    ForgotPasswordNewPasswordChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(
      state.copyWith(
        newPassword: event.password,
        passwordError: null,
        errorMessage: null,
      ),
    );
  }

  void _onConfirmPasswordChanged(
    ForgotPasswordConfirmPasswordChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(
      state.copyWith(
        confirmPassword: event.password,
        confirmPasswordError: null,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onReset(
    ForgotPasswordReset event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (event.newPassword.isEmpty) {
      emit(state.copyWith(passwordError: 'Password tidak boleh kosong'));
      return;
    }
    if (event.confirmPassword.isEmpty) {
      emit(
        state.copyWith(
          confirmPasswordError: 'Konfirmasi password tidak boleh kosong',
        ),
      );
      return;
    }
    if (event.newPassword != event.confirmPassword) {
      emit(state.copyWith(confirmPasswordError: 'Password tidak cocok'));
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        passwordError: null,
        confirmPasswordError: null,
      ),
    );
    try {
      final result = await _repository.resetPassword(
        email: state.email,
        password: event.newPassword,
        otp: event.code,
      );

      if (result.success == false) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.message ?? 'Gagal mereset password',
          ),
        );
        return;
      }

      emit(
        state.copyWith(isLoading: false, isSuccess: true, errorMessage: null),
      );
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, errorMessage: 'Gagal reset password'),
      );
    }
  }

  void _onStepBack(
    ForgotPasswordStepBack event,
    Emitter<ForgotPasswordState> emit,
  ) {
    switch (state.step) {
      case ForgotPasswordStep.verification:
        emit(
          state.copyWith(
            step: ForgotPasswordStep.email,
            code: '',
            codeError: null,
            errorMessage: null,
          ),
        );
        break;
      case ForgotPasswordStep.reset:
        emit(
          state.copyWith(
            step: ForgotPasswordStep.verification,
            newPassword: '',
            confirmPassword: '',
            passwordError: null,
            confirmPasswordError: null,
            errorMessage: null,
          ),
        );
        break;
      default:
        break;
    }
  }
}
