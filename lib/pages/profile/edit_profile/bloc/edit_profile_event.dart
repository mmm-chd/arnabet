part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

class EditProfileNameChanged extends EditProfileEvent {
  final String name;
  const EditProfileNameChanged({required this.name});

  @override
  List<Object> get props => [name];
}

class EditProfileSubmitted extends EditProfileEvent {}
