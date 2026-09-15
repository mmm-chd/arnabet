import 'dart:convert';

ResetPasswordModel resetPasswordModelFromJson(String str) => ResetPasswordModel.fromJson(json.decode(str));

String resetPasswordModelToJson(ResetPasswordModel data) => json.encode(data.toJson());

class ResetPasswordModel {
    bool? success;
    String? message;
    dynamic data;

    ResetPasswordModel({
        this.success,
        this.message,
        this.data,
    });

    factory ResetPasswordModel.fromJson(Map<String, dynamic> json) => ResetPasswordModel(
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
