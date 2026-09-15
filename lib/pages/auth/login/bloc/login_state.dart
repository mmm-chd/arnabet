part of 'login_bloc.dart';

class LoginState extends Equatable {
  final PageStatus status;
  final String? emailError;
  final String? passwordError;
  final String? message;
  final Role? role;
  final bool isPasswordVisible;

  const LoginState({
    this.status = PageStatus.initial,
    this.emailError,
    this.passwordError,
    this.message,
    this.role,
    this.isPasswordVisible = false,
  });

  bool get isLoading => status == PageStatus.loading;
  bool get isSuccess => status == PageStatus.success;
  bool get isFailure => status == PageStatus.failure;

  bool get isValid => emailError == null && passwordError == null;

  String get error => message ?? '';

  LoginState copyWith({
    PageStatus? status,
    Object? emailError = _sentinel,
    Object? passwordError = _sentinel,
    Object? message = _sentinel,
    Object? role = _sentinel,
    bool? isPasswordVisible,
  }) {
    return LoginState(
      status: status ?? this.status,
      emailError: identical(emailError, _sentinel)
          ? this.emailError
          : emailError as String?,
      passwordError: identical(passwordError, _sentinel)
          ? this.passwordError
          : passwordError as String?,
      message: identical(message, _sentinel) ? this.message : message as String?,
      role: identical(role, _sentinel) ? this.role : role as Role?,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }

  @override
  List<Object?> get props => [
    status,
    emailError,
    passwordError,
    message,
    role,
    isPasswordVisible,
  ];
}

const Object _sentinel = Object();