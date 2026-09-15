import 'package:equatable/equatable.dart';

abstract class AddUserEvent extends Equatable {
  const AddUserEvent();

  @override
  List<Object?> get props => [];
}

class SubmitInviteUser extends AddUserEvent {
  final String email;
  final String role;

  const SubmitInviteUser({required this.email, required this.role});

  @override
  List<Object?> get props => [email, role];
}

class ResendInviteUser extends AddUserEvent {
  final String email;
  final String role;

  const ResendInviteUser({required this.email, required this.role});

  @override
  List<Object?> get props => [email, role];
}

class AddUserValidate extends AddUserEvent {
  final String email;

  const AddUserValidate({required this.email});

  @override
  List<Object?> get props => [email];
}
