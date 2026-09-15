import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/helper/string_extension_helper.dart';
import 'package:arena/helper/safe_helpers.dart';

class ProductListModel {
  bool? success;
  String? message;
  List<ProductListDatum>? data;
  ProductMeta? meta;

  ProductListModel({this.success, this.message, this.data, this.meta});

  factory ProductListModel.fromJson(Map<String, dynamic> json) =>
      ProductListModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<ProductListDatum>.from(
                json["data"]!.map((x) => ProductListDatum.fromJson(x)),
              ),
        meta: json["meta"] == null ? null : ProductMeta.fromJson(json["meta"]),
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

class ProductListDatum {
  int? brandId;
  String? brandName;
  List<ProductModel> models;

  String get displayBrandName => safeString(brandName);

  ProductListDatum({this.brandId, this.brandName, required this.models});

  factory ProductListDatum.fromJson(Map<String, dynamic> json) =>
      ProductListDatum(
        brandId: json["brand_id"],
        brandName: json["brand_name"],
        models: json["models"] == null
            ? []
            : List<ProductModel>.from(
                json["models"]!.map((x) => ProductModel.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "brand_id": brandId,
    "brand_name": brandName,
    "models": List<dynamic>.from(models.map((x) => x.toJson())),
  };
}

class ProductModel {
  String? productId;
  String? modelName;
  int? totalVariants;
  List<ProductVariant> variants;

  String get displayModelName => safeString(modelName).toTitleCase();
  String get displayTotalVariants => safeString(totalVariants);

  ProductModel({
    this.productId,
    this.modelName,
    this.totalVariants,
    required this.variants,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    productId: json["id"],
    modelName: json["model_name"],
    totalVariants: json["total_variants"],
    variants: json["variants"] == null
        ? []
        : List<ProductVariant>.from(
            json["variants"]!.map((x) => ProductVariant.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": productId,
    "model_name": modelName,
    "total_variants": totalVariants,
    "variants": List<dynamic>.from(variants.map((x) => x.toJson())),
  };
}

class ProductVariant {
  String productId;
  String? size;
  String? ring;
  int? sellPrice;
  int? buyPrice;

  ProductVariant({
    required this.productId,
    this.size,
    this.ring,
    this.sellPrice,
    this.buyPrice,
  });

  String get displayProductId => safeString(productId);
  String get displaySize => safeString(size);
  String get displayRing => safeString(ring);
  String get displaySellPrice => safeString(sellPrice?.toLocaleCurrency());
  String get displayBuyPrice => safeString(buyPrice?.toLocaleCurrency());

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
    productId: json["product_id"],
    size: json["size"],
    ring: json["ring"],
    sellPrice: json["sell_price"],
    buyPrice: json["buy_price"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "size": size,
    "ring": ring,
    "sell_price": sellPrice,
    "buy_price": buyPrice,
  };
}

class ProductMeta {
  int? page;
  int? limit;
  int? totalItems;
  int? totalPages;

  ProductMeta({this.page, this.limit, this.totalItems, this.totalPages});

  factory ProductMeta.fromJson(Map<String, dynamic> json) {
    final pagination = json["pagination"];

    return ProductMeta(
      page: pagination["page"],
      limit: pagination["limit"],
      totalItems: pagination["total_items"],
      totalPages: pagination["total_pages"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "pagination": {
        "page": page,
        "limit": limit,
        "total_items": totalItems,
        "total_pages": totalPages,
      },
    };
  }
}
