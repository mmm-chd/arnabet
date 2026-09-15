import 'package:arena/helper/safe_helpers.dart';

class ProfileModel {
  bool? success;
  String? message;
  Data? data;

  // Display Getters
  String get displayMessage => safeString(message);

  ProfileModel({this.success, this.message, this.data});

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}

class Data {
  String? id;
  String? name;
  String? email;
  String? role;
  bool? isActive;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;

  // Display Getters
  String get displayId => safeString(id);
  String get displayName => safeString(name);
  String get displayEmail => safeString(email);
  String get displayRole => safeString(role);
  String get displayImage => safeString(image);
  String get displayCreatedAt => safeDate(createdAt, format: "dd MMM yyyy");
  String get displayUpdatedAt => safeDate(updatedAt, format: "dd MMM yyyy");

  Data({
    this.id,
    this.name,
    this.email,
    this.role,
    this.isActive,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    role: json["role"],
    isActive: json["is_active"],
    image: json["image"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );
}
