import 'package:arena/helper/currency_text_parser.dart';
import 'package:arena/models/product/create_variant_request_model.dart';
import 'package:flutter/material.dart';

class SizeRowData {
  final int id;
  final bool requirePrice;
  final rowKey = GlobalKey();
  final sizeFocusNode = FocusNode();
  final sizeController = TextEditingController();
  final ringController = TextEditingController();
  final sellPriceController = TextEditingController();
  final buyPriceController = TextEditingController();

  SizeRowData(this.id, {this.requirePrice = true});

  bool get isSizeFilled => sizeController.text.trim().isNotEmpty;
  bool get isRingFilled => ringController.text.trim().isNotEmpty;
  bool get isSellPriceFilled => sellPriceController.text.trim().isNotEmpty;

  bool get isValid =>
      isSizeFilled && isRingFilled && (!requirePrice || isSellPriceFilled);

  CreateVariantRequestModel toRequest() {
    return CreateVariantRequestModel(
      size: sizeController.text.trim(),
      ring: "R${ringController.text.trim()}",
      sellPrice: sellPriceController.text.trim().isEmpty
          ? null
          : sellPriceController.text.trim().toCurrencyInt(),
      buyPrice: buyPriceController.text.trim().isEmpty
          ? null
          : buyPriceController.text.trim().toCurrencyInt(),
    );
  }

  void addListener(VoidCallback listener) {
    sizeController.addListener(listener);
    ringController.addListener(listener);
    sellPriceController.addListener(listener);
  }

  void dispose() {
    sizeFocusNode.dispose();
    sizeController.dispose();
    ringController.dispose();
    sellPriceController.dispose();
    buyPriceController.dispose();
  }
}
