import 'dart:convert';

import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/helper/safe_helpers.dart';
import 'package:arena/helper/string_extension_helper.dart';
import 'package:arena/helper/time_helper.dart';
import 'package:arena/models/enums/enums.dart';

OrderListModel orderListModelFromJson(String str) =>
    OrderListModel.fromJson(json.decode(str));

String orderListModelToJson(OrderListModel data) => json.encode(data.toJson());

class OrderListModel {
  bool? success;
  String? message;
  List<OrderListDatum>? data;
  Meta? meta;

  OrderListModel({this.success, this.message, this.data, this.meta});

  factory OrderListModel.fromJson(Map<String, dynamic> json) => OrderListModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<OrderListDatum>.from(
            json["data"]!.map((x) => OrderListDatum.fromJson(x)),
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

class OrderListDatum {
  String? id;
  String? invoiceNumber;
  String? customerName;
  String? customerPhone;
  String? vehicleModel;
  String? vehiclePlate;
  List<OrderListItem>? items;
  OrderStatus? orderStatus;
  PaymentStatus? paymentStatus;
  PaymentMethod? paymentMethod;
  int? totalAmount;
  int? finalAmount;
  DateTime? createdAt;

  String get displayOrderId => safeString(id);
  String get displayInvoiceNumber => safeString(invoiceNumber);
  String get displayCustomerName => safeString(customerName?.toTitleCase());
  String get displayCustomerPhone => safeString(customerPhone);
  String get displayVehicleModel => safeString(vehicleModel);
  String get displayVehiclePlate => safeString(vehiclePlate);
  String get displayOrderStatus => safeString(orderStatus);
  String get displayPaymentStatus => safeString(paymentStatus);
  String get displayPaymentMethod => safeString(paymentMethod);
  String get displayTotalAmount => safeString(totalAmount?.toLocaleCurrency());
  String get displayFinalAmount => safeString(finalAmount?.toLocaleCurrency());
  String get displayCreatedAt =>
      safeString(timeAgo(createdAt ?? DateTime.now()));

  OrderListDatum({
    this.id,
    this.invoiceNumber,
    this.customerName,
    this.customerPhone,
    this.vehicleModel,
    this.vehiclePlate,
    this.items,
    this.orderStatus,
    this.paymentStatus,
    this.paymentMethod,
    this.totalAmount,
    this.finalAmount,
    this.createdAt,
  });

  factory OrderListDatum.fromJson(Map<String, dynamic> json) => OrderListDatum(
    id: json["id"],
    invoiceNumber: json["invoice_number"],
    customerName: json["customer_name"],
    customerPhone: json["customer_phone"],
    vehicleModel: json["vehicle_model"],
    vehiclePlate: json["vehicle_plate"],
    items: json["items"] == null
        ? []
        : List<OrderListItem>.from(
            json["items"]!.map((x) => OrderListItem.fromJson(x)),
          ),
    orderStatus: orderStatusValues.map[json["order_status"]],
    paymentStatus: paymentStatusValues.map[json["payment_status"]],
    paymentMethod: paymentMethodValues.map[json["payment_method"]],
    totalAmount: json["total_amount"],
    finalAmount: json["final_amount"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "invoice_number": invoiceNumber,
    "customer_name": customerName,
    "customer_phone": customerPhone,
    "vehicle_model": vehicleModel,
    "vehicle_plate": vehiclePlate,
    "items": items == null
        ? []
        : List<dynamic>.from(items!.map((x) => x.toJson())),
    "order_status": orderStatusValues.reverse[orderStatus],
    "payment_status": paymentStatusValues.reverse[paymentStatus],
    "payment_method": paymentMethodValues.reverse[paymentMethod],
    "total_amount": totalAmount,
    "final_amount": finalAmount,
    "created_at": createdAt?.toIso8601String(),
  };

  OrderListDatum copyWith({
    String? id,
    String? invoiceNumber,
    String? customerName,
    String? customerPhone,
    String? vehicleModel,
    String? vehiclePlate,
    List<OrderListItem>? items,
    OrderStatus? orderStatus,
    PaymentStatus? paymentStatus,
    PaymentMethod? paymentMethod,
    int? totalAmount,
    int? finalAmount,
    DateTime? createdAt,
  }) {
    return OrderListDatum(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      items: items ?? this.items,
      orderStatus: orderStatus ?? this.orderStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      totalAmount: totalAmount ?? this.totalAmount,
      finalAmount: finalAmount ?? this.finalAmount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class OrderListItem {
  String? name;
  int? quantity;
  String? size;
  String? ring;
  ItemType? type;

  String get displayName => safeString(name);
  String get displayQuantity => safeString(quantity);
  String get displaySize => safeString(size);
  String get displayRing => safeString(ring);
  String get displayType => safeString(type);

  OrderListItem({this.name, this.quantity, this.size, this.ring, this.type});

  factory OrderListItem.fromJson(Map<String, dynamic> json) => OrderListItem(
    name: json["name"],
    quantity: json["quantity"],
    size: json["size"],
    ring: json["ring"],
    type: itemTypeValues.map[json["type"]],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "quantity": quantity,
    "size": size,
    "ring": ring,
    "type": itemTypeValues.reverse[type],
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
