import 'dart:convert';

import 'package:arena/helper/safe_helpers.dart';

NotificationListModel notificationListModelFromJson(String str) =>
    NotificationListModel.fromJson(json.decode(str));

String notificationListModelToJson(NotificationListModel data) =>
    json.encode(data.toJson());

class NotificationListModel {
  bool? success;
  String? message;
  List<Datum>? data;
  Meta? meta;

  NotificationListModel({this.success, this.message, this.data, this.meta});

  factory NotificationListModel.fromJson(Map<String, dynamic> json) =>
      NotificationListModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "meta": meta?.toJson(),
  };
}

class Datum {
  String? id;
  String? type;
  String? title;
  String? message;
  bool? isRead;
  DateTime? createdAt;

  String get displayType => safeString(type);
  String get displayTitle => safeString(title);
  String get displayMessage => safeString(message);
  String get displayCreatedAt => safeDate(createdAt);

  Datum({
    this.id,
    this.type,
    this.title,
    this.message,
    this.isRead,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    type: json["type"],
    title: json["title"],
    message: json["message"],
    isRead: json["is_read"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "title": title,
    "message": message,
    "is_read": isRead,
    "created_at": createdAt?.toIso8601String(),
  };
}

class Meta {
  Pagination? pagination;

  Meta({this.pagination});

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    pagination: json["pagination"] == null
        ? null
        : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {"pagination": pagination?.toJson()};
}

class Pagination {
  int? page;
  int? limit;
  int? totalItems;
  int? totalPages;

  Pagination({this.page, this.limit, this.totalItems, this.totalPages});

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    page: json["page"],
    limit: json["limit"],
    totalItems: json["total_items"],
    totalPages: json["total_pages"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "total_items": totalItems,
    "total_pages": totalPages,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
