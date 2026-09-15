import 'package:arena/models/cart/cart_list_model.dart';

class BuildOrderItemsUseCase {
  List<Map<String, dynamic>> execute(CartListData data) {
    return (data.items ?? []).map((item) {
      return {
        'stock_id': item.stockId,
        'quantity': item.quantity,
        'item_type': item.itemType ?? 'PRODUCT',
        'product_name': item.productName,
        'batch_code': item.batchCode,
        'unit_price': item.unitPrice,
        'subtotal':
            item.subtotal ?? (item.unitPrice ?? 0) * (item.quantity ?? 0),
        'size': item.size ?? '-',
        'ring': item.ring ?? '-',
      };
    }).toList();
  }
}
