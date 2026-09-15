import 'dart:convert';

import 'package:arena/helper/safe_helpers.dart';

AddOrderModel addOrderModelFromJson(String str) =>
    AddOrderModel.fromJson(json.decode(str));

String addOrderModelToJson(AddOrderModel data) => json.encode(data.toJson());

class AddOrderModel {
  bool? success;
  String? message;
  Data? data;

  AddOrderModel({this.success, this.message, this.data});

  factory AddOrderModel.fromJson(Map<String, dynamic> json) => AddOrderModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  String? id;
  String? invoiceNumber;
  String? customerName;
  String? customerPhone;
  String? vehicleModel;
  String? vehiclePlate;
  String? status;
  String? paymentStatus;
  int? totalAmount;
  int? discountAmount;
  int? finalAmount;
  List<Item>? items;
  DateTime? createdAt;
  DateTime? updatedAt;


  // Display Getters
  String get displayId => safeString(id);
  String get displayInvoiceNumber => safeString(invoiceNumber);
  String get displayCustomerName => safeString(customerName);
  String get displayCustomerPhone => safeString(customerPhone);
  String get displayVehicleModel => safeString(vehicleModel);
  String get displayVehiclePlate => safeString(vehiclePlate);
  String get displayStatus => safeString(status);
  String get displayPaymentStatus => safeString(paymentStatus);

  Data({
    this.id,
    this.invoiceNumber,
    this.customerName,
    this.customerPhone,
    this.vehicleModel,
    this.vehiclePlate,
    this.status,
    this.paymentStatus,
    this.totalAmount,
    this.discountAmount,
    this.finalAmount,
    this.items,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    invoiceNumber: json["invoice_number"],
    customerName: json["customer_name"],
    customerPhone: json["customer_phone"],
    vehicleModel: json["vehicle_model"],
    vehiclePlate: json["vehicle_plate"],
    status: json["status"],
    paymentStatus: json["payment_status"],
    totalAmount: json["total_amount"],
    discountAmount: json["discount_amount"],
    finalAmount: json["final_amount"],
    items: json["items"] == null
        ? []
        : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "invoice_number": invoiceNumber,
    "customer_name": customerName,
    "customer_phone": customerPhone,
    "vehicle_model": vehicleModel,
    "vehicle_plate": vehiclePlate,
    "status": status,
    "payment_status": paymentStatus,
    "total_amount": totalAmount,
    "discount_amount": discountAmount,
    "final_amount": finalAmount,
    "items": items == null
        ? []
        : List<dynamic>.from(items!.map((x) => x.toJson())),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Item {
  String? itemId;
  String? itemType;
  String? productName;
  String? batchCode;
  int? quantity;
  int? unitPrice;
  int? costPrice;
  int? subtotal;
  String? size;
  String? ring;


  // Display Getters
  String get displayItemId => safeString(itemId);
  String get displayItemType => safeString(itemType);
  String get displayProductName => safeString(productName);
  String get displayBatchCode => safeString(batchCode);
  String get displayQuantity => safeString(quantity);
  String get displayUnitPrice => safeString(unitPrice);
  String get displayCostPrice => safeString(costPrice);
  String get displaySubtotal => safeString(subtotal);

  Item({
    this.itemId,
    this.itemType,
    this.productName,
    this.batchCode,
    this.quantity,
    this.unitPrice,
    this.costPrice,
    this.subtotal,
    this.size,
    this.ring,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    itemId: json["item_id"],
    itemType: json["item_type"],
    productName: json["product_name"],
    batchCode: json["batch_code"],
    quantity: json["quantity"],
    unitPrice: json["unit_price"],
    costPrice: json["cost_price"],
    subtotal: json["subtotal"],
    size: json["size"],
    ring: json["ring"],

  );

  Map<String, dynamic> toJson() => {
    "item_id": itemId,
    "item_type": itemType,
    "product_name": productName,
    "batch_code": batchCode,
    "quantity": quantity,
    "unit_price": unitPrice,
    "cost_price": costPrice,
    "subtotal": subtotal,
    "size": size,
    "ring": ring,
  };
}
