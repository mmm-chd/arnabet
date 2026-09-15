import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String email;
  final String role;
  final String? imageUrl;

  const ProfileLoaded({
    required this.name,
    required this.email,
    required this.role,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [name, email, role, imageUrl];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProfileLogoutSuccess extends ProfileState {}
