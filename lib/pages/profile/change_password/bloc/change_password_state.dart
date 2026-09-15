part of 'change_password_bloc.dart';

enum ChangePasswordStep { request, otp, reset }

class ChangePasswordState extends Equatable {
  final ChangePasswordStep step;
  final String email;
  final String currentPassword;
  final String code;
  final String newPassword;
  final String confirmPassword;
  final bool isLoading;
  final bool isCodeSent;
  final bool isSuccess;
  final bool isPasswordVisible;
  final String? errorMessage;
  final String? currentPasswordError;
  final String? codeError;
  final String? passwordError;
  final String? confirmPasswordError;

  const ChangePasswordState({
    required this.step,
    required this.email,
    this.currentPassword = '',
    this.code = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.isCodeSent = false,
    this.isSuccess = false,
    this.isPasswordVisible = false,
    this.errorMessage,
    this.currentPasswordError,
    this.codeError,
    this.passwordError,
    this.confirmPasswordError,
  });

  ChangePasswordState copyWith({
    ChangePasswordStep? step,
    String? email,
    String? currentPassword,
    String? code,
    String? newPassword,
    String? confirmPassword,
    bool? isLoading,
    bool? isCodeSent,
    bool? isSuccess,
    bool? isPasswordVisible,
    Object? errorMessage = _sentinel,
    Object? currentPasswordError = _sentinel,
    Object? codeError = _sentinel,
    Object? passwordError = _sentinel,
    Object? confirmPasswordError = _sentinel,
  }) {
    return ChangePasswordState(
      step: step ?? this.step,
      email: email ?? this.email,
      currentPassword: currentPassword ?? this.currentPassword,
      code: code ?? this.code,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      isCodeSent: isCodeSent ?? this.isCodeSent,
      isSuccess: isSuccess ?? this.isSuccess,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      errorMessage:
          errorMessage == _sentinel ? this.errorMessage : errorMessage as String?,
      currentPasswordError:
          currentPasswordError == _sentinel
              ? this.currentPasswordError
              : currentPasswordError as String?,
      codeError:
          codeError == _sentinel ? this.codeError : codeError as String?,
      passwordError:
          passwordError == _sentinel
              ? this.passwordError
              : passwordError as String?,
      confirmPasswordError:
          confirmPasswordError == _sentinel
              ? this.confirmPasswordError
              : confirmPasswordError as String?,
    );
  }

  @override
  List<Object?> get props => [
    step,
    email,
    currentPassword,
    code,
    newPassword,
    confirmPassword,
    isLoading,
    isCodeSent,
    isSuccess,
    isPasswordVisible,
    errorMessage,
    currentPasswordError,
    codeError,
    passwordError,
    confirmPasswordError,
  ];
}

const Object _sentinel = Object();