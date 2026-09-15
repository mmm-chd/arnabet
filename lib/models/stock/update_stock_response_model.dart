class UpdateStockResponseModel {
  final bool? success;
  final String? message;
  final UpdateStockData? data;

  UpdateStockResponseModel({this.success, this.message, this.data});

  factory UpdateStockResponseModel.fromJson(Map<String, dynamic> json) =>
      UpdateStockResponseModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] != null
            ? UpdateStockData.fromJson(json["data"])
            : null,
      );
}

class UpdateStockData {
  final String? id;
  final String? batchCode;
  final int? quantity;
  final int? buyPrice;
  final int? sellPrice;

  UpdateStockData({
    this.id,
    this.batchCode,
    this.quantity,
    this.buyPrice,
    this.sellPrice,
  });

  factory UpdateStockData.fromJson(Map<String, dynamic> json) =>
      UpdateStockData(
        id: json["id"],
        batchCode: json["batch_code"],
        quantity: json["quantity"],
        buyPrice: json["buy_price"],
        sellPrice: json["sell_price"],
      );
}
