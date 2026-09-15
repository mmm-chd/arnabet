import 'package:arena/repositories/auth/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final AuthRepository _repository;

  EditProfileBloc({required AuthRepository repository, required String name})
    : _repository = repository,
      super(EditProfileState(name: name)) {
    on<EditProfileNameChanged>(_onNameChanged);
    on<EditProfileSubmitted>(_onSubmitted);
  }

  void _onNameChanged(
    EditProfileNameChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(state.copyWith(name: event.name, nameError: null, errorMessage: null));
  }

  Future<void> _onSubmitted(
    EditProfileSubmitted event,
    Emitter<EditProfileState> emit,
  ) async {
    final name = state.name.trim();
    if (name.isEmpty) {
      emit(state.copyWith(nameError: 'Nama tidak boleh kosong'));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null, nameError: null));
    try {
      final result = await _repository.updateProfile(name);
      if (result.success == false) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.message ?? 'Gagal memperbarui profile',
          ),
        );
        return;
      }
      emit(
        state.copyWith(isLoading: false, isSuccess: true, errorMessage: null),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e is Exception
              ? e.toString().replaceAll('Exception: ', '')
              : 'Gagal memperbarui profile',
        ),
      );
    }
  }
}
