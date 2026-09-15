import 'dart:convert';

import 'package:arena/helper/safe_helpers.dart';

AdjustStockModel adjustStockModelFromJson(String str) =>
    AdjustStockModel.fromJson(json.decode(str));

String adjustStockModelToJson(AdjustStockModel data) =>
    json.encode(data.toJson());

class AdjustStockModel {
  bool? success;
  String? message;

  // Display Getters
  String get displayMessage => safeString(message);

  AdjustStockModel({this.success, this.message});

  factory AdjustStockModel.fromJson(Map<String, dynamic> json) =>
      AdjustStockModel(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}