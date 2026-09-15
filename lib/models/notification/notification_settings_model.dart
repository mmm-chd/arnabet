import 'package:arena/helper/safe_helpers.dart';

class NotificationSettingsModel {
  bool? success;
  String? message;
  NotificationSettingsData? data;

  NotificationSettingsModel({this.success, this.message, this.data});

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      NotificationSettingsModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : NotificationSettingsData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class NotificationSettingsData {
  static const Set<String> emailSupportedTypes = {
    'STOCK_ALERT',
    'OLD_DOT_ALERT',
    'USER_SUCCESSFULLY_INVITED',
    'USER_DEACTIVATED',
  };

  bool? masterInApp;
  bool? masterEmail;
  List<NotificationSettingItem>? settings;

  NotificationSettingsData({
    this.masterInApp,
    this.masterEmail,
    this.settings,
  });

  factory NotificationSettingsData.fromJson(Map<String, dynamic> json) =>
      NotificationSettingsData(
        masterInApp: json["master_in_app"],
        masterEmail: json["master_email"],
        settings: json["settings"] == null
            ? []
            : List<NotificationSettingItem>.from(
                json["settings"]!.map((x) => NotificationSettingItem.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "master_in_app": masterInApp,
    "master_email": masterEmail,
    "settings": settings == null
        ? []
        : List<dynamic>.from(settings!.map((x) => x.toJson())),
  };
}

class NotificationSettingItem {
  String? type;
  bool? enabledInApp;
  bool? enabledEmail;

  String get displayType => safeString(type);

  NotificationSettingItem({this.type, this.enabledInApp, this.enabledEmail});

  factory NotificationSettingItem.fromJson(Map<String, dynamic> json) =>
      NotificationSettingItem(
        type: json["type"],
        enabledInApp: json["enabled_in_app"],
        enabledEmail: json["enabled_email"],
      );

  Map<String, dynamic> toJson() => {
    "type": type,
    "enabled_in_app": enabledInApp,
    "enabled_email": enabledEmail,
  };

  NotificationSettingItem copyWith({
    String? type,
    Object? enabledInApp = _sentinel,
    Object? enabledEmail = _sentinel,
  }) {
    return NotificationSettingItem(
      type: type ?? this.type,
      enabledInApp: identical(enabledInApp, _sentinel)
          ? this.enabledInApp
          : enabledInApp as bool?,
      enabledEmail: identical(enabledEmail, _sentinel)
          ? this.enabledEmail
          : enabledEmail as bool?,
    );
  }
}

const _sentinel = Object();