import 'package:arena/models/enums/enums.dart';
import 'package:arena/repositories/auth/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;
  String _inviteToken = '';
  String _name = '';
  String _password = '';
  String _confirmPassword = '';

  RegisterBloc({required this.authRepository}) : super(const RegisterState()) {
    on<RegisterInviteTokenChanged>(_onInviteTokenChanged);
    on<RegisterNameChanged>(_onNameChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<TogglePasswordVisibility>(_onTogglePassword);
    on<ToggleConfirmPasswordVisibility>(_onToggleConfirmPassword);
    on<RegisterValidate>(_onValidate);
    on<RegisterClearError>(_onClearError);
    on<SubmitRegister>(_onSubmitted);
    on<RegisterClearForm>(_onClearForm);
  }

  void _onClearForm(RegisterClearForm event, Emitter<RegisterState> emit) {
    _inviteToken = '';
    _name = '';
    _password = '';
    _confirmPassword = '';
    emit(
      const RegisterState(
        status: PageStatus.initial,
        isPasswordVisible: false,
        isConfirmPasswordVisible: false,
        inviteTokenError: null,
        nameError: null,
        passwordError: null,
        confirmPasswordError: null,
      ),
    );
  }

  String? _validateInviteToken(String inviteToken) {
    final trimmed = inviteToken.trim();
    if (trimmed.isEmpty) {
      return 'Kode undangan tidak boleh kosong';
    }
    if (trimmed.length != 6) {
      return 'Kode undangan berisi 6 karakter';
    }
    return null;
  }

  String? _validateName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (trimmed.length < 2) {
      return 'Nama minimal 2 karakter';
    }
    return null;
  }

String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (password.length < 6) {
      return 'Password minimal 6 karakter';
    }
    if (password.length > 128) {
      return 'Password terlalu panjang';
    }
    if (password.contains(' ')) {
      return 'Password tidak boleh mengandung spasi';
    }
    return null;
  }

  String? _validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (confirmPassword != password) {
      return 'Password tidak sama';
    }
    return null;
  }

  void _onInviteTokenChanged(
    RegisterInviteTokenChanged event,
    Emitter<RegisterState> emit,
  ) {
    _inviteToken = event.inviteToken;
    emit(state.copyWith(status: PageStatus.initial, inviteTokenError: null));
  }

  void _onNameChanged(RegisterNameChanged event, Emitter<RegisterState> emit) {
    _name = event.name;
    emit(state.copyWith(status: PageStatus.initial, nameError: null));
  }

  void _onPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    _password = event.password;
    emit(state.copyWith(status: PageStatus.initial, passwordError: null));
  }

  void _onTogglePassword(
    TogglePasswordVisibility event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void _onToggleConfirmPassword(
    ToggleConfirmPasswordVisibility event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible),
    );
  }

  void _onConfirmPasswordChanged(
    RegisterConfirmPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    _confirmPassword = event.confirmPassword;
    emit(
      state.copyWith(status: PageStatus.initial, confirmPasswordError: null),
    );
  }

  void _onValidate(RegisterValidate event, Emitter<RegisterState> emit) {
    emit(
      state.copyWith(
        inviteTokenError: event.inviteToken != null
            ? _validateInviteToken(event.inviteToken!)
            : state.inviteTokenError,
        nameError: event.name != null
            ? _validateName(event.name!)
            : state.nameError,
        passwordError: event.password != null
            ? _validatePassword(event.password!)
            : state.passwordError,
        confirmPasswordError: event.confirmPassword != null
            ? _validateConfirmPassword(_password, event.confirmPassword!)
            : state.confirmPasswordError,
      ),
    );
  }

  void _onClearError(RegisterClearError event, Emitter<RegisterState> emit) {
    emit(
      state.copyWith(
        status: PageStatus.initial,
        nameError: null,
        passwordError: null,
        inviteTokenError: null,
      ),
    );
  }

  Future<void> _onSubmitted(
    SubmitRegister event,
    Emitter<RegisterState> emit,
  ) async {
    final nameError = _validateName(event.name);
    final inviteTokenError = _validateInviteToken(_inviteToken);
    final passwordError = _validatePassword(event.password);

    if (nameError != null ||
        inviteTokenError != null ||
        passwordError != null) {
      emit(
        state.copyWith(
          nameError: nameError,
          inviteTokenError: inviteTokenError,
          passwordError: passwordError,
        ),
      );
      return;
    }

    emit(state.copyWith(status: PageStatus.loading));
    try {
      final result = await authRepository.register(
        _inviteToken,
        event.name,
        event.password,
      );
      final email = result.data!.email;
      emit(
        state.copyWith(
          status: PageStatus.success,
          message: 'Registrasi berhasil',
          email: email,
        ),
      );
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      emit(state.copyWith(status: PageStatus.failure, message: errorMsg));
    }
  }
}
