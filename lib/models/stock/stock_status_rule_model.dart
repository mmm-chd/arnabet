import 'package:arena/helper/safe_helpers.dart';

class StockStatusRuleModel {
  bool? success;
  String? message;
  List<StockStatusRuleItem>? data;

  StockStatusRuleModel({this.success, this.message, this.data});

  factory StockStatusRuleModel.fromJson(Map<String, dynamic> json) =>
      StockStatusRuleModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<StockStatusRuleItem>.from(
                json["data"]!.map((x) => StockStatusRuleItem.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class StockStatusRuleItem {
  String? id;
  String? name;
  int? minQty;
  int? maxQty;
  int? priority;
  bool? isAlert;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  String get displayName => safeString(name);
  String get displayMinQty => minQty?.toString() ?? "-";
  String get displayMaxQty => maxQty?.toString() ?? "∞";
  String get displayPriority => priority?.toString() ?? "-";
  String get displayAlert => isAlert == true ? "Ya" : "Tidak";
  String get displayActive => isActive == true ? "Aktif" : "Nonaktif";
  String get displayCreatedAt => safeDate(createdAt);
  String get displayUpdatedAt => safeDate(updatedAt);

  StockStatusRuleItem({
    this.id,
    this.name,
    this.minQty,
    this.maxQty,
    this.priority,
    this.isAlert,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory StockStatusRuleItem.fromJson(Map<String, dynamic> json) =>
      StockStatusRuleItem(
        id: json["id"],
        name: json["name"],
        minQty: json["min_qty"],
        maxQty: json["max_qty"],
        priority: json["priority"],
        isAlert: json["is_alert"],
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
    "min_qty": minQty,
    "max_qty": maxQty,
    "priority": priority,
    "is_alert": isAlert,
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}