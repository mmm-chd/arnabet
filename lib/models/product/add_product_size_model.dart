import 'dart:convert';

AddProductSizeModel addProductSizeModelFromJson(String str) => AddProductSizeModel.fromJson(json.decode(str));

String addProductSizeModelToJson(AddProductSizeModel data) => json.encode(data.toJson());

class AddProductSizeModel {
    bool? success;
    String? message;
    Data? data;

    AddProductSizeModel({
        this.success,
        this.message,
        this.data,
    });

    factory AddProductSizeModel.fromJson(Map<String, dynamic> json) => AddProductSizeModel(
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
    String? id;
    String? sku;
    String? name;
    int? sellingPrice;
    Specifications? specifications;

    Data({
        this.id,
        this.sku,
        this.name,
        this.sellingPrice,
        this.specifications,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        sku: json["sku"],
        name: json["name"],
        sellingPrice: json["selling_price"],
        specifications: json["specifications"] == null ? null : Specifications.fromJson(json["specifications"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "sku": sku,
        "name": name,
        "selling_price": sellingPrice,
        "specifications": specifications?.toJson(),
    };
}

class Specifications {
    String? ukuran;
    String? ring;

    Specifications({
        this.ukuran,
        this.ring,
    });

    factory Specifications.fromJson(Map<String, dynamic> json) => Specifications(
        ukuran: json["ukuran"],
        ring: json["ring"],
    );

    Map<String, dynamic> toJson() => {
        "ukuran": ukuran,
        "ring": ring,
    };
}