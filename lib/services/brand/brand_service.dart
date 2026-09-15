import 'dart:async';
import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/brand/brand_list_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class BrandService {
  static const _brandsPath = ConstantApi.brands;

  Future<BrandListModel> getBrands({
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{"page": page, "limit": limit};
      if (search != null && search.isNotEmpty) {
        queryParams["search"] = search;
      }
      final response = await Client.dio.get(
        _brandsPath,
        queryParameters: queryParams,
      );
      final body = BrandListModel.fromJson(response.data);
      if (body.success == true) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal memuat brand");
      }
    } on DioException catch (e) {
      final serverMessage = extractServerMessage(e);
      throw Exception(serverMessage ?? "Gagal memuat brand");
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<void> addBrand(String name) async {
    try {
      final response = await Client.dio.post(
        ConstantApi.addBrand,
        data: {"name": name},
      );
      if (response.data is Map && response.data["success"] == true) {
        return;
      } else {
        throw Exception(response.data["message"] ?? "Gagal menambah brand");
      }
    } on DioException catch (e) {
      final serverMessage = extractServerMessage(e);
      throw Exception(serverMessage ?? "Gagal menambah brand");
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<void> updateBrandName(int id, String name) async {
    try {
      final response = await Client.dio.patch(
        ConstantApi.updateBrandName.replaceFirst("{id}", id.toString()),
        data: {"name": name},
      );
      if (response.data is Map && response.data["success"] == true) {
        return;
      } else {
        throw Exception(response.data["message"] ?? "Gagal mengubah brand");
      }
    } on DioException catch (e) {
      final serverMessage = extractServerMessage(e);
      throw Exception(serverMessage ?? "Gagal mengubah brand");
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<void> deleteBrand(int id) async {
    try {
      final response = await Client.dio.delete(
        ConstantApi.deleteBrand.replaceFirst("{id}", id.toString()),
      );
      if (response.data is Map && response.data["success"] == true) {
        return;
      } else {
        throw Exception(response.data["message"] ?? "Gagal menghapus brand");
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception("Brand tidak dapat dihapus karena masih digunakan.");
      }
      final serverMessage = extractServerMessage(e);
      throw Exception(serverMessage ?? "Gagal menghapus brand");
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
