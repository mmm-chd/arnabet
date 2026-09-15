import 'dart:convert';

import 'package:arena/helper/safe_helpers.dart';
import 'package:arena/models/enums/enums.dart';

StockHistoryModel stockHistoryModelFromJson(String str) =>
    StockHistoryModel.fromJson(json.decode(str));

String stockHistoryModelToJson(StockHistoryModel data) =>
    json.encode(data.toJson());

class StockHistoryModel {
  bool? success;
  String? message;
  List<StockHistoryDatum>? data;
  Meta? meta;

  StockHistoryModel({this.success, this.message, this.data, this.meta});

  factory StockHistoryModel.fromJson(Map<String, dynamic> json) =>
      StockHistoryModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<StockHistoryDatum>.from(
                json["data"]!.map((x) => StockHistoryDatum.fromJson(x)),
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

class StockHistoryDatum {
  String? id;
  String? productName;
  String? brandName;
  String? size;
  String? ring;
  int? totalBatches;
  StockHistoryType? type;
  int? quantity;
  int? stockBefore;
  int? stockAfter;
  StockHistoryReferenceType? referenceType;
  String? reason;
  String? invoiceNumber;
  List<StockHistoryAffectedBatch>? affectedBatches;
  StockHistoryBatchStatus? batchStatus;
  String? userName;
  String? userRole;
  DateTime? createdAt;

  String get displayProductName => safeString(productName);
  String get displayBrandName => safeString(brandName);
  String get displaySize => safeString(size);
  String get displayRing => safeString(ring);
  String get displayTotalDot => safeString(totalBatches);
  String get displayTypeName => safeString(type?.name);
  String get displayType => safeString(type?.label);
  String get displayQuantity => safeString(quantity);
  String get displayStockBefore => safeString(stockBefore);
  String get displayStockAfter => safeString(stockAfter);
  String get displayReferenceType => safeString(referenceType?.name);
  String get displayReason => safeString(reason);
  String get displayInvoiceNumber => safeString(invoiceNumber);
  String get displayUserName => safeString(userName);
  String get displayUserRole => safeString(userRole);
  String get displayCreatedAt => safeDate(createdAt, format: "dd MMM yyyy");

  StockHistoryDatum({
    this.id,
    this.productName,
    this.brandName,
    this.size,
    this.ring,
    this.totalBatches,
    this.type,
    this.quantity,
    this.stockBefore,
    this.stockAfter,
    this.referenceType,
    this.reason,
    this.invoiceNumber,
    this.affectedBatches,
    this.batchStatus,
    this.userName,
    this.userRole,
    this.createdAt,
  });

  factory StockHistoryDatum.fromJson(Map<String, dynamic> json) =>
      StockHistoryDatum(
        id: json["id"],
        productName: json["product_name"],
        brandName: json["brand_name"],
        size: json["size"],
        ring: json["ring"],
        totalBatches: json["total_batches"],
        type: stockHistoryTypeValues.map[json["type"]],
        quantity: json["quantity"],
        stockBefore: json["stock_before"],
        stockAfter: json["stock_after"],
        referenceType:
            stockHistoryReferenceTypeValues.map[json["reference_type"]],
        reason: json["reason"],
        invoiceNumber: json["invoice_number"],
        affectedBatches: json["affected_batches"] == null
            ? []
            : List<StockHistoryAffectedBatch>.from(
                json["affected_batches"]!.map(
                  (x) => StockHistoryAffectedBatch.fromJson(x),
                ),
              ),
        batchStatus: json["batch_status"] == null
            ? null
            : StockHistoryBatchStatus.fromJson(json["batch_status"]),
        userName: json["user_name"],
        userRole: json["user_role"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_name": productName,
    "brand_name": brandName,
    "size": size,
    "ring": ring,
    "total_batches": totalBatches,
    "type": type,
    "quantity": quantity,
    "stock_before": stockBefore,
    "stock_after": stockAfter,
    "reference_type": referenceType,
    "reason": reason,
    "invoice_number": invoiceNumber,
    "affected_batches": affectedBatches == null
        ? []
        : List<dynamic>.from(affectedBatches!.map((x) => x.toJson())),
    "batch_status": batchStatus?.toJson(),
    "user_name": userName,
    "user_role": userRole,
    "created_at": createdAt?.toIso8601String(),
  };
}

class StockHistoryAffectedBatch {
  String? stockId;
  String? batchCode;
  int? quantity;
  int? balanceBefore;
  int? balanceAfter;
  int? daysInStock;
  String? stockStatus;

  String get displayStockId => safeString(stockId);
  String get displayBatchCode => safeString(batchCode);
  String get displayQuantity => safeString(quantity);
  String get displayBalanceBefore => safeString(balanceBefore);
  String get displayBalanceAfter => safeString(balanceAfter);
  String get displayDaysInStock => safeString(daysInStock);
  String get displayStockStatus => safeString(stockStatus);

  StockHistoryAffectedBatch({
    this.stockId,
    this.batchCode,
    this.quantity,
    this.balanceBefore,
    this.balanceAfter,
    this.daysInStock,
    this.stockStatus,
  });

  factory StockHistoryAffectedBatch.fromJson(Map<String, dynamic> json) =>
      StockHistoryAffectedBatch(
        stockId: json["stock_id"],
        batchCode: json["batch_code"],
        quantity: json["quantity"],
        balanceBefore: json["balance_before"],
        balanceAfter: json["balance_after"],
        daysInStock: json["days_in_stock"],
        stockStatus: json["stock_status"],
      );

  Map<String, dynamic> toJson() => {
    "stock_id": stockId,
    "batch_code": batchCode,
    "quantity": quantity,
    "balance_before": balanceBefore,
    "balance_after": balanceAfter,
    "days_in_stock": daysInStock,
    "stock_status": stockStatus,
  };
}

class StockHistoryBatchStatus {
  String? name;
  int? priority;

  String get displayName => safeString(name);
  String get displayPriority => safeString(priority);

  StockHistoryBatchStatus({this.name, this.priority});

  factory StockHistoryBatchStatus.fromJson(Map<String, dynamic> json) =>
      StockHistoryBatchStatus(name: json["name"], priority: json["priority"]);

  Map<String, dynamic> toJson() => {"name": name, "priority": priority};
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
