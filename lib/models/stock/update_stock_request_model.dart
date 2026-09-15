class UpdateStockRequestModel {
  final String? batchCode;
  final int? quantity;
  final int? buyPrice;
  final int? sellPrice;
  final String? reason;

  const UpdateStockRequestModel({
    this.batchCode,
    this.quantity,
    this.buyPrice,
    this.sellPrice,
    this.reason,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (batchCode != null) map["batch_code"] = batchCode;
    if (quantity != null) map["quantity"] = quantity;
    if (buyPrice != null) map["buy_price"] = buyPrice;
    if (sellPrice != null) map["sell_price"] = sellPrice;
    if (reason != null) map["reason"] = reason;
    return map;
  }
}
