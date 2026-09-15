class ProductSizeModel {
  String size;
  String ring;
  int sellPrice;
  int? buyPrice;

  ProductSizeModel({
    required this.size,
    required this.ring,
    required this.sellPrice,
    this.buyPrice,
  });
}