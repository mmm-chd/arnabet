import 'package:arena/models/product/product_list_model.dart';
import 'package:arena/repositories/product/product_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_list_event.dart';
import 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final ProductRepository _repository;

  List<ProductListDatum> allProducts = [];

  int _requestToken = 0;

  ProductListBloc({required ProductRepository repository})
    : _repository = repository,
      super(const ProductListState()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<SearchProducts>(_onSearchProducts);
    on<FilterByBrand>(_onFilterByBrand);
    on<CreateProduct>(_onCreateProduct);
    on<CreateVariants>(_onCreateVariants);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductListState> emit,
  ) async {
    await _fetchFirstPage(
      emit,
      search: state.search,
      brandName: state.selectedBrand,
    );
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductListState> emit,
  ) async {
    final keyword = event.keyword.trim();

    await _fetchFirstPage(
      emit,
      search: keyword.isEmpty ? null : keyword,
      brandName: state.selectedBrand,
    );
  }

  Future<void> _onFilterByBrand(
    FilterByBrand event,
    Emitter<ProductListState> emit,
  ) async {
    await _fetchFirstPage(
      emit,
      search: state.search,
      brandName: event.brandName,
    );
  }

  Future<void> _fetchFirstPage(
    Emitter<ProductListState> emit, {
    required String? search,
    required String? brandName,
  }) async {
    final token = ++_requestToken;

    emit(
      state.copyWith(
        status: ProductStatus.loading,
        errorMessage: null,
        search: search,
        selectedBrand: brandName,
      ),
    );

    try {
      final response = await _repository.getProducts(
        page: 1,
        limit: 10,
        search: search,
        brandName: brandName,
      );

      if (token != _requestToken) return;

      allProducts = response.data ?? [];

      emit(
        state.copyWith(
          status: ProductStatus.ready,
          products: allProducts,
          page: response.meta?.page ?? 1,
          totalPages: response.meta?.totalPages ?? 1,
          // Server hanya mengembalikan brand yang cocok dengan query, jadi
          // daftar chip cuma boleh di-refresh saat hasilnya belum tersaring.
          brandNames: (search == null && brandName == null)
              ? _extractBrandNames(allProducts)
              : null,
        ),
      );
    } catch (e) {
      if (token != _requestToken) return;

      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  List<String> _extractBrandNames(List<ProductListDatum> data) {
    return data
        .map((d) => d.displayBrandName)
        .where((n) => n.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProducts event,
    Emitter<ProductListState> emit,
  ) async {
    if (state.isLoadingMore) return;

    if (state.page >= state.totalPages) return;

    final token = _requestToken;

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.page + 1;

    try {
      final response = await _repository.getProducts(
        page: nextPage,
        limit: 10,
        search: state.search,
        brandName: state.selectedBrand,
      );

      if (token != _requestToken) return;

      allProducts.addAll(response.data ?? []);

      emit(
        state.copyWith(
          status: ProductStatus.ready,
          products: allProducts,
          page: response.meta?.page ?? nextPage,
          totalPages: response.meta?.totalPages ?? state.totalPages,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      if (token != _requestToken) return;

      emit(
        state.copyWith(
          isLoadingMore: false,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<ProductListState> emit,
  ) async {
    try {
      await _repository.deleteProduct(event.id, label: event.label);

      add(const LoadProducts());
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );

      emit(state.copyWith(errorMessage: null));
    }
  }

  Future<void> _onCreateVariants(
    CreateVariants event,
    Emitter<ProductListState> emit,
  ) async {
    emit(state.copyWith(status: ProductStatus.loading));

    try {
      await _repository.createVariants(event.productId, event.requests);

      add(const LoadProducts());
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<ProductListState> emit,
  ) async {

    emit(state.copyWith(status: ProductStatus.loading));

    try {
      await _repository.updateProduct(event.id, event.request);

      add(const LoadProducts());
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onCreateProduct(
    CreateProduct event,
    Emitter<ProductListState> emit,
  ) async {
    emit(state.copyWith(status: ProductStatus.loading));

    try {
      await _repository.createProduct(event.request);

      add(const LoadProducts());
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }
}
