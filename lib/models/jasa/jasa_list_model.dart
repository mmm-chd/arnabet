import 'dart:convert';

import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/helper/safe_helpers.dart';

JasaListModel jasaListModelFromJson(String str) =>
    JasaListModel.fromJson(json.decode(str));

String jasaListModelToJson(JasaListModel data) => json.encode(data.toJson());

class JasaListModel {
  bool? success;
  String? message;
  List<Datum>? data;

  JasaListModel({this.success, this.message, this.data});

  factory JasaListModel.fromJson(Map<String, dynamic> json) => JasaListModel(
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
  int? id;
  String? name;
  int? price;
  DateTime? createdAt;
  DateTime? updatedAt;

  String get displayName => safeString(name);
  String get displayPrice => safeString(price?.toLocaleCurrency());
  String get displayCreatedAt => safeDate(createdAt);
  String get displayUpdatedAt => safeDate(updatedAt);

  Datum({this.id, this.name, this.price, this.createdAt, this.updatedAt});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    price: json["price"],
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
    "price": price,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
