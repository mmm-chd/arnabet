class CreateVariantResponseModel {
  final bool? success;
  final String? message;
  final VariantData? data;

  CreateVariantResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory CreateVariantResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CreateVariantResponseModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] != null
          ? VariantData.fromJson(json["data"])
          : null,
    );
  }
}

class VariantData {
  final String? id;
  final String? sku;

  final String? brand;
  final String? productName;

  final int? sellPrice;
  final int? buyPrice;

  final VariantSpecification? specifications;

  final DateTime? createdAt;

  VariantData({
    this.id,
    this.sku,
    this.brand,
    this.productName,
    this.sellPrice,
    this.buyPrice,
    this.specifications,
    this.createdAt,
  });

  factory VariantData.fromJson(
    Map<String, dynamic> json,
  ) {
    return VariantData(
      id: json["id"],
      sku: json["sku"],
      brand: json["brand"],
      productName: json["product_name"],
      sellPrice: json["sell_price"],
      buyPrice: json["buy_price"],
      specifications: json["specifications"] != null
          ? VariantSpecification.fromJson(json["specifications"])
          : null,
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : null,
    );
  }
}




class VariantSpecification {
  final String? size;
  final String? ring;

  VariantSpecification({
    this.size,
    this.ring,
  });

  factory VariantSpecification.fromJson(
    Map<String, dynamic> json,
  ) {
    return VariantSpecification(
      size: json["size"],
      ring: json["ring"],
    );
  }
}