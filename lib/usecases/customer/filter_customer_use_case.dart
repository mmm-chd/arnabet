import 'package:arena/models/customer/customer_list_model.dart';

class FilterCustomersUseCase {
  List<CustomerListDatum> execute({
    required List<CustomerListDatum> allCustomers,
    required String keyword,
  }) {
    if (keyword.isEmpty) {
      return List.from(allCustomers);
    }

    final lower = keyword.toLowerCase();

    return allCustomers.where((customer) {
      final name = customer.name?.toLowerCase() ?? '';
      final phone = customer.phone?.toLowerCase() ?? '';

      final plateMatch = (customer.vehicles ?? []).any(
        (v) => (v.plate?.toLowerCase() ?? '').contains(lower),
      );

      return name.contains(lower) || phone.contains(lower) || plateMatch;
    }).toList();
  }
}
