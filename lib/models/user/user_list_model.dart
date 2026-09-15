import 'dart:convert';

import 'package:arena/helper/role_formatter.dart';
import 'package:arena/helper/safe_helpers.dart';

UserListModel userListModelFromJson(String str) =>
    UserListModel.fromJson(json.decode(str));

String userListModelToJson(UserListModel data) => json.encode(data.toJson());

class UserListModel {
  bool? success;
  String? message;
  List<UserListDatum>? data;
  Meta? meta;

  UserListModel({this.success, this.message, this.data, this.meta});

  factory UserListModel.fromJson(Map<String, dynamic> json) => UserListModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<UserListDatum>.from(
            json["data"]!.map((x) => UserListDatum.fromJson(x)),
          ),
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

class UserListDatum {
  String? id;
  String? name;
  String? email;
  String? role;
  bool? isActive;
  DateTime? createdAt;

  String get displayName => safeString(name);
  String get displayEmail => safeString(email);
  String get displayRole => safeString(role?.toRoleFormatter());
  String get displayIsActive => safeString(isActive);
  String get displayCreatedAt => safeDate(createdAt, format: "dd MMM yyyy");

  UserListDatum({
    this.id,
    this.name,
    this.email,
    this.role,
    this.isActive,
    this.createdAt,
  });

  UserListDatum copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    bool? isActive,
    DateTime? createdAt,
  }) => UserListDatum(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    role: role ?? this.role,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );

  factory UserListDatum.fromJson(Map<String, dynamic> json) => UserListDatum(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    role: json["role"],
    isActive: json["is_active"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "role": role,
    "is_active": isActive,
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
