import 'package:arena/helper/safe_helpers.dart';

class CartListModel {
  bool? success;
  String? message;
  CartListData? data;

  String get displayMessage => safeString(message);

  CartListModel({this.success, this.message, this.data});

  factory CartListModel.fromJson(Map<String, dynamic> json) => CartListModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : CartListData.fromJson(json["data"]),
  );
}

class CartListData {
  String? id;
  List<Item>? items;
  int? subtotal;
  int? discount;
  int? total;
  int? itemCount;

  String get displayId => safeString(id);
  String get displaySubtotal => safeString(subtotal);
  String get displayDiscount => safeString(discount);
  String get displayTotal => safeString(total);
  String get displayItemCount => safeString(itemCount);

  CartListData({
    this.id,
    this.items,
    this.subtotal,
    this.discount,
    this.total,
    this.itemCount,
  });

  factory CartListData.fromJson(Map<String, dynamic> json) => CartListData(
    id: json["id"],
    items: json["items"] == null
        ? []
        : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    subtotal: json["subtotal"],
    discount: json["discount"],
    total: json["total"],
    itemCount: json["item_count"],
  );

  CartListData copyWith({
    String? id,
    List<Item>? items,
    int? subtotal,
    int? discount,
    int? total,
    int? itemCount,
  }) {
    return CartListData(
      id: id ?? this.id,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      itemCount: itemCount ?? this.itemCount,
    );
  }
}

class Item {
  String? id;
  String? itemType;
  String? stockId;
  String? productId;
  int? serviceId;
  String? productName;
  String? serviceName;
  String? brand;
  String? size;
  String? ring;
  String? sku;
  String? batchCode;
  int? quantity;
  int? unitPrice;
  int? subtotal;
  int? availableQty;

  String get displayId => safeString(id);
  String get displayProductName => safeString(productName);
  String get displayServiceName => safeString(serviceName);
  String get displayBrand => safeString(brand);
  String get displaySku => safeString(sku);
  String get displayBatchCode => safeString(batchCode);
  String get displayQuantity => safeString(quantity);
  String get displayUnitPrice => safeString(unitPrice);
  String get displaySubtotal => safeString(subtotal);
  String get displayAvailableQty => safeString(availableQty);

  Item({
    this.id,
    this.itemType,
    this.stockId,
    this.productId,
    this.serviceId,
    this.productName,
    this.serviceName,
    this.brand,
    this.size,
    this.ring,
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
    stockId: json["stock_id"],
    productId: json["product_id"],
    serviceId: json["service_id"],
    productName: json["product_name"],
    serviceName: json["service_name"],
    brand: json["brand"],
    size: json["size"],
    ring: json["ring"],
    sku: json["sku"],
    batchCode: json["batch_code"],
    quantity: json["quantity"],
    unitPrice: json["unit_price"],
    subtotal: json["subtotal"],
    availableQty: json["available_qty"],
  );

  Item copyWith({int? quantity, int? subtotal, int? availableQty}) {
    return Item(
      id: id,
      itemType: itemType,
      stockId: stockId,
      productId: productId,
      serviceId: serviceId,
      productName: productName,
      serviceName: serviceName,
      brand: brand,
      size: size,
      ring: ring,
      sku: sku,
      batchCode: batchCode,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice,
      subtotal: subtotal ?? this.subtotal,
      availableQty: availableQty ?? this.availableQty,
    );
  }
}
