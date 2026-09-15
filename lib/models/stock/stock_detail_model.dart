import 'dart:convert';

import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/helper/safe_helpers.dart';
import 'package:arena/models/metadata/status_style.dart';
import 'package:arena/config/design/status_color_config.dart';

StockDetailModel stockDetailModelFromJson(String str) =>
    StockDetailModel.fromJson(json.decode(str));

String stockDetailModelToJson(StockDetailModel data) =>
    json.encode(data.toJson());

class StockDetailModel {
  bool? success;
  String? message;
  StockDetailData? data;

  StockDetailModel({this.success, this.message, this.data});

  factory StockDetailModel.fromJson(Map<String, dynamic> json) =>
      StockDetailModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : StockDetailData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class StockDetailData {
  String? productId;
  String? productName;
  String? size;
  String? ring;
  String? brandName;
  int? sellPrice;
  int? totalQty;
  int? totalBatches;
  List<StockDetailBatch>? batches;
  StockDetailBatchStatus? batchStatus;

  String get displayProductId => safeString(productId);
  String get displayProductName => safeString(productName);
  String get displaySize => safeString(size);
  String get displayRing => safeString(ring);
  String get displayBrandName => safeString(brandName);
  String get displaySellPrice => safeString(sellPrice?.toLocaleCurrency());
  String get displayTotalQty => safeString(totalQty);
  String get displayTotalBatches => safeString(totalBatches);

  StockDetailBatch? get _latestBatch {
    if (batches == null || batches!.isEmpty) return null;
    return batches!.reduce(
      (a, b) => (a.daysInStock ?? 0) <= (b.daysInStock ?? 0) ? a : b,
    );
  }

  int? get hargaBeliTerakhir => _latestBatch?.buyPrice;

  int? get hargaJualTerakhir => sellPrice;

  String get displayHargaJualBawaan => safeString(sellPrice);
  String get displayHargaBeliTerakhir => safeString(hargaBeliTerakhir);

  StockDetailData({
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
  });

  factory StockDetailData.fromJson(Map<String, dynamic> json) {
    final List<StockDetailBatch> parsedBatches = json["batches"] == null
        ? []
        : List<StockDetailBatch>.from(
            json["batches"]!.map((x) => StockDetailBatch.fromJson(x)),
          );

    parsedBatches.sort((a, b) {
      final aTime = a.updatedAt;
      final bTime = b.updatedAt;
      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1;
      if (bTime == null) return -1;
      return aTime.compareTo(bTime);
    });

    return StockDetailData(
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
          : StockDetailBatchStatus.fromJson(json["batch_status"]),
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
  };
}

class StockDetailBatchStatus {
  String? name;
  int? priority;

  String get displayName => safeString(name);
  StatusStyle get style => StockConfig.getStyleByName(name);

  StockDetailBatchStatus({this.name, this.priority});

  factory StockDetailBatchStatus.fromJson(Map<String, dynamic> json) =>
      StockDetailBatchStatus(name: json["name"], priority: json["priority"]);

  Map<String, dynamic> toJson() => {"name": name, "priority": priority};
}

class StockDetailBatch {
  String? stockId;
  String? batchCode;
  int? quantity;
  int? buyPrice;
  int? sellPrice;
  int? daysInStock;
  String? stockStatus;
  DateTime? updatedAt;

  String get displayStockId => safeString(stockId);
  String get displayBatchCode => safeString(batchCode);
  String get displayQuantity => safeString(quantity);
  String get displayBuyPrice => safeString(buyPrice?.toLocaleCurrency());
  String get displaySellPrice => safeString(sellPrice?.toLocaleCurrency());
  String get displayDaysInStock => safeString(daysInStock);
  String get displayStockStatus => safeString(stockStatus);

  StatusStyle get statusStyle => StockConfig.getStyleByName(stockStatus);

  StockDetailBatch({
    this.stockId,
    this.batchCode,
    this.quantity,
    this.buyPrice,
    this.sellPrice,
    this.daysInStock,
    this.stockStatus,
    this.updatedAt,
  });

  factory StockDetailBatch.fromJson(Map<String, dynamic> json) {
    final rawStatus = json["stock_status"];
    String? parsedStatus;
    if (rawStatus is String) {
      parsedStatus = rawStatus;
    } else if (rawStatus is Map) {
      parsedStatus = rawStatus["name"]?.toString();
    }
    return StockDetailBatch(
      stockId: json["stock_id"],
      batchCode: json["batch_code"],
      quantity: json["quantity"],
      buyPrice: json["buy_price"],
      sellPrice: json["sell_price"],
      daysInStock: json["days_in_stock"],
      stockStatus: parsedStatus,
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "stock_id": stockId,
    "batch_code": batchCode,
    "quantity": quantity,
    "buy_price": buyPrice,
    "sell_price": sellPrice,
    "days_in_stock": daysInStock,
    "stock_status": stockStatus,
    "updated_at": updatedAt?.toIso8601String(),
  };
}
