import 'package:arena/models/product/create_product_request_model.dart';
import 'package:arena/models/product/create_variant_request_model.dart';
import 'package:arena/models/product/create_product_response_model.dart';
import 'package:arena/models/product/product_list_model.dart';
import 'package:arena/models/product/update_product_request_model.dart';
import 'package:arena/services/product/create_product_service.dart';
import 'package:arena/services/product/create_variant_service.dart';
import 'package:arena/services/product/delete_product_service.dart';
import 'package:arena/services/product/get_products_service.dart';
import 'package:arena/services/product/update_product_service.dart';

class ProductRepository {
  final GetProductsService _getProductsService;
  final CreateProductService _createProductService;
  final CreateVariantService _createVariantService;
  final UpdateProductService _updateProductService;
  final DeleteProductService _deleteProductService;

  ProductRepository({
    GetProductsService? getProductsService,
    CreateProductService? createProductService,
    CreateVariantService? createVariantService,
    UpdateProductService? updateProductService,
    DeleteProductService? deleteProductService,
  }) : _getProductsService = getProductsService ?? GetProductsService(),
       _createProductService = createProductService ?? CreateProductService(),
       _createVariantService = createVariantService ?? CreateVariantService(),
       _updateProductService = updateProductService ?? UpdateProductService(),
       _deleteProductService = deleteProductService ?? DeleteProductService();

  Future<ProductListModel> getProducts({
    int page = 1,
    int limit = 10,
    String? brandName,
    String? search,
  }) {
    return _getProductsService.getProducts(
      page: page,
      limit: limit,
      brandName: brandName,
      search: search,
    );
  }

  Future<CreateProductResponseModel> createProduct(
    CreateProductRequestModel request,
  ) {
    return _createProductService.createProduct(request);
  }

  Future<void> createVariant(
    String productId,
    CreateVariantRequestModel request,
  ) {
    return _createVariantService.createVariant(productId, request);
  }

  Future<void> createVariants(
    String productId,
    List<CreateVariantRequestModel> requests,
  ) async {
    for (final request in requests) {
      await _createVariantService.createVariant(productId, request);
    }
  }

  Future<void> updateProduct(String id, UpdateProductRequestModel request) {
    return _updateProductService.updateProduct(id, request);
  }

  Future<void> deleteProduct(String id, {String label = "produk ini"}) {
    return _deleteProductService.deleteProduct(id, label: label);
  }
}
