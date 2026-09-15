import 'dart:convert';

import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/helper/safe_helpers.dart';

StockListModel stockListModelFromJson(String str) =>
    StockListModel.fromJson(json.decode(str));

String stockListModelToJson(StockListModel data) => json.encode(data.toJson());

class StockListModel {
  bool? success;
  String? message;
  List<StockListDatum>? data;
  Meta? meta;

  StockListModel({this.success, this.message, this.data, this.meta});

  factory StockListModel.fromJson(Map<String, dynamic> json) => StockListModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<StockListDatum>.from(
            json["data"]!.map((x) => StockListDatum.fromJson(x)),
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

class StockListDatum {
  String? productId;
  String? productName;
  String? size;
  String? ring;
  String? brandName;
  int? sellPrice;
  int? totalQty;
  int? totalBatches;
  List<StockListBatch>? batches;
  StockListBatchStatus? batchStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  String get displayCreatedAt => safeDate(createdAt);
  String get displayUpdatedAt => safeDate(updatedAt);

  String get displayProductId => safeString(productId);
  String get displayProductName => safeString(productName);
  String get displaySize => safeString(size);
  String get displayRing => safeString(ring);
  String get displayBrandName => safeString(brandName);
  String get displaySellPrice => safeString(sellPrice?.toLocaleCurrency());
  String get displayTotalQty => safeString(totalQty);
  String get displayTotalBatches => safeString(totalBatches);

  StockListDatum({
    this.productId,
    this.productName,
    this.size,
    this.ring,
    this.brandName,
    this.sellPrice,
    this.totalQty,
    this.totalBatches,
    this.batches,
    this.batchStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory StockListDatum.fromJson(Map<String, dynamic> json) {
    final List<StockListBatch> parsedBatches = json["batches"] == null
        ? []
        : List<StockListBatch>.from(
            json["batches"]!.map((x) => StockListBatch.fromJson(x)),
          );

    // Sort by priority from StockListBatchStatus (larger scope), then updatedAt (newest first)
    parsedBatches.sort((a, b) {
      final aPriority = a.stockStatus?.priority ?? 0;
      final bPriority = b.stockStatus?.priority ?? 0;
      if (aPriority != bPriority) {
        return bPriority.compareTo(aPriority); // higher priority first
      }
      final aTime = a.updatedAt;
      final bTime = b.updatedAt;
      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1; // null at end
      if (bTime == null) return -1;
      return bTime.compareTo(aTime); // newest first
    });

    return StockListDatum(
      productId: json["product_id"],
      productName: json["product_name"],
      size: json["size"],
      ring: json["ring"],
      brandName: json["brand_name"],
      sellPrice: json["sell_price"],
      totalQty: json["total_qty"],
      totalBatches: json["total_batches"],
      batches: parsedBatches,
      batchStatus: json["batch_status"] == null
          ? null
          : StockListBatchStatus.fromJson(json["batch_status"]),
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "product_name": productName,
    "size": size,
    "ring": ring,
    "brand_name": brandName,
    "sell_price": sellPrice,
    "total_qty": totalQty,
    "total_batches": totalBatches,
    "batches": batches == null
        ? []
        : List<dynamic>.from(batches!.map((x) => x.toJson())),
    "batch_status": batchStatus?.toJson(),
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class StockListBatchStatus {
  String? name;
  int? priority;

  String get displayBatchStatusName => safeString(name);

  StockListBatchStatus({this.name, this.priority});

  factory StockListBatchStatus.fromJson(Map<String, dynamic> json) =>
      StockListBatchStatus(name: json["name"], priority: json["priority"]);

  Map<String, dynamic> toJson() => {"name": name, "priority": priority};
}

class StockListBatch {
  String? stockId;
  String? batchCode;
  int? quantity;
  int? buyPrice;
  int? sellPrice;
  int? daysInStock;
  DateTime? createdAt;
  DateTime? updatedAt;
  StockListBatchStatus? stockStatus;

  StockListBatch({
    this.stockId,
    this.batchCode,
    this.quantity,
    this.buyPrice,
    this.sellPrice,
    this.daysInStock,
    this.stockStatus,
    this.createdAt,
    this.updatedAt,
  });

  String get displayStockId => safeString(stockId);
  String get displayBatchCode => safeString(batchCode);
  String get displayQuantity => safeString(quantity);
  String get displayBuyPrice => safeString(buyPrice?.toLocaleCurrency());
  String get displaySellPrice => safeString(sellPrice?.toLocaleCurrency());
  String get displayDaysInStock => safeString(daysInStock);
  String get displayStockStatus => safeString(stockStatus?.name);
  String get displayCreatedAt => safeDate(createdAt);
  String get displayUpdatedAt => safeDate(updatedAt);

  factory StockListBatch.fromJson(Map<String, dynamic> json) => StockListBatch(
    stockId: json["stock_id"],
    batchCode: json["batch_code"],
    quantity: json["quantity"],
    buyPrice: json["buy_price"],
    sellPrice: json["sell_price"],
    daysInStock: json["days_in_stock"],
    stockStatus: json["stock_status"] == null
        ? null
        : StockListBatchStatus.fromJson(json["stock_status"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "stock_id": stockId,
    "batch_code": batchCode,
    "quantity": quantity,
    "buy_price": buyPrice,
    "sell_price": sellPrice,
    "days_in_stock": daysInStock,
    "stock_status": stockStatus?.toJson(),
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
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
