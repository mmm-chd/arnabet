class CreateVariantRequestModel {
  final String size;
  final String ring;
  final int? sellPrice;
  final int? buyPrice;

  const CreateVariantRequestModel({
    required this.size,
    required this.ring,
    this.sellPrice,
    this.buyPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      "size": size,
      "ring": ring,
      "sell_price": sellPrice,
      "buy_price": buyPrice,
    };
  }
}