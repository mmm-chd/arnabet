import 'package:arena/models/enums/enums.dart';
import 'package:arena/pages/add_user/bloc/add_user_event.dart';
import 'package:arena/pages/add_user/bloc/add_user_state.dart';
import 'package:arena/repositories/user/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddUserBloc extends Bloc<AddUserEvent, AddUserState> {
  final UserRepository _repository;

  AddUserBloc({required UserRepository repository})
    : _repository = repository,
      super(const AddUserState()) {
    on<AddUserValidate>(_onValidate);
    on<SubmitInviteUser>(_onSubmitInviteUser);
    on<ResendInviteUser>(_onResendInviteUser);
  }

  String? _validateEmail(String email) {
    final trimmed = email.trim();

    if (trimmed.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    if (trimmed.length > 254) {
      return 'Email terlalu panjang';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  void _onValidate(AddUserValidate event, Emitter<AddUserState> emit) {
    final emailError = _validateEmail(event.email);
    emit(state.copyWith(emailError: emailError));
  }

  void _onSubmitInviteUser(
    SubmitInviteUser event,
    Emitter<AddUserState> emit,
  ) async {
    final emailError = _validateEmail(event.email);
    if (emailError != null) {
      emit(
        state.copyWith(
          status: PageStatus.failure,
          message: "Validasi gagal",
          emailError: emailError,
        ),
      );
      return;
    }

    emit(state.copyWith(status: PageStatus.loading));
    try {
      final result = await _repository.invite(event.email, event.role);

      if (result.success!) {
        emit(
          state.copyWith(
            status: PageStatus.success,
            message: result.message ?? "User berhasil ditambahkan",
            emailError: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: PageStatus.failure,
            message: result.message ?? "Gagal menambahkan user",
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: PageStatus.failure, message: e.toString()));
    }
  }

  void _onResendInviteUser(
    ResendInviteUser event,
    Emitter<AddUserState> emit,
  ) async {
    final emailError = _validateEmail(event.email);
    if (emailError != null) {
      emit(
        state.copyWith(
          status: PageStatus.failure,
          message: "Validasi gagal",
          emailError: emailError,
        ),
      );
      return;
    }

    emit(state.copyWith(status: PageStatus.loading));
    try {
      final result = await _repository.invite(event.email, event.role);

      if (result.success!) {
        emit(
          state.copyWith(
            status: PageStatus.success,
            message: result.message ?? "Email berhasil dikirim ulang",
            emailError: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: PageStatus.failure,
            message: result.message ?? "Gagal mengirim ulang email",
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: PageStatus.failure, message: e.toString()));
    }
  }
}
