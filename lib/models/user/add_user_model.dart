import 'dart:convert';
import 'package:arena/helper/safe_helpers.dart';

AddUserModel addUserModelFromJson(String str) =>
    AddUserModel.fromJson(json.decode(str));

String addUserModelToJson(AddUserModel data) => json.encode(data.toJson());

class AddUserModel {
  bool? success;
  String? errorCode;
  String? message;

  String get displayMessage => safeString(message);

  AddUserModel({this.success, this.errorCode, this.message});

  factory AddUserModel.fromJson(Map<String, dynamic> json) => AddUserModel(
    success: json["success"],
    errorCode: json["error_code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "error_code": errorCode,
    "message": message,
  };
}
