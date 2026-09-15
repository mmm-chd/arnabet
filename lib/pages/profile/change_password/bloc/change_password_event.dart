part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();
  @override
  List<Object> get props => [];
}

class ChangePasswordSendOtp extends ChangePasswordEvent {}

class ChangePasswordCurrentPasswordChanged extends ChangePasswordEvent {
  final String password;
  const ChangePasswordCurrentPasswordChanged({required this.password});
  @override
  List<Object> get props => [password];
}

class ChangePasswordCodeChanged extends ChangePasswordEvent {
  final String code;
  const ChangePasswordCodeChanged({required this.code});
  @override
  List<Object> get props => [code];
}

class ChangePasswordVerifyCode extends ChangePasswordEvent {
  final String code;
  const ChangePasswordVerifyCode({required this.code});
  @override
  List<Object> get props => [code];
}

class ChangePasswordResendCode extends ChangePasswordEvent {}

class ChangePasswordNewPasswordChanged extends ChangePasswordEvent {
  final String password;
  const ChangePasswordNewPasswordChanged({required this.password});
  @override
  List<Object> get props => [password];
}

class ChangePasswordConfirmPasswordChanged extends ChangePasswordEvent {
  final String password;
  const ChangePasswordConfirmPasswordChanged({required this.password});
  @override
  List<Object> get props => [password];
}

class ChangePasswordReset extends ChangePasswordEvent {
  final String newPassword;
  final String confirmPassword;
  final String code;
  const ChangePasswordReset({
    required this.newPassword,
    required this.confirmPassword,
    required this.code,
  });
  @override
  List<Object> get props => [newPassword, confirmPassword, code];
}

class ChangePasswordStepBack extends ChangePasswordEvent {}

class ChangePasswordTogglePasswordVisibility extends ChangePasswordEvent {}

class ChangePasswordValidate extends ChangePasswordEvent {
  final String? currentPassword;
  final String? code;
  final String? newPassword;
  final String? confirmPassword;

  const ChangePasswordValidate({
    this.currentPassword,
    this.code,
    this.newPassword,
    this.confirmPassword,
  });

  @override
  List<Object> get props => [
    currentPassword ?? '',
    code ?? '',
    newPassword ?? '',
    confirmPassword ?? '',
  ];
}