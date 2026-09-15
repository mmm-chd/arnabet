class CreateProductRequestModel {
  final int brandId;
  final String productName;

  CreateProductRequestModel({required this.brandId, required this.productName});

  Map<String, dynamic> toMap() {
    return {"brand_id": brandId, "product_name": productName};
  }
}
