import 'dart:convert';

import 'package:arena/helper/safe_helpers.dart';

RegisterModel registerModelFromJson(String str) =>
    RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  bool? success;
  String? message;
  Data? data;

  // Display Getters
  String get displayMessage => safeString(message);

  RegisterModel({this.success, this.message, this.data});

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  String? id;
  String? name;
  String? email;
  String? role;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  // Display Getters
  String get displayName => safeString(name);
  String get displayEmail => safeString(email);
  String get displayRole => safeString(role);
  String get displayIsActive => safeString(isActive);
  String get displayCreatedAt => safeDate(createdAt, format: "dd MMM yyyy");
  String get displayUpdatedAt => safeDate(updatedAt, format: "dd MMM yyyy");

  Data({
    this.id,
    this.name,
    this.email,
    this.role,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    role: json["role"],
    isActive: json["is_active"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "role": role,
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
