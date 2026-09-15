import 'dart:convert';

import 'package:arena/helper/safe_helpers.dart';

AddStockModel addStockModelFromJson(String str) =>
    AddStockModel.fromJson(json.decode(str));

String addStockModelToJson(AddStockModel data) => json.encode(data.toJson());

class AddStockModel {
  bool? success;
  String? message;
  Data? data;

  // Display Getters
  String get displayMessage => safeString(message);

  AddStockModel({this.success, this.message, this.data});

  factory AddStockModel.fromJson(Map<String, dynamic> json) => AddStockModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  int? batchesAdded;

  // Display Getters
  String get displayBatchesAdded => safeString(batchesAdded);

  Data({this.batchesAdded});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(batchesAdded: json["batches_added"]);

  Map<String, dynamic> toJson() => {"batches_added": batchesAdded};
}
