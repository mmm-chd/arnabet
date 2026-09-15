part of 'edit_profile_bloc.dart';

class EditProfileState extends Equatable {
  final String name;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String? nameError;

  const EditProfileState({
    required this.name,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.nameError,
  });

  EditProfileState copyWith({
    String? name,
    bool? isLoading,
    bool? isSuccess,
    Object? errorMessage = _sentinel,
    Object? nameError = _sentinel,
  }) {
    return EditProfileState(
      name: name ?? this.name,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage:
          errorMessage == _sentinel ? this.errorMessage : errorMessage as String?,
      nameError: nameError == _sentinel ? this.nameError : nameError as String?,
    );
  }

  @override
  List<Object?> get props => [name, isLoading, isSuccess, errorMessage, nameError];
}

const Object _sentinel = Object();
