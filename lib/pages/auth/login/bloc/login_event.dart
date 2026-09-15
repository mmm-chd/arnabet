part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  final String email;
  const LoginEmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;
  const LoginPasswordChanged({required this.password});

  @override
  List<Object> get props => [password];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();

  @override
  List<Object> get props => [];
}

class TogglePasswordVisibility extends LoginEvent {}

class LoginValidate extends LoginEvent {
  final String? email;
  final String? password;
  const LoginValidate({this.email, this.password});

  @override
  List<Object> get props => [email ?? '', password ?? ''];
}

class LoginClearError extends LoginEvent {
  final bool clearEmail;
  final bool clearPassword;
  const LoginClearError({this.clearEmail = true, this.clearPassword = true});

  @override
  List<Object> get props => [clearEmail, clearPassword];
}

class LoginReset extends LoginEvent {
  const LoginReset();
}
