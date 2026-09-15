import 'package:arena/models/brand/brand_list_model.dart';
import 'package:arena/pages/brand/bloc/brand_event.dart';
import 'package:arena/pages/brand/bloc/brand_state.dart';
import 'package:arena/repositories/brand/brand_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final BrandRepository _repository;

  BrandBloc({required BrandRepository repository})
    : _repository = repository,
      super(const BrandState()) {
    on<LoadBrands>(_onLoadBrands);
    on<LoadMoreBrands>(_onLoadMoreBrands);
    on<SearchBrand>(_onSearchBrand);
    on<AddBrand>(_onAddBrand);
    on<UpdateBrand>(_onUpdateBrand);
    on<DeleteBrand>(_onDeleteBrand);
  }

  Future<void> _onLoadBrands(LoadBrands event, Emitter<BrandState> emit) async {
    emit(
      state.copyWith(
        status: BrandStatus.loading,
        searchQuery: event.search ?? state.searchQuery,
      ),
    );
    try {
      final model = await _repository.getBrands(
        search: event.search,
        page: 1,
        limit: state.limit,
      );
      final data = model.data ?? [];
      final totalPages = model.meta?.pagination?.totalPages ?? 1;
      emit(
        state.copyWith(
          status: BrandStatus.ready,
          brands: data,
          page: 1,
          hasReachedMax: 1 >= totalPages,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BrandStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  Future<void> _onLoadMoreBrands(
    LoadMoreBrands event,
    Emitter<BrandState> emit,
  ) async {
    if (!state.isReady || state.hasReachedMax || state.isLoadingMore) return;

    emit(state.copyWith(status: BrandStatus.loadingMore));
    try {
      final nextPage = state.page + 1;
      final model = await _repository.getBrands(
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
        page: nextPage,
        limit: state.limit,
      );
      final newData = model.data ?? [];
      final totalPages = model.meta?.pagination?.totalPages ?? nextPage;
      final combined = [...state.brands, ...newData].cast<BrandListDatum>();

      emit(
        state.copyWith(
          status: BrandStatus.ready,
          brands: combined,
          page: nextPage,
          hasReachedMax: nextPage >= totalPages || newData.isEmpty,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: BrandStatus.ready));
    }
  }

  Future<void> _onSearchBrand(
    SearchBrand event,
    Emitter<BrandState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.keyword));
    add(LoadBrands(search: event.keyword));
  }

  Future<void> _onAddBrand(AddBrand event, Emitter<BrandState> emit) async {
    try {
      await _repository.addBrand(event.name);
      add(LoadBrands(search: state.searchQuery.isEmpty ? null : state.searchQuery));
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
      emit(state.copyWith(errorMessage: null));
    }
  }

  Future<void> _onUpdateBrand(
    UpdateBrand event,
    Emitter<BrandState> emit,
  ) async {
    try {
      await _repository.updateBrandName(event.id, event.name);
      add(LoadBrands(search: state.searchQuery.isEmpty ? null : state.searchQuery));
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
      emit(state.copyWith(errorMessage: null));
    }
  }

  Future<void> _onDeleteBrand(
    DeleteBrand event,
    Emitter<BrandState> emit,
  ) async {
    try {
      await _repository.deleteBrand(event.id);
      add(LoadBrands(search: state.searchQuery.isEmpty ? null : state.searchQuery));
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString().replaceAll("Exception: ", ""),
        ),
      );
      emit(state.copyWith(errorMessage: null));
    }
  }
}
