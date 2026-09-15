import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterInviteTokenChanged extends RegisterEvent {
  final String inviteToken;
  const RegisterInviteTokenChanged({required this.inviteToken});

  @override
  List<Object> get props => [inviteToken];
}

class RegisterNameChanged extends RegisterEvent {
  final String name;
  const RegisterNameChanged({required this.name});

  @override
  List<Object> get props => [name];
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;
  const RegisterPasswordChanged({required this.password});

  @override
  List<Object> get props => [password];
}

class RegisterConfirmPasswordChanged extends RegisterEvent {
  final String confirmPassword;
  const RegisterConfirmPasswordChanged({required this.confirmPassword});

  @override
  List<Object> get props => [confirmPassword];
}

class TogglePasswordVisibility extends RegisterEvent {
  const TogglePasswordVisibility();
}

class ToggleConfirmPasswordVisibility extends RegisterEvent {
  const ToggleConfirmPasswordVisibility();
}

class RegisterValidate extends RegisterEvent {
  final String? inviteToken;
  final String? name;
  final String? password;
  final String? confirmPassword;

  const RegisterValidate({
    this.inviteToken,
    this.name,
    this.password,
    this.confirmPassword,
  });

  @override
  List<Object> get props => [
    password ?? '',
    name ?? '',
    confirmPassword ?? '',
  ];
}

class SubmitRegister extends RegisterEvent {
  final String name;
  final String password;

  const SubmitRegister({
    required this.name,
    required this.password,
  });

  @override
  List<Object> get props => [name, password];
}

class RegisterClearForm extends RegisterEvent {
  const RegisterClearForm();

  @override
  List<Object> get props => [];
}

class RegisterClearError extends RegisterEvent {
  const RegisterClearError();

  @override
  List<Object> get props => [];
}
