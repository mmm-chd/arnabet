class UpdateProductRequestModel {
  final int? brandId;
  final String? name;
  final String? size;
  final String? ring;
  final int? sellPrice;
  final int? buyPrice;
  final String? reason;

  UpdateProductRequestModel({
    this.brandId,
    this.name,
    this.size,
    this.ring,
    this.sellPrice,
    this.buyPrice,
    this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) "name": name,
      if (brandId != null) "brand_id": brandId,
      if (size != null) "size": size,
      if (ring != null) "ring": ring,
      if (sellPrice != null) "sell_price": sellPrice,
      if (buyPrice != null) "buy_price": buyPrice,
      if (reason != null && reason!.isNotEmpty) "reason": reason,
    };
  }
}
