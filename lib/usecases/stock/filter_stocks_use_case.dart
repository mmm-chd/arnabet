import 'package:arena/models/stock/stock_list_model.dart';

class FilterStocksUseCase {
  List<StockListDatum> execute({
    required List<StockListDatum> allStocks,
    String? brandName,
    String? statusName,
    String keyword = '',
    String sortBy = 'expiry',
  }) {
    var result = allStocks;

    if (brandName != null && brandName.isNotEmpty) {
      result = result.where((item) => item.brandName == brandName).toList();
    }

    if (statusName != null && statusName.isNotEmpty) {
      result = result
          .where((item) => item.batchStatus?.name == statusName)
          .toList();
    }

    if (keyword.isNotEmpty) {
      final lowerKeyword = keyword.toLowerCase();
      result = result.where((item) {
        final matchesId =
            item.displayProductId.toLowerCase().contains(lowerKeyword);
        final matchesName =
            item.productName!.toLowerCase().contains(lowerKeyword);
        return matchesId || matchesName;
      }).toList();
    }

    if (sortBy == 'latest') {
      result.sort((a, b) {
        final aTime = a.updatedAt ?? a.createdAt;
        final bTime = b.updatedAt ?? b.createdAt;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });
    } else if (sortBy == 'expiry') {
      result.sort((a, b) {
        final aMinDays = a.batches?.map((b) => b.daysInStock ?? 9999).reduce((a, b) => a < b ? a : b) ?? 9999;
        final bMinDays = b.batches?.map((b) => b.daysInStock ?? 9999).reduce((a, b) => a < b ? a : b) ?? 9999;
        return aMinDays.compareTo(bMinDays);
      });
    }

    return result;
  }
}