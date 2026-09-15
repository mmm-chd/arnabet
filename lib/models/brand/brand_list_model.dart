import 'dart:convert';

import 'package:arena/helper/string_extension_helper.dart';
import 'package:arena/helper/safe_helpers.dart';

BrandListModel brandListModelFromJson(String str) =>
    BrandListModel.fromJson(json.decode(str));

String brandListModelToJson(BrandListModel data) => json.encode(data.toJson());

class BrandListModel {
  bool? success;
  String? message;
  List<BrandListDatum>? data;
  BrandListMeta? meta;

  BrandListModel({this.success, this.message, this.data, this.meta});

  factory BrandListModel.fromJson(Map<String, dynamic> json) => BrandListModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<BrandListDatum>.from(
            json["data"]!.map((x) => BrandListDatum.fromJson(x)),
          ),
    meta: json["meta"] == null ? null : BrandListMeta.fromJson(json["meta"]),
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

class BrandListMeta {
  BrandListPagination? pagination;

  BrandListMeta({this.pagination});

  factory BrandListMeta.fromJson(Map<String, dynamic> json) => BrandListMeta(
    pagination: json["pagination"] == null
        ? null
        : BrandListPagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {"pagination": pagination?.toJson()};
}

class BrandListPagination {
  int? currentPage;
  int? totalPages;
  int? totalItems;
  int? itemsPerPage;

  BrandListPagination({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.itemsPerPage,
  });

  factory BrandListPagination.fromJson(Map<String, dynamic> json) =>
      BrandListPagination(
        currentPage: json["current_page"],
        totalPages: json["total_pages"],
        totalItems: json["total_items"],
        itemsPerPage: json["items_per_page"],
      );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "total_pages": totalPages,
    "total_items": totalItems,
    "items_per_page": itemsPerPage,
  };
}

class BrandListDatum {
  int? id;
  String? name;
  int? productCount;
  DateTime? createdAt;
  DateTime? updatedAt;

  String get displayName => safeString(name).toTitleCase();
  String get displayProductCount => safeString(productCount);
  String get displayCreatedAt => safeDate(createdAt);
  String get displayUpdatedAt => safeDate(updatedAt);

  BrandListDatum({
    this.id,
    this.name,
    this.productCount,
    this.createdAt,
    this.updatedAt,
  });

  factory BrandListDatum.fromJson(Map<String, dynamic> json) => BrandListDatum(
    id: json["id"],
    name: json["name"],
    productCount: json["product_count"],
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
    "product_count": productCount,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
