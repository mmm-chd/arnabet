import 'dart:convert';

import 'package:arena/helper/safe_helpers.dart';

RequestResetModel requestResetModelFromJson(String str) => RequestResetModel.fromJson(json.decode(str));

String requestResetModelToJson(RequestResetModel data) => json.encode(data.toJson());

class RequestResetModel {
    bool? success;
    String? message;
    dynamic data;

    // Display Getters
    String get displayMessage => safeString(message);

    RequestResetModel({
        this.success,
        this.message,
        this.data,
    });

    factory RequestResetModel.fromJson(Map<String, dynamic> json) => RequestResetModel(
        success: json["success"],
        message: json["message"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data,
    };
}
