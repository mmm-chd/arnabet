import 'dart:convert';

import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/helper/safe_helpers.dart';

AddCartModel addCartModelFromJson(String str) =>
    AddCartModel.fromJson(json.decode(str));

String addCartModelToJson(AddCartModel data) => json.encode(data.toJson());

class AddCartModel {
  bool? success;
  String? message;
  AddCartData? data;

  // Display Getters
  String get displayMessage => safeString(message);

  AddCartModel({this.success, this.message, this.data});

  factory AddCartModel.fromJson(Map<String, dynamic> json) => AddCartModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : AddCartData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class AddCartData {
  String? id;
  String? cashierId;
  String? cashierName;
  List<Item>? items;
  int? subtotal;
  int? discount;
  String? discountType;
  int? total;
  int? itemCount;

  // Display Getters
  String get displayCashierId => safeString(cashierId);
  String get displayCashierName => safeString(cashierName);
  String get displaySubtotal => safeString(subtotal?.toLocaleCurrency());
  String get displayDiscount => safeString(discount?.toLocaleCurrency());
  String get displayDiscountType => safeString(discountType);
  String get displayTotal => safeString(total?.toLocaleCurrency());
  String get displayItemCount => safeString(itemCount);

  AddCartData({
    this.id,
    this.cashierId,
    this.cashierName,
    this.items,
    this.subtotal,
    this.discount,
    this.discountType,
    this.total,
    this.itemCount,
  });

  factory AddCartData.fromJson(Map<String, dynamic> json) => AddCartData(
    id: json["id"],
    cashierId: json["cashier_id"],
    cashierName: json["cashier_name"],
    items: json["items"] == null
        ? []
        : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    subtotal: json["subtotal"],
    discount: json["discount"],
    discountType: json["discount_type"],
    total: json["total"],
    itemCount: json["item_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cashier_id": cashierId,
    "cashier_name": cashierName,
    "items": items == null
        ? []
        : List<dynamic>.from(items!.map((x) => x.toJson())),
    "subtotal": subtotal,
    "discount": discount,
    "discount_type": discountType,
    "total": total,
    "item_count": itemCount,
  };
}

class Item {
  String? id;
  String? itemType;
  int? serviceId;
  String? productName;
  String? serviceName;
  String? brand;
  String? sku;
  String? batchCode;
  int? quantity;
  int? unitPrice;
  int? subtotal;
  int? availableQty;

  // Display Getters
  String get displayId => safeString(id);
  String get displayItemType => safeString(itemType);
  String get displayProductName => safeString(productName);
  String get displayServiceName => safeString(serviceName);
  String get displayBrand => safeString(brand);
  String get displaySku => safeString(sku);
  String get displayBatchCode => safeString(batchCode);
  String get displayQuantity => safeString(quantity);
  String get displayUnitPrice => safeString(unitPrice?.toLocaleCurrency());
  String get displaySubtotal => safeString(subtotal?.toLocaleCurrency());
  String get displayAvailableQty => safeString(availableQty);

  Item({
    this.id,
    this.itemType,
    this.serviceId,
    this.productName,
    this.serviceName,
    this.brand,
    this.sku,
    this.batchCode,
    this.quantity,
    this.unitPrice,
    this.subtotal,
    this.availableQty,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    itemType: json["item_type"],
    serviceId: json["service_id"],
    productName: json["product_name"],
    serviceName: json["service_name"],
    brand: json["brand"],
    sku: json["sku"],
    batchCode: json["batch_code"],
    quantity: json["quantity"],
    unitPrice: json["unit_price"],
    subtotal: json["subtotal"],
    availableQty: json["available_qty"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "item_type": itemType,
    "service_id": serviceId,
    "product_name": productName,
    "service_name": serviceName,
    "brand": brand,
    "sku": sku,
    "batch_code": batchCode,
    "quantity": quantity,
    "unit_price": unitPrice,
    "subtotal": subtotal,
    "available_qty": availableQty,
  };
}
