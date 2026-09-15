import 'dart:async';
import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/product/product_list_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class GetProductsService {
  static const _productsPath = ConstantApi.products;

  Future<ProductListModel> getProducts({
    int page = 1,
    int limit = 10,
    String? brandName,
    String? search,
  }) async {
    try {
      final response = await Client.dio.get(
        _productsPath,
        queryParameters: {
          "page": page,
          "limit": limit,
          "brand_name": brandName,
          "search": search,
        },
      );

      final body = ProductListModel.fromJson(response.data);

      if (body.success == true && body.data != null) {
        return body;
      }

      throw Exception(body.message ?? "Gagal mengambil data product");
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception('Waktu koneksi habis');
      }

      if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Tidak ada koneksi internet atau server tidak dapat dijangkau',
        );
      }

      throw Exception(
        extractServerMessage(e) ?? 'Gagal mengambil data product',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
