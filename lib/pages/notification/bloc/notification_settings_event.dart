sealed class NotificationSettingsEvent {}

class LoadNotificationSettings extends NotificationSettingsEvent {}

class ClearNotificationSettingsError extends NotificationSettingsEvent {}

class ToggleMasterInApp extends NotificationSettingsEvent {
  final bool value;

  ToggleMasterInApp(this.value);
}

class ToggleMasterEmail extends NotificationSettingsEvent {
  final bool value;

  ToggleMasterEmail(this.value);
}

class ToggleSettingInApp extends NotificationSettingsEvent {
  final String type;
  final bool value;

  ToggleSettingInApp({required this.type, required this.value});
}

class ToggleSettingEmail extends NotificationSettingsEvent {
  final String type;
  final bool value;

  ToggleSettingEmail({required this.type, required this.value});
}

class SaveNotificationSettings extends NotificationSettingsEvent {}