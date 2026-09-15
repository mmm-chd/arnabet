import 'package:arena/models/product/product_list_model.dart';
import 'package:equatable/equatable.dart';

enum ProductStatus { initial, loading, ready, submitting, success, failure }

class ProductListState extends Equatable {
  final ProductStatus status;

  final List<ProductListDatum> products;

  final int page;
  final int totalPages;

  final bool isLoadingMore;

  final String? errorMessage;

  final String? selectedBrand;
  final String? search;

  final List<String> brandNames;

  const ProductListState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.page = 1,
    this.totalPages = 1,
    this.isLoadingMore = false,
    this.errorMessage,
    this.selectedBrand,
    this.search,
    this.brandNames = const [],
  });

  @override
  List<Object?> get props => [
    status,
    products,
    page,
    totalPages,
    isLoadingMore,
    errorMessage,
    selectedBrand,
    search,
    brandNames,
  ];

  ProductListState copyWith({
    int? page,
    int? totalPages,
    bool? isLoadingMore,
    ProductStatus? status,
    List<ProductListDatum>? products,
    Object? errorMessage = _sentinel,
    Object? selectedBrand = _sentinel,
    Object? search = _sentinel,
    List<String>? brandNames,
  }) {
    return ProductListState(
      status: status ?? this.status,
      products: List.unmodifiable(products ?? this.products),

      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,

      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,

      selectedBrand: identical(selectedBrand, _sentinel)
          ? this.selectedBrand
          : selectedBrand as String?,

      search: identical(search, _sentinel) ? this.search : search as String?,

      brandNames: brandNames ?? this.brandNames,
    );
  }

  bool get isLoading => status == ProductStatus.loading;

  bool get isReady => status == ProductStatus.ready;

  bool get isFailure => status == ProductStatus.failure;
}

const _sentinel = Object();
