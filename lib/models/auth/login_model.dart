import 'dart:convert';

import 'package:arena/helper/safe_helpers.dart';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  bool? success;
  String? message;
  Data? data;

  // Display Getters
  String get displayMessage => safeString(message);

  LoginModel({this.success, this.message, this.data});

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
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
  String? accessToken;
  User? user;

  Data({this.accessToken, this.user});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    accessToken: json["access_token"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "user": user?.toJson(),
  };
}

class User {
  String id;
  String name;
  String? email;
  String role;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  // Display Getters
  String get displayId => id;
  String get displayName => safeString(name);
  String get displayEmail => safeString(email);
  String get displayRole => safeString(role);
  String get displayIsActive => safeString(isActive);
  String get displayCreatedAt => safeDate(createdAt, format: "dd MMM yyyy");
  String get displayUpdatedAt => safeDate(updatedAt, format: "dd MMM yyyy");

  User({
    required this.id,
    required this.name,
    this.email,
    required this.role,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
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
