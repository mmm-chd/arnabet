import 'package:arena/models/product/create_product_request_model.dart';
import 'package:arena/models/product/create_variant_request_model.dart';
import 'package:arena/models/product/update_product_request_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductListEvent {
  const LoadProducts();
}

class LoadMoreProducts extends ProductListEvent {
  const LoadMoreProducts();
}

class SearchProducts extends ProductListEvent {
  final String keyword;

  const SearchProducts(this.keyword);

  @override
  List<Object?> get props => [keyword];
}

class FilterByBrand extends ProductListEvent {
  final String? brandName;

  const FilterByBrand(this.brandName);

  @override
  List<Object?> get props => [brandName];
}

class CreateProduct extends ProductListEvent {
  final CreateProductRequestModel request;

  const CreateProduct(this.request);

  @override
  List<Object?> get props => [request];
}

class CreateVariants extends ProductListEvent {
  final String productId;
  final List<CreateVariantRequestModel> requests;

  const CreateVariants(this.productId, this.requests);

  @override
  List<Object?> get props => [productId, requests];
}

class UpdateProduct extends ProductListEvent {
  final String id;
  final UpdateProductRequestModel request;

  const UpdateProduct(this.id, this.request);

  @override
  List<Object?> get props => [id, request];
}

class DeleteProduct extends ProductListEvent {
  final String id;
  final String label;

  const DeleteProduct(this.id, {this.label = "produk ini"});

  @override
  List<Object?> get props => [id, label];
}
