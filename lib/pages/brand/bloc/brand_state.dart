import 'package:arena/models/brand/brand_list_model.dart';
import 'package:equatable/equatable.dart';

enum BrandStatus { initial, loading, loadingMore, ready, failure, submitting, success }

class BrandState extends Equatable {
  final BrandStatus status;
  final List<BrandListDatum> brands;
  final String? errorMessage;
  final String searchQuery;

  final int page;
  final int limit;
  final bool hasReachedMax;

  const BrandState({
    this.status = BrandStatus.initial,
    this.brands = const [],
    this.errorMessage,
    this.searchQuery = '',
    this.page = 1,
    this.limit = 20,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [
    status,
    brands,
    errorMessage,
    searchQuery,
    page,
    limit,
    hasReachedMax,
  ];

  BrandState copyWith({
    BrandStatus? status,
    List<BrandListDatum>? brands,
    Object? errorMessage = _sentinel,
    String? searchQuery,
    int? page,
    int? limit,
    bool? hasReachedMax,
  }) {
    return BrandState(
      status: status ?? this.status,
      brands: brands ?? this.brands,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
      searchQuery: searchQuery ?? this.searchQuery,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  bool get isInitial => status == BrandStatus.initial;
  bool get isLoading => status == BrandStatus.loading;
  bool get isLoadingMore => status == BrandStatus.loadingMore;
  bool get isReady => status == BrandStatus.ready;
  bool get isFailure => status == BrandStatus.failure;
  bool get isSubmitting => status == BrandStatus.submitting;
  bool get isSuccess => status == BrandStatus.success;
  bool get isEmpty => brands.isEmpty;
}

const _sentinel = Object();
