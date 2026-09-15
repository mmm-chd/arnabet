class CreateProductResponseModel {
  bool? success;
  String? message;
  CreateProductData? data;
  CreateProductMeta? meta;

  CreateProductResponseModel({
    this.success,
    this.message,
    this.data,
    this.meta,
  });

  factory CreateProductResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateProductResponseModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null
          ? null
          : CreateProductData.fromJson(json["data"]),
      meta: json["meta"] == null
          ? null
          : CreateProductMeta.fromJson(json["meta"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
        "meta": meta?.toJson(),
      };
}

class CreateProductData {
  String? id;
  String? sku;
  int? categoryId;
  ProductCategory? category;
  int? brandId;
  ProductBrand? brand;
  String? name;
  int? sellingPrice;
  String? rackLocation;
  ProductSpecification? specifications;
  String? createdAt;
  String? updatedAt;

  CreateProductData({
    this.id,
    this.sku,
    this.categoryId,
    this.category,
    this.brandId,
    this.brand,
    this.name,
    this.sellingPrice,
    this.rackLocation,
    this.specifications,
    this.createdAt,
    this.updatedAt,
  });

  factory CreateProductData.fromJson(Map<String, dynamic> json) {
    return CreateProductData(
      id: json["id"],
      sku: json["sku"],
      categoryId: json["category_id"],
      category: json["category"] == null
          ? null
          : ProductCategory.fromJson(json["category"]),
      brandId: json["brand_id"],
      brand: json["brand"] == null
          ? null
          : ProductBrand.fromJson(json["brand"]),
      name: json["name"],
      sellingPrice: json["selling_price"],
      rackLocation: json["rack_location"],
      specifications: json["specifications"] == null
          ? null
          : ProductSpecification.fromJson(json["specifications"]),
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "sku": sku,
        "category_id": categoryId,
        "category": category?.toJson(),
        "brand_id": brandId,
        "brand": brand?.toJson(),
        "name": name,
        "selling_price": sellingPrice,
        "rack_location": rackLocation,
        "specifications": specifications?.toJson(),
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class ProductCategory {
  int? id;
  String? name;
  String? description;
  String? createdAt;
  String? updatedAt;

  ProductCategory({
    this.id,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class ProductBrand {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  ProductBrand({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductBrand.fromJson(Map<String, dynamic> json) {
    return ProductBrand(
      id: json["id"],
      name: json["name"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class ProductSpecification {
  String? ukuran;
  String? ring;

  ProductSpecification({
    this.ukuran,
    this.ring,
  });

  factory ProductSpecification.fromJson(Map<String, dynamic> json) {
    return ProductSpecification(
      ukuran: json["ukuran"],
      ring: json["ring"],
    );
  }

  Map<String, dynamic> toJson() => {
        "ukuran": ukuran,
        "ring": ring,
      };
}

class CreateProductMeta {
  int? page;
  int? limit;
  int? totalItems;
  int? totalPages;

  CreateProductMeta({
    this.page,
    this.limit,
    this.totalItems,
    this.totalPages,
  });

  factory CreateProductMeta.fromJson(Map<String, dynamic> json) {
    return CreateProductMeta(
      page: json["page"],
      limit: json["limit"],
      totalItems: json["total_items"],
      totalPages: json["total_pages"],
    );
  }

  Map<String, dynamic> toJson() => {
        "page": page,
        "limit": limit,
        "total_items": totalItems,
        "total_pages": totalPages,
      };
}