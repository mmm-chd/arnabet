import 'package:arena/models/notification/notification_item.dart';

sealed class NotificationEvent {}

class ConnectUnreadCount extends NotificationEvent {}

class NotificationUnreadCountChanged extends NotificationEvent {
  final int unreadCount;
  final String? title;
  final String? body;

  NotificationUnreadCountChanged({
    required this.unreadCount,
    this.title,
    this.body,
  });
}

class DisconnectUnreadCount extends NotificationEvent {}

class NotificationReceived extends NotificationEvent {
  final NotificationItem notification;

  NotificationReceived({required this.notification});
}
