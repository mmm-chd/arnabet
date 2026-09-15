part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
  @override
  List<Object> get props => [];
}

class ForgotPasswordEmailChanged extends ForgotPasswordEvent {
  final String email;
  const ForgotPasswordEmailChanged({required this.email});
  @override
  List<Object> get props => [email];
}

class ForgotPasswordSendEmail extends ForgotPasswordEvent {
  final String email;
  const ForgotPasswordSendEmail({required this.email});
  @override
  List<Object> get props => [email];
}

class ForgotPasswordCodeChanged extends ForgotPasswordEvent {
  final String code;
  const ForgotPasswordCodeChanged({required this.code});
  @override
  List<Object> get props => [code];
}

class ForgotPasswordVerifyCode extends ForgotPasswordEvent {
  final String code;
  const ForgotPasswordVerifyCode({required this.code});
  @override
  List<Object> get props => [code];
}

class ForgotPasswordResendCode extends ForgotPasswordEvent {}

class ForgotPasswordNewPasswordChanged extends ForgotPasswordEvent {
  final String password;
  const ForgotPasswordNewPasswordChanged({required this.password});
  @override
  List<Object> get props => [password];
}

class ForgotPasswordConfirmPasswordChanged extends ForgotPasswordEvent {
  final String password;
  const ForgotPasswordConfirmPasswordChanged({required this.password});
  @override
  List<Object> get props => [password];
}

class ForgotPasswordReset extends ForgotPasswordEvent {
  final String newPassword;
  final String confirmPassword;
  final String code;
  const ForgotPasswordReset({
    required this.newPassword,
    required this.confirmPassword,
    required this.code,
  });
  @override
  List<Object> get props => [newPassword, confirmPassword, code];
}

class ForgotPasswordStepBack extends ForgotPasswordEvent {}

class ForgotPasswordTogglePasswordVisibility extends ForgotPasswordEvent {}

class ForgotPasswordValidate extends ForgotPasswordEvent {
  final String? email;
  final String? code;
  final String? newPassword;
  final String? confirmPassword;

  const ForgotPasswordValidate({
    this.email,
    this.code,
    this.newPassword,
    this.confirmPassword,
  });

  @override
  List<Object> get props => [
    email ?? '',
    code ?? '',
    newPassword ?? '',
    confirmPassword ?? '',
  ];
}