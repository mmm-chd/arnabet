import 'dart:async';
import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class DeleteProductService {
  static const _deleteProductsPath = ConstantApi.deleteProducts;

  Future<void> deleteProduct(String id, {String label = "produk ini"}) async {
    try {
      await Client.dio.delete(_deleteProductsPath.replaceFirst("{id}", id));
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception(
          "Maaf, $label tidak bisa dihapus karena masih memiliki stok yang tercatat.",
        );
      }

      throw Exception(extractServerMessage(e) ?? "Gagal menghapus $label");
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
