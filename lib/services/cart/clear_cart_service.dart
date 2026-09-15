import 'dart:async';
import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/cart/add_cart_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class ClearCartService {
  static const _clearCartPath = ConstantApi.clearCart;
  Future<AddCartModel> clearCart() async {
    try {
      final response = await Client.dio.delete(_clearCartPath);

      return AddCartModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(extractServerMessage(e));
    }
  }
}
