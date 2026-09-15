import 'dart:convert';

import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/helper/safe_helpers.dart';
import 'package:arena/models/enums/enums.dart';

CheckoutCartModel checkoutCartModelFromJson(String str) =>
    CheckoutCartModel.fromJson(json.decode(str));

String checkoutCartModelToJson(CheckoutCartModel data) =>
    json.encode(data.toJson());

class CheckoutCartModel {
  bool? success;
  String? message;
  Data? data;

  CheckoutCartModel({this.success, this.message, this.data});

  factory CheckoutCartModel.fromJson(Map<String, dynamic> json) =>
      CheckoutCartModel(
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
  String? orderId;
  String? invoiceNumber;
  String? customerName;
  String? customerPhone;
  String? vehicleModel;
  String? vehiclePlate;
  int? totalAmount;
  int? discountAmount;
  int? finalAmount;
  OrderStatus? status;
  PaymentStatus? paymentStatus;
  String? createdAt;
  
  String get displayOrderId => safeString(orderId);
  String get displayInvoiceNumber => safeString(invoiceNumber);
  String get displayCustomerName => safeString(customerName);
  String get displayCustomerPhone => safeString(customerPhone);
  String get displayVehicleModel => safeString(vehicleModel);
  String get displayVehiclePlate => safeString(vehiclePlate);
  String get displayTotalAmount => safeString(totalAmount?.toLocaleCurrency());
  String get displayDiscountAmount =>
      safeString(discountAmount?.toLocaleCurrency());
  String get displayFinalAmount => safeString(finalAmount?.toLocaleCurrency());
  String get displayStatus => safeString(status);
  String get displayPaymentStatus => safeString(paymentStatus);
  String get displayCreatedAt => safeString(createdAt);

  Data({
    this.orderId,
    this.invoiceNumber,
    this.customerName,
    this.customerPhone,
    this.vehicleModel,
    this.vehiclePlate,
    this.totalAmount,
    this.discountAmount,
    this.finalAmount,
    this.status,
    this.paymentStatus,
    this.createdAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    orderId: json["order_id"],
    invoiceNumber: json["invoice_number"],
    customerName: json["customer_name"],
    customerPhone: json["customer_phone"],
    vehicleModel: json["vehicle_model"],
    vehiclePlate: json["vehicle_plate"],
    totalAmount: json["total_amount"],
    discountAmount: json["discount_amount"],
    finalAmount: json["final_amount"],
    status: orderStatusValues.map[json["status"]],
    paymentStatus: paymentStatusValues.map[json["payment_status"]],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "invoice_number": invoiceNumber,
    "customer_name": customerName,
    "customer_phone": customerPhone,
    "vehicle_model": vehicleModel,
    "vehicle_plate": vehiclePlate,
    "total_amount": totalAmount,
    "discount_amount": discountAmount,
    "final_amount": finalAmount,
    "status": status,
    "payment_status": paymentStatus,
    "created_at": createdAt,
  };
}
