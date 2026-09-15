import 'dart:async';
import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/cart/add_cart_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class DeleteCartItemService {
  static const _deleteCartItemPath = ConstantApi.deleteCartItem;
  Future<AddCartModel> deleteCartItem({required String itemId}) async {
    try {
      final response = await Client.dio.delete(
        _deleteCartItemPath.replaceFirst("{id}", itemId),
      );

      return AddCartModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(extractServerMessage(e));
    }
  }
}
