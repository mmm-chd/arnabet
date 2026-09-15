import 'package:arena/models/enums/role.dart';
import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoaded extends SplashState {
  final Role role;

  const SplashLoaded({required this.role});

  @override
  List<Object> get props => [role];
}

class SplashFailure extends SplashState {
  final String message;
  const SplashFailure(this.message);

  @override
  List<Object> get props => [message];
}
