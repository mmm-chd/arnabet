part of 'forgot_password_bloc.dart';

enum ForgotPasswordStep { email, verification, reset }

class ForgotPasswordState extends Equatable {
  final ForgotPasswordStep step;
  final String email;
  final String code;
  final String newPassword;
  final String confirmPassword;
  final bool isLoading;
  final String? errorMessage;
  final String? emailError;
  final String? codeError;
  final String? passwordError;
  final String? confirmPasswordError;
  final bool isCodeSent;
  final bool isCodeVerified;
  final bool isSuccess;
  final bool isPasswordVisible;

  const ForgotPasswordState({
    required this.step,
    this.email = '',
    this.code = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.errorMessage,
    this.emailError,
    this.codeError,
    this.passwordError,
    this.confirmPasswordError,
    this.isCodeSent = false,
    this.isCodeVerified = false,
    this.isSuccess = false,
    this.isPasswordVisible = false,
  });

  ForgotPasswordState copyWith({
    ForgotPasswordStep? step,
    String? email,
    String? code,
    String? newPassword,
    String? confirmPassword,
    bool? isLoading,
    Object? errorMessage = _sentinel,
    Object? emailError = _sentinel,
    Object? codeError = _sentinel,
    Object? passwordError = _sentinel,
    Object? confirmPasswordError = _sentinel,
    bool? isCodeSent,
    bool? isCodeVerified,
    bool? isSuccess,
    bool? isPasswordVisible,
  }) {
    return ForgotPasswordState(
      step: step ?? this.step,
      email: email ?? this.email,
      code: code ?? this.code,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage == _sentinel ? this.errorMessage : errorMessage as String?,
      emailError: emailError == _sentinel ? this.emailError : emailError as String?,
      codeError: codeError == _sentinel ? this.codeError : codeError as String?,
      passwordError: passwordError == _sentinel ? this.passwordError : passwordError as String?,
      confirmPasswordError: confirmPasswordError == _sentinel ? this.confirmPasswordError : confirmPasswordError as String?,
      isCodeSent: isCodeSent ?? this.isCodeSent,
      isCodeVerified: isCodeVerified ?? this.isCodeVerified,
      isSuccess: isSuccess ?? this.isSuccess,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }

  @override
  List<Object?> get props => [
    step,
    email,
    code,
    newPassword,
    confirmPassword,
    isLoading,
    errorMessage,
    emailError,
    codeError,
    passwordError,
    confirmPasswordError,
    isCodeSent,
    isCodeVerified,
    isSuccess,
    isPasswordVisible,
  ];
}

const Object _sentinel = Object();