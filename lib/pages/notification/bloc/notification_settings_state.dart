import 'package:arena/models/notification/notification_settings_model.dart';
import 'package:equatable/equatable.dart';

enum NotificationSettingsStatus {
  initial,
  loading,
  ready,
  failure,
}

class NotificationSettingsState extends Equatable {
  final NotificationSettingsStatus status;
  final bool masterInApp;
  final bool masterEmail;
  final List<NotificationSettingItem> settings;
  final bool isSaving;
  final String? errorMessage;

  const NotificationSettingsState({
    this.status = NotificationSettingsStatus.initial,
    this.masterInApp = true,
    this.masterEmail = true,
    this.settings = const [],
    this.isSaving = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    status,
    masterInApp,
    masterEmail,
    settings,
    isSaving,
    errorMessage,
  ];

  NotificationSettingsState copyWith({
    NotificationSettingsStatus? status,
    bool? masterInApp,
    bool? masterEmail,
    List<NotificationSettingItem>? settings,
    bool? isSaving,
    Object? errorMessage = _sentinel,
  }) {
    return NotificationSettingsState(
      status: status ?? this.status,
      masterInApp: masterInApp ?? this.masterInApp,
      masterEmail: masterEmail ?? this.masterEmail,
      settings: settings ?? this.settings,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  bool get isInitial => status == NotificationSettingsStatus.initial;
  bool get isLoading => status == NotificationSettingsStatus.loading;
  bool get isReady => status == NotificationSettingsStatus.ready;
  bool get isFailure => status == NotificationSettingsStatus.failure;
}

const _sentinel = Object();