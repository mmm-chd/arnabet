import 'package:arena/repositories/auth/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final AuthRepository _repository;

  ChangePasswordBloc({required AuthRepository repository, required String email})
    : _repository = repository,
      super(
        ChangePasswordState(step: ChangePasswordStep.request, email: email),
      ) {
    on<ChangePasswordSendOtp>(_onSendOtp);
    on<ChangePasswordCurrentPasswordChanged>(_onCurrentPasswordChanged);
    on<ChangePasswordCodeChanged>(_onCodeChanged);
    on<ChangePasswordVerifyCode>(_onVerifyCode);
    on<ChangePasswordResendCode>(_onResendCode);
    on<ChangePasswordNewPasswordChanged>(_onNewPasswordChanged);
    on<ChangePasswordConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<ChangePasswordReset>(_onReset);
    on<ChangePasswordStepBack>(_onStepBack);
    on<ChangePasswordTogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<ChangePasswordValidate>(_onValidate);
  }

  void _onCodeChanged(
    ChangePasswordCodeChanged event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(
      state.copyWith(code: event.code, codeError: null, errorMessage: null),
    );
  }

  void _onCurrentPasswordChanged(
    ChangePasswordCurrentPasswordChanged event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(
      state.copyWith(
        currentPassword: event.password,
        currentPasswordError: null,
        errorMessage: null,
      ),
    );
  }

  void _onValidate(
    ChangePasswordValidate event,
    Emitter<ChangePasswordState> emit,
  ) {
    if (event.currentPassword != null) {
      if (event.currentPassword!.isEmpty) {
        emit(state.copyWith(currentPasswordError: 'Password tidak boleh kosong'));
      } else {
        emit(state.copyWith(currentPasswordError: null));
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
    ChangePasswordTogglePasswordVisibility event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> _onSendOtp(
    ChangePasswordSendOtp event,
    Emitter<ChangePasswordState> emit,
  ) async {
    if (state.currentPassword.isEmpty) {
      emit(state.copyWith(currentPasswordError: 'Password tidak boleh kosong'));
      return;
    }
    if (state.email.isEmpty) {
      emit(state.copyWith(errorMessage: 'Email tidak tersedia'));
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        currentPasswordError: null,
      ),
    );
    try {
      await _repository.verifyPassword(
        email: state.email,
        password: state.currentPassword,
      );
      final result = await _repository.requestReset(email: state.email);
      if (result.success == false) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.message ?? 'Gagal mengirim kode',
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          step: ChangePasswordStep.otp,
          isLoading: false,
          isCodeSent: true,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          currentPasswordError:
              e is Exception &&
                  e.toString().contains('Password saat ini salah')
              ? 'Password saat ini salah'
              : null,
          errorMessage: e is Exception
              ? e.toString().replaceAll('Exception: ', '')
              : 'Gagal mengirim kode. Coba lagi.',
        ),
      );
    }
  }

  Future<void> _onVerifyCode(
    ChangePasswordVerifyCode event,
    Emitter<ChangePasswordState> emit,
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
          step: ChangePasswordStep.reset,
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
    ChangePasswordResendCode event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final result = await _repository.requestReset(email: state.email);
      if (result.success == false) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.message ?? 'Gagal mengirim ulang kode',
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          isLoading: false,
          isCodeSent: true,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e is Exception
              ? e.toString().replaceAll('Exception: ', '')
              : 'Gagal mengirim ulang kode',
        ),
      );
    }
  }

  void _onNewPasswordChanged(
    ChangePasswordNewPasswordChanged event,
    Emitter<ChangePasswordState> emit,
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
    ChangePasswordConfirmPasswordChanged event,
    Emitter<ChangePasswordState> emit,
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
    ChangePasswordReset event,
    Emitter<ChangePasswordState> emit,
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
            errorMessage: result.message ?? 'Gagal mengganti password',
          ),
        );
        return;
      }

      emit(
        state.copyWith(isLoading: false, isSuccess: true, errorMessage: null),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e is Exception
              ? e.toString().replaceAll('Exception: ', '')
              : 'Gagal mengganti password',
        ),
      );
    }
  }

  void _onStepBack(
    ChangePasswordStepBack event,
    Emitter<ChangePasswordState> emit,
  ) {
    switch (state.step) {
      case ChangePasswordStep.otp:
        emit(
          state.copyWith(
            step: ChangePasswordStep.request,
            code: '',
            isCodeSent: false,
            codeError: null,
            errorMessage: null,
          ),
        );
        break;
      case ChangePasswordStep.reset:
        emit(
          state.copyWith(
            step: ChangePasswordStep.otp,
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