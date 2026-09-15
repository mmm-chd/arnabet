import 'package:arena/models/customer/customer_list_model.dart';
import 'package:arena/services/customer/customer_service.dart';

class CustomerRepository {
  final CustomerService _customerListService;

  CustomerRepository({CustomerService? customerListService})
    : _customerListService = customerListService ?? CustomerService();

  Future<CustomerListModel> getCustomers({
    String search = "",
    int page = 1,
    int limit = 10,
  }) {
    return _customerListService.getCustomers(
      search: search,
      page: page,
      limit: limit,
    );
  }
}
