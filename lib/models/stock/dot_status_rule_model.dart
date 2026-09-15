import 'dart:convert';

import 'package:arena/helper/safe_helpers.dart';

DotStatusRuleModel dotStatusRuleModelFromJson(String str) =>
    DotStatusRuleModel.fromJson(json.decode(str));

String dotStatusRuleModelToJson(DotStatusRuleModel data) =>
    json.encode(data.toJson());

class DotStatusRuleModel {
  bool? success;
  String? message;
  List<Datum>? data;

  DotStatusRuleModel({this.success, this.message, this.data});

  factory DotStatusRuleModel.fromJson(Map<String, dynamic> json) =>
      DotStatusRuleModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? id;
  String? name;
  int? minMonth;
  int? maxMonth;
  int? priority;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  String get displayName => safeString(name);
  String get displayMinMonth => safeDate(minMonth);
  String get displayMaxMonth => safeDate(maxMonth);
  String get displayIsActive => safeString(isActive);
  String get displayCreatedAt => safeDate(createdAt);
  String get displayUpdatedAt => safeDate(updatedAt);

  Datum({
    this.id,
    this.name,
    this.minMonth,
    this.maxMonth,
    this.priority,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    minMonth: json["min_month"],
    maxMonth: json["max_month"],
    priority: json["priority"],
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
    "min_month": minMonth,
    "max_month": maxMonth,
    "priority": priority,
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
