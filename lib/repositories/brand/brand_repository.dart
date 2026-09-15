import 'package:arena/models/brand/brand_list_model.dart';
import 'package:arena/services/brand/brand_service.dart';

class BrandRepository {
  final BrandService _service;

  BrandRepository({BrandService? service})
      : _service = service ?? BrandService();

  Future<BrandListModel> getBrands({
    String? search,
    int page = 1,
    int limit = 20,
  }) =>
      _service.getBrands(search: search, page: page, limit: limit);

  Future<void> addBrand(String name) => _service.addBrand(name);

  Future<void> updateBrandName(int id, String name) =>
      _service.updateBrandName(id, name);

  Future<void> deleteBrand(int id) => _service.deleteBrand(id);
}
