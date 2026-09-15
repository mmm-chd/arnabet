abstract class StockEvent {}

class LoadStock extends StockEvent {
  final String? brandName;
  final String? sortBy;

  LoadStock({this.brandName, this.sortBy});
}

class LoadMoreStocks extends StockEvent {}

class LoadDotStatusRules extends StockEvent {}

class UpdateDotStatusRule extends StockEvent {
  final String id;
  final int? minMonth;
  final int? maxMonth;

  UpdateDotStatusRule({required this.id, this.minMonth, this.maxMonth});
}

class LoadStockStatusRules extends StockEvent {}

class UpdateStockStatusRule extends StockEvent {
  final String id;
  final int? minQty;
  final int? maxQty;

  UpdateStockStatusRule({required this.id, this.minQty, this.maxQty});
}

class CreateStock extends StockEvent {
  final String productId;
  final String note;
  final List<Map<String, dynamic>> stockBatches;

  CreateStock({
    required this.productId,
    required this.note,
    required this.stockBatches,
  });
}

class FilterStock extends StockEvent {
  final String? brandName;
  final String? statusName;
  final String keyword;

  FilterStock({this.brandName, this.statusName, this.keyword = ''});
}

class SearchStock extends StockEvent {
  final String keyword;

  SearchStock(this.keyword);
}

class ChangeSortBy extends StockEvent {
  final String sortBy;

  ChangeSortBy(this.sortBy);
}
