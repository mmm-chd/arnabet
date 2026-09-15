import 'package:arena/models/notification/notification_list_model.dart';
import 'package:arena/models/notification/notification_settings_model.dart';
import 'package:arena/models/notification/notification_sse_model.dart';
import 'package:arena/services/notification/notification_list_service.dart';
import 'package:arena/services/notification/notification_settings_service.dart';
import 'package:arena/services/notification/notification_sse_service.dart';

class NotificationRepository {
  final NotificationSseService _sseService;
  final NotificationListService _listService;
  final NotificationSettingsService _settingsService;

  NotificationRepository({
    NotificationSseService? sseService,
    NotificationListService? listService,
    NotificationSettingsService? settingsService,
  }) : _sseService = sseService ?? NotificationSseService(),
       _listService = listService ?? NotificationListService(),
       _settingsService = settingsService ?? NotificationSettingsService();

  Stream<NotificationSSEModel> unreadCount() {
    return _sseService.unreadCount();
  }

  Future<NotificationListModel> getNotifications({
    String unreadOnly = 'true',
    int page = 1,
    int limit = 10,
  }) {
    return _listService.getNotifications(
      unreadOnly: unreadOnly,
      page: page,
      limit: limit,
    );
  }

  Future<NotificationSettingsModel> getNotificationSettings() {
    return _settingsService.getSettings();
  }

  Future<NotificationSettingsModel> updateNotificationSettings({
    required bool masterInApp,
    required bool masterEmail,
    required List<NotificationSettingItem> settings,
  }) {
    return _settingsService.updateSettings(
      masterInApp: masterInApp,
      masterEmail: masterEmail,
      settings: settings,
    );
  }
}
