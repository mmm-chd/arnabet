import 'dart:convert';

import 'package:arena/helper/string_extension_helper.dart';
import 'package:arena/helper/safe_helpers.dart';

CustomerListModel customerListModelFromJson(String str) =>
    CustomerListModel.fromJson(json.decode(str));

String customerListModelToJson(CustomerListModel data) =>
    json.encode(data.toJson());

class CustomerListModel {
  bool? success;
  String? message;
  List<CustomerListDatum>? data;
  Meta? meta;

  CustomerListModel({this.success, this.message, this.data, this.meta});

  factory CustomerListModel.fromJson(Map<String, dynamic> json) =>
      CustomerListModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<CustomerListDatum>.from(
                json["data"]!.map((x) => CustomerListDatum.fromJson(x)),
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

class CustomerListDatum {
  String? id;
  String? name;
  String? phone;
  List<Vehicle>? vehicles;
  DateTime? createdAt;
  DateTime? lastOrderAt;
  DateTime? lastOrderDate;

  String get displayName => safeString(name).toTitleCase();
  String get displayPhone => safeString(phone);
  String get displayCreatedAt => safeDate(createdAt, format: "dd MMM yyyy");
  String get displayLastOrderAt =>
      safeDate(lastOrderDate, format: "dd MMM yyyy");

  CustomerListDatum({
    this.id,
    this.name,
    this.phone,
    this.vehicles,
    this.createdAt,
    this.lastOrderAt,
    this.lastOrderDate,
  });

  factory CustomerListDatum.fromJson(Map<String, dynamic> json) =>
      CustomerListDatum(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        vehicles: json["vehicles"] == null
            ? []
            : List<Vehicle>.from(
                json["vehicles"]!.map((x) => Vehicle.fromJson(x)),
              ),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        lastOrderAt: json["last_order_at"] == null
            ? null
            : DateTime.parse(json["last_order_at"]),
        lastOrderDate: json["last_order_date"] == null
            ? null
            : DateTime.parse(json["last_order_date"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "vehicles": vehicles == null
        ? []
        : List<dynamic>.from(vehicles!.map((x) => x.toJson())),
    "created_at": createdAt?.toIso8601String(),
    "last_order_at": lastOrderAt?.toIso8601String(),
    "last_order_date": lastOrderDate == null
        ? null
        : "${lastOrderDate!.year.toString().padLeft(4, '0')}-${lastOrderDate!.month.toString().padLeft(2, '0')}-${lastOrderDate!.day.toString().padLeft(2, '0')}",
  };
}

class Vehicle {
  String? id;
  String? name;
  String? plate;

  String get displayVehicleName => safeString(name);
  String get displayVehiclePlate => safeString(plate);

  Vehicle({this.id, this.name, this.plate});

  factory Vehicle.fromJson(Map<String, dynamic> json) =>
      Vehicle(id: json["id"], name: json["name"], plate: json["plate"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "plate": plate};
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
