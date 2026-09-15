import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/jasa/jasa_list_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class JasaService {
  static const String _jasaPath = ConstantApi.services;

  Future<JasaListModel> getServices({String? search}) async {
    try {
      final response = await Client.dio.get(
        _jasaPath,
        queryParameters: search != null && search.isNotEmpty
            ? {'search': search}
            : null,
      );

      final body = JasaListModel.fromJson(response.data);

      if (body.success == true) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal memuat layanan");
      }
    } on DioException catch (e) {
      final serverMessage = extractServerMessage(e);
      throw Exception(serverMessage ?? "Gagal memuat layanan");
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<void> addService({required String name, required int price}) async {
    try {
      final response = await Client.dio.post(
        ConstantApi.addService,
        data: {"name": name, "price": price},
      );
      if (response.data is Map && response.data["success"] == true) {
        return;
      } else {
        throw Exception(response.data["message"] ?? "Gagal menambah layanan");
      }
    } on DioException catch (e) {
      final serverMessage = extractServerMessage(e);
      throw Exception(serverMessage ?? "Gagal menambah layanan");
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<void> updateService({
    required int id,
    required String name,
    required int price,
  }) async {
    try {
      final response = await Client.dio.patch(
        ConstantApi.updateService.replaceFirst("{id}", id.toString()),
        data: {"name": name, "price": price},
      );
      if (response.data is Map && response.data["success"] == true) {
        return;
      } else {
        throw Exception(response.data["message"] ?? "Gagal mengubah layanan");
      }
    } on DioException catch (e) {
      final serverMessage = extractServerMessage(e);
      throw Exception(serverMessage ?? "Gagal mengubah layanan");
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<void> deleteService({required int id}) async {
    try {
      final response = await Client.dio.delete(
        ConstantApi.deleteService.replaceFirst("{id}", id.toString()),
      );
      if (response.data is Map && response.data["success"] == true) {
        return;
      } else {
        throw Exception(response.data["message"] ?? "Gagal menghapus layanan");
      }
    } on DioException catch (e) {
      final serverMessage = extractServerMessage(e);
      throw Exception(serverMessage ?? "Gagal menghapus layanan");
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
