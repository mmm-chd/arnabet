import 'package:arena/repositories/customer/customer_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'customer_event.dart';
import 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository _repository;

  CustomerBloc({required CustomerRepository repository})
    : _repository = repository,
      super(const CustomerState()) {
    on<LoadCustomer>(_onLoadCustomer);
    on<SearchCustomer>(_onSearchCustomer);
    on<LoadMoreCustomer>(_onLoadMoreCustomer);
  }

  Future<void> _onLoadCustomer(
    LoadCustomer event,
    Emitter<CustomerState> emit,
  ) => _fetchFirstPage(keyword: state.searchQuery, emit: emit);

  Future<void> _onSearchCustomer(
    SearchCustomer event,
    Emitter<CustomerState> emit,
  ) => _fetchFirstPage(keyword: event.keyword, emit: emit);

  Future<void> _fetchFirstPage({
    required String keyword,
    required Emitter<CustomerState> emit,
  }) async {
    emit(
      state.copyWith(
        status: CustomerStatus.loading,
        searchQuery: keyword,
        customers: const [],
        page: 1,
        hasReachedMax: false,
        errorMessage: null,
      ),
    );

    try {
      final response = await _repository.getCustomers(
        search: keyword,
        page: 1,
        limit: state.limit,
      );
      final customers = response.data ?? [];
      final totalPages = response.meta?.pagination?.totalPages ?? 1;

      emit(
        state.copyWith(
          status: CustomerStatus.ready,
          customers: customers,
          totalCustomer:
              response.meta?.pagination?.totalItems ?? customers.length,
          page: 1,
          hasReachedMax: 1 >= totalPages || customers.isEmpty,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CustomerStatus.failure,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onLoadMoreCustomer(
    LoadMoreCustomer event,
    Emitter<CustomerState> emit,
  ) async {
    if (state.hasReachedMax || !state.isReady) return;

    final nextPage = state.page + 1;
    emit(state.copyWith(status: CustomerStatus.loadingMore));

    try {
      final response = await _repository.getCustomers(
        search: state.searchQuery,
        page: nextPage,
        limit: state.limit,
      );
      final newItems = response.data ?? [];
      final totalPages = response.meta?.pagination?.totalPages ?? nextPage;

      emit(
        state.copyWith(
          status: CustomerStatus.ready,
          customers: [...state.customers, ...newItems],
          totalCustomer:
              response.meta?.pagination?.totalItems ?? state.totalCustomer,
          page: nextPage,
          hasReachedMax: nextPage >= totalPages || newItems.isEmpty,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: CustomerStatus.ready));
    }
  }
}
