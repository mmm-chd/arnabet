import 'package:arena/models/enums/enums.dart';
import 'package:equatable/equatable.dart';

class RegisterFormData {
  final String name;
  final String password;

  const RegisterFormData({required this.name, required this.password});
}

class RegisterState extends Equatable {
  final PageStatus status;
  final String? inviteTokenError;
  final String? nameError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? message;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final String email;

  const RegisterState({
    this.status = PageStatus.initial,
    this.inviteTokenError,
    this.nameError,
    this.passwordError,
    this.confirmPasswordError,
    this.message,
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.email = '',
  });

  bool get isLoading => status == PageStatus.loading;
  bool get isSuccess => status == PageStatus.success;
  bool get isFailure => status == PageStatus.failure;

  bool get isValid =>
      nameError == null && passwordError == null && inviteTokenError == null;

  RegisterState copyWith({
    PageStatus? status,
    Object? inviteTokenError = _sentinel,
    Object? nameError = _sentinel,
    Object? passwordError = _sentinel,
    Object? confirmPasswordError = _sentinel,
    Object? message = _sentinel,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    String? email,
  }) {
    return RegisterState(
      status: status ?? this.status,
      inviteTokenError: identical(inviteTokenError, _sentinel)
          ? this.inviteTokenError
          : inviteTokenError as String?,
      nameError: identical(nameError, _sentinel)
          ? this.nameError
          : nameError as String?,
      passwordError: identical(passwordError, _sentinel)
          ? this.passwordError
          : passwordError as String?,
      confirmPasswordError: identical(confirmPasswordError, _sentinel)
          ? this.confirmPasswordError
          : confirmPasswordError as String?,
      message: identical(message, _sentinel)
          ? this.message
          : message as String?,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [
    status,
    inviteTokenError,
    nameError,
    passwordError,
    confirmPasswordError,
    message,
    isPasswordVisible,
    isConfirmPasswordVisible,
    email,
  ];
}

const Object _sentinel = Object();
