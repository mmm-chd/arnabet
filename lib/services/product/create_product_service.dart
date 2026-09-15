import 'dart:async';
import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/product/create_product_request_model.dart';
import 'package:arena/models/product/create_product_response_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class CreateProductService {
  static const _addProductsPath = ConstantApi.addProducts;

  Future<CreateProductResponseModel> createProduct(
    CreateProductRequestModel request,
  ) async {
    try {
      final response = await Client.dio.post(
        _addProductsPath,
        data: request.toMap(),
      );

      final body = CreateProductResponseModel.fromJson(response.data);

      if (body.success == true) {
        return body;
      }

      throw Exception(body.message ?? "Gagal menambah product");
    } on DioException catch (e) {
      throw Exception(extractServerMessage(e) ?? "Gagal menambah product");
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
