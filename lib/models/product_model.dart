import 'product_size_model.dart';

class ProductModel {
  String brand;
  String name;
  List<ProductSizeModel> sizes;

  ProductModel({
    required this.brand,
    required this.name,
    required this.sizes,
  });
}
