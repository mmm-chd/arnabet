import 'dart:async';
import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/product/update_product_request_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class UpdateProductService {
  static const _updateProductsPath = ConstantApi.updateProducts;

  Future<void> updateProduct(
    String id,
    UpdateProductRequestModel request,
  ) async {
    try {
      final response = await Client.dio.patch(
        _updateProductsPath.replaceFirst("{id}", id),
        data: request.toJson(),
      );

      if (response.data is Map && response.data["success"] != true) {
        throw Exception(
          response.data["message"]?.toString() ?? "Gagal mengubah produk",
        );
      }
    } on DioException catch (e) {
      throw Exception(extractServerMessage(e) ?? "Gagal mengubah produk");
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
