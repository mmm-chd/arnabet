import 'dart:async';
import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/cart/add_cart_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class UpdateCartService {
  static const _updateCartItemPath = ConstantApi.updateCartItem;
  Future<AddCartModel> updateCartItem({
    required String itemId,
    required int quantity,
  }) async {
    try {
      final response = await Client.dio.patch(
        _updateCartItemPath.replaceFirst("{id}", itemId),
        data: {"quantity": quantity},
      );

      return AddCartModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(extractServerMessage(e));
    }
  }
}
