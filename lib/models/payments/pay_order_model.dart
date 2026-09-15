import 'dart:convert';

import 'package:arena/helper/safe_helpers.dart';
import 'package:arena/models/enums/enums.dart';

PayOrderModel payOrderModelFromJson(String str) =>
    PayOrderModel.fromJson(json.decode(str));

String payOrderModelToJson(PayOrderModel data) => json.encode(data.toJson());

class PayOrderModel {
  bool? success;
  String? message;
  PayOrderData? data;

  PayOrderModel({this.success, this.message, this.data});

  factory PayOrderModel.fromJson(Map<String, dynamic> json) => PayOrderModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : PayOrderData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class PayOrderData {
  String? paymentId;
  String? orderId;
  PaymentMethod? method;
  PaymentStatus? status;
  num? orderTotal;
  num? amountPaid;
  num? change;
  Map<String, dynamic>? actionData;
  String? processedBy;
  DateTime? processedAt;

  String get displayProcessedBy => safeString(processedBy);
  String get displayProcessedAt =>
      safeDate(processedAt, format: 'dd MMM yyyy, HH.mm');

  String? get qrString =>
      actionData?["qr_string"]?.toString() ??
      actionData?["qris_string"]?.toString();
  String? get qrImageUrl =>
      actionData?["qr_url"]?.toString() ?? actionData?["qris_url"]?.toString();
  String? get vaNumber =>
      actionData?["va_number"]?.toString() ??
      actionData?["account_number"]?.toString();
  String? get vaBankName =>
      actionData?["bank_code"]?.toString() ?? actionData?["bank"]?.toString();
  DateTime? get vaExpiryDate {
    final raw = actionData?["expiry_date"] ?? actionData?["expires_at"];
    if (raw == null) return null;
    return DateTime.tryParse(raw.toString());
  }

  bool get isPending =>
      status == PaymentStatus.PROCESSING || status == PaymentStatus.UNPAID;
  bool get isPaid => status == PaymentStatus.PAID;
  bool get isFailedOrExpired =>
      status == PaymentStatus.FAILED || status == PaymentStatus.EXPIRED;

  PayOrderData({
    this.paymentId,
    this.orderId,
    this.method,
    this.status,
    this.orderTotal,
    this.amountPaid,
    this.change,
    this.actionData,
    this.processedBy,
    this.processedAt,
  });

  factory PayOrderData.fromJson(Map<String, dynamic> json) => PayOrderData(
    paymentId: json["payment_id"]?.toString(),
    orderId: json["order_id"]?.toString(),
    method: paymentMethodValues.map[json["method"]],
    status: paymentStatusValues.map[json["status"]],
    orderTotal: json["order_total"],
    amountPaid: json["amount_paid"],
    change: json["change"],
    actionData: json["action_data"] == null
        ? null
        : Map<String, dynamic>.from(json["action_data"]),
    processedBy: json["processed_by"],
    processedAt: json["processed_at"] == null
        ? null
        : DateTime.tryParse(json["processed_at"]),
  );

  Map<String, dynamic> toJson() => {
    "payment_id": paymentId,
    "order_id": orderId,
    "method": paymentMethodValues.reverse[method],
    "status": paymentStatusValues.reverse[status],
    "order_total": orderTotal,
    "amount_paid": amountPaid,
    "change": change,
    "action_data": actionData,
    "processed_by": processedBy,
    "processed_at": processedAt?.toIso8601String(),
  };
}
