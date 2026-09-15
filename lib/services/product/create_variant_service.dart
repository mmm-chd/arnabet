import 'dart:async';
import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/product/create_variant_request_model.dart';
import 'package:arena/models/product/create_variant_response_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class CreateVariantService {
  static const _addVariantPath = ConstantApi.addVariant;

  Future<CreateVariantResponseModel> createVariant(
    String productId,
    CreateVariantRequestModel request,
  ) async {
    try {
      final response = await Client.dio.post(
        _addVariantPath.replaceFirst("{id}", productId),
        data: request.toMap(),
      );

      final body = CreateVariantResponseModel.fromJson(response.data);

      if (body.success == true) {
        return body;
      }

      throw Exception(body.message ?? "Gagal menambah variant");
    } on DioException catch (e) {
      throw Exception(extractServerMessage(e) ?? "Gagal menambah variant");
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
