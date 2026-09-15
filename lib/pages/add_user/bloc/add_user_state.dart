import 'package:arena/models/enums/enums.dart';
import 'package:equatable/equatable.dart';

class AddUserState extends Equatable {
  final PageStatus status;
  final String? emailError;
  final String? message;

  const AddUserState({
    this.status = PageStatus.initial,
    this.emailError,
    this.message,
  });

  bool get isLoading => status == PageStatus.loading;
  bool get isSuccess => status == PageStatus.success;
  bool get isFailure => status == PageStatus.failure;

  bool get isValid => emailError == null;

  AddUserState copyWith({
    PageStatus? status,
    Object? emailError = _sentinel,
    Object? message = _sentinel,
  }) {
    return AddUserState(
      status: status ?? this.status,
      emailError: identical(emailError, _sentinel)
          ? this.emailError
          : emailError as String?,
      message: identical(message, _sentinel) ? this.message : message as String?,
    );
  }

  @override
  List<Object?> get props => [status, emailError, message];
}

const Object _sentinel = Object();