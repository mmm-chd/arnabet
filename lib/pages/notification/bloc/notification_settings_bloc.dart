import 'dart:async';

import 'package:arena/models/notification/notification_settings_model.dart';
import 'package:arena/repositories/notification/notification_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_settings_event.dart';
import 'notification_settings_state.dart';

class NotificationSettingsBloc
    extends Bloc<NotificationSettingsEvent, NotificationSettingsState> {
  final NotificationRepository _repository;

  static const _saveDebounce = Duration(milliseconds: 800);

  Timer? _saveDebounceTimer;
  bool _isSaving = false;
  bool _pendingSave = false;
  NotificationSettingsData? _lastSaved;

  NotificationSettingsBloc({required NotificationRepository repository})
    : _repository = repository,
      super(const NotificationSettingsState()) {
    on<LoadNotificationSettings>(_onLoad);
    on<ToggleMasterInApp>(_onToggleMasterInApp);
    on<ToggleMasterEmail>(_onToggleMasterEmail);
    on<ToggleSettingInApp>(_onToggleSettingInApp);
    on<ToggleSettingEmail>(_onToggleSettingEmail);
    on<SaveNotificationSettings>(_onSave);
    on<ClearNotificationSettingsError>(_onClearError);
  }

  Future<void> _onLoad(
    LoadNotificationSettings event,
    Emitter<NotificationSettingsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: NotificationSettingsStatus.loading,
        errorMessage: null,
      ),
    );
    try {
      final response = await _repository.getNotificationSettings();
      final data = response.data;
      if (data == null) {
        throw Exception('Gagal mengambil pengaturan notifikasi');
      }
      _lastSaved = data;
      emit(
        state.copyWith(
          status: NotificationSettingsStatus.ready,
          masterInApp: data.masterInApp ?? true,
          masterEmail: data.masterEmail ?? true,
          settings: List.unmodifiable(data.settings ?? const []),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NotificationSettingsStatus.failure,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  void _onToggleMasterInApp(
    ToggleMasterInApp event,
    Emitter<NotificationSettingsState> emit,
  ) {
    emit(
      state.copyWith(
        masterInApp: event.value,
        settings: state.settings
            .map((s) => s.copyWith(enabledInApp: event.value))
            .toList(),
      ),
    );
    _scheduleSave();
  }

  void _onToggleMasterEmail(
    ToggleMasterEmail event,
    Emitter<NotificationSettingsState> emit,
  ) {
    emit(
      state.copyWith(
        masterEmail: event.value,
        settings: state.settings
            .map((s) => s.copyWith(enabledEmail: event.value))
            .toList(),
      ),
    );
    _scheduleSave();
  }

  void _onToggleSettingInApp(
    ToggleSettingInApp event,
    Emitter<NotificationSettingsState> emit,
  ) {
    emit(
      state.copyWith(
        settings: state.settings
            .map((s) => s.type == event.type
                ? s.copyWith(enabledInApp: event.value)
                : s)
            .toList(),
      ),
    );
    _scheduleSave();
  }

  void _onToggleSettingEmail(
    ToggleSettingEmail event,
    Emitter<NotificationSettingsState> emit,
  ) {
    emit(
      state.copyWith(
        settings: state.settings
            .map((s) => s.type == event.type
                ? s.copyWith(enabledEmail: event.value)
                : s)
            .toList(),
      ),
    );
    _scheduleSave();
  }

  void _scheduleSave() {
    _saveDebounceTimer?.cancel();
    _saveDebounceTimer = Timer(_saveDebounce, () {
      add(SaveNotificationSettings());
    });
  }

  Future<void> _onSave(
    SaveNotificationSettings event,
    Emitter<NotificationSettingsState> emit,
  ) async {
    if (_isSaving) {
      _pendingSave = true;
      return;
    }
    _isSaving = true;
    emit(state.copyWith(isSaving: true));
    try {
      final data = NotificationSettingsData(
        masterInApp: state.masterInApp,
        masterEmail: state.masterEmail,
        settings: state.settings,
      );
      final response = await _repository.updateNotificationSettings(
        masterInApp: state.masterInApp,
        masterEmail: state.masterEmail,
        settings: state.settings,
      );
      final saved = response.data;
      if (saved != null) {
        _lastSaved = saved;
        emit(
          state.copyWith(
            isSaving: false,
            masterInApp: saved.masterInApp ?? state.masterInApp,
            masterEmail: saved.masterEmail ?? state.masterEmail,
            settings: List.unmodifiable(saved.settings ?? state.settings),
          ),
        );
      } else {
        _lastSaved = data;
        emit(state.copyWith(isSaving: false));
      }
    } catch (e) {
      _rollback(emit, e);
    } finally {
      _isSaving = false;
      if (_pendingSave) {
        _pendingSave = false;
        add(SaveNotificationSettings());
      }
    }
  }

  void _rollback(Emitter<NotificationSettingsState> emit, dynamic e) {
    final saved = _lastSaved;
    emit(
      state.copyWith(
        isSaving: false,
        masterInApp: saved?.masterInApp ?? state.masterInApp,
        masterEmail: saved?.masterEmail ?? state.masterEmail,
        settings: saved?.settings ?? state.settings,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ),
    );
  }

  void _onClearError(
    ClearNotificationSettingsError event,
    Emitter<NotificationSettingsState> emit,
  ) {
    emit(state.copyWith(errorMessage: null));
  }

  @override
  Future<void> close() {
    _saveDebounceTimer?.cancel();
    return super.close();
  }
}