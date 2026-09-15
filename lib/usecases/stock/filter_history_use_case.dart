import 'package:arena/models/enums/enums.dart';
import 'package:arena/models/stock/stock_history_model.dart';

class FilterHistoryUseCase {
  List<StockHistoryDatum> execute({
    required List<StockHistoryDatum> all,
    required String filter,
    required String query,
  }) {
    List<StockHistoryDatum> result = List.from(all);

    if (filter.isNotEmpty && filter.toLowerCase() != 'semua') {
      result = result
          .where((item) => item.type?.matchesFilterLabel(filter) ?? false)
          .toList();
    }

    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      result = result.where((item) {
        final productName = item.displayProductName.toLowerCase();
        final referenceType = item.displayReferenceType.toLowerCase();
        final type = item.displayType.toLowerCase();
        final userName = item.displayUserName.toLowerCase();

        return productName.contains(lowerQuery) ||
            referenceType.contains(lowerQuery) ||
            type.contains(lowerQuery) ||
            userName.contains(lowerQuery);
      }).toList();
    }

    return result;
  }
}
