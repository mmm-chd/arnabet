import 'dart:convert';

import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/helper/safe_helpers.dart';
import 'package:arena/models/enums/enums.dart';

OrderDetailModel orderDetailModelFromJson(String str) =>
    OrderDetailModel.fromJson(json.decode(str));

String orderDetailModelToJson(OrderDetailModel data) =>
    json.encode(data.toJson());

class OrderDetailModel {
  bool? success;
  String? message;
  OrderDetailData? data;

  OrderDetailModel({this.success, this.message, this.data});

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : OrderDetailData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class OrderDetailData {
  String? id;
  String? invoiceNumber;
  String? customerName;
  String? customerPhone;
  String? vehicleModel;
  String? vehiclePlate;
  OrderStatus? orderStatus;
  PaymentStatus? paymentStatus;
  PaymentMethod? paymentMethod;
  int? productTotal;
  int? addonTotal;
  int? totalAmount;
  int? discountAmount;
  int? finalAmount;
  List<OrderDetailItem>? items;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? paidAt;

  String get displayInvoiceNumber => safeString(invoiceNumber);
  String get displayCustomerName => safeString(customerName);
  String get displayCustomerPhone => safeString(customerPhone);
  String get displayVehicleModel => safeString(vehicleModel);
  String get displayVehiclePlate => safeString(vehiclePlate);
  String get displayOrderStatus => safeString(orderStatus);
  String get displayPaymentStatus => safeString(paymentStatus);
  String get displayPaymentMethod => safeString(paymentMethod?.toIndonesian());
  String get displayProductTotal =>
      safeString(productTotal?.toLocaleCurrency());
  String get displayAddonTotal => safeString(addonTotal?.toLocaleCurrency());
  String get displayTotalAmount => safeString(totalAmount?.toLocaleCurrency());
  String get displayDiscountAmount {
    return discountAmount != null && discountAmount! > 0
        ? "- ${discountAmount!.toLocaleCurrency()}"
        : "- Rp 0";
  }

  String get displayFinalAmount => safeString(finalAmount?.toLocaleCurrency());
  String get displayCreatedAt =>
      safeDate(createdAt, format: 'dd MMM yyyy, HH.mm');
  String get displayUpdatedAt =>
      safeDate(updatedAt, format: 'dd MMM yyyy, HH.mm');
  String get displayPaidAt => safeDate(paidAt, format: 'dd MMM yyyy, HH.mm');

  OrderDetailData({
    this.id,
    this.invoiceNumber,
    this.customerName,
    this.customerPhone,
    this.vehicleModel,
    this.vehiclePlate,
    this.orderStatus,
    this.paymentStatus,
    this.paymentMethod,
    this.productTotal,
    this.addonTotal,
    this.totalAmount,
    this.discountAmount,
    this.finalAmount,
    this.items,
    this.createdAt,
    this.updatedAt,
    this.paidAt,
  });

  factory OrderDetailData.fromJson(Map<String, dynamic> json) =>
      OrderDetailData(
        id: json["id"],
        invoiceNumber: json["invoice_number"],
        customerName: json["customer_name"],
        customerPhone: json["customer_phone"],
        vehicleModel: json["vehicle_model"],
        vehiclePlate: json["vehicle_plate"],
        orderStatus: orderStatusValues.map[json["order_status"]],
        paymentStatus: paymentStatusValues.map[json["payment_status"]],
        paymentMethod: paymentMethodValues.map[json["payment_method"]],
        productTotal: json["product_total"],
        addonTotal: json["addon_total"],
        totalAmount: json["total_amount"],
        discountAmount: json["discount_amount"],
        finalAmount: json["final_amount"],
        items: json["items"] == null
            ? []
            : List<OrderDetailItem>.from(
                json["items"]!.map((x) => OrderDetailItem.fromJson(x)),
              ),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        paidAt: json["paid_at"] == null
            ? null
            : DateTime.parse(json["paid_at"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "invoice_number": invoiceNumber,
    "customer_name": customerName,
    "customer_phone": customerPhone,
    "vehicle_model": vehicleModel,
    "vehicle_plate": vehiclePlate,
    "order_status": orderStatus,
    "payment_status": paymentStatus,
    "payment_method": paymentMethodValues.reverse[paymentMethod],
    "product_total": productTotal,
    "addon_total": addonTotal,
    "total_amount": totalAmount,
    "discount_amount": discountAmount,
    "final_amount": finalAmount,
    "items": items == null
        ? []
        : List<dynamic>.from(items!.map((x) => x.toJson())),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "paid_at": paidAt?.toIso8601String(),
  };
}

class OrderDetailItem {
  String? itemId;
  ItemType? itemType;
  String? brandName;
  String? productName;
  String? size;
  String? ring;
  String? batchCode;
  int? quantity;
  int? unitPrice;
  int? costPrice;
  int? subtotal;

  String get displayItemType => safeString(itemType);
  String get displayBrandName => safeString(brandName);
  String get displayProductName => safeString(productName);
  String get displaySize => safeString(size);
  String get displayRing => safeString(ring);
  String get displayBatchCode => safeString(batchCode);
  String get displayQuantity => safeString(quantity);
  String get displayQty => safeString(quantity);
  String get displayUnitPrice => safeString(unitPrice);
  String get displayCostPrice => safeString(costPrice);
  String get displaySubtotal => safeString(subtotal);

  OrderDetailItem({
    this.itemId,
    this.itemType,
    this.brandName,
    this.productName,
    this.size,
    this.ring,
    this.batchCode,
    this.quantity,
    this.unitPrice,
    this.costPrice,
    this.subtotal,
  });

  factory OrderDetailItem.fromJson(Map<String, dynamic> json) =>
      OrderDetailItem(
        itemId: json["item_id"],
        itemType: itemTypeValues.map[json["item_type"]],
        brandName: json["brand_name"],
        productName: json["product_name"],
        size: json["size"],
        ring: json["ring"],
        batchCode: json["batch_code"],
        quantity: json["quantity"],
        unitPrice: json["unit_price"],
        costPrice: json["cost_price"],
        subtotal: json["subtotal"],
      );

  Map<String, dynamic> toJson() => {
    "item_id": itemId,
    "item_type": itemType,
    "brand_name": brandName,
    "product_name": productName,
    "size": size,
    "ring": ring,
    "batch_code": batchCode,
    "quantity": quantity,
    "unit_price": unitPrice,
    "cost_price": costPrice,
    "subtotal": subtotal,
  };
}
