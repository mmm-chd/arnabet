class NotificationSSEModel {
  final int unreadCount;
  final String? type;
  final String? title;
  final String? body;

  NotificationSSEModel({
    required this.unreadCount,
    this.type,
    this.title,
    this.body,
  });

  factory NotificationSSEModel.fromJson(Map<String, dynamic> json) {
    return NotificationSSEModel(
      unreadCount: json["unread_count"] as int? ?? 0,
      type: json["type"] as String?,
      title: json["title"] as String?,
      body: json["body"] as String? ?? json["message"] as String?,
    );
  }
}
