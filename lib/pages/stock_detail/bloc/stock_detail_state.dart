import 'package:arena/models/stock/stock_detail_model.dart';
import 'package:equatable/equatable.dart';

enum StockDetailStatus { initial, loading, ready, failure }

class StockDetailState extends Equatable {
  final StockDetailStatus status;
  final StockDetailData? stock;
  final String? errorMessage;
  final bool isAdjusting;
  final String? adjustSuccessMessage;
  final bool isUpdating;
  final String? updateSuccessMessage;

  const StockDetailState({
    this.status = StockDetailStatus.initial,
    this.stock,
    this.errorMessage,
    this.isAdjusting = false,
    this.adjustSuccessMessage,
    this.isUpdating = false,
    this.updateSuccessMessage,
  });

  @override
  List<Object?> get props => [
    status,
    stock,
    errorMessage,
    isAdjusting,
    adjustSuccessMessage,
    isUpdating,
    updateSuccessMessage,
  ];

  StockDetailState copyWith({
    StockDetailStatus? status,
    StockDetailData? stock,
    Object? errorMessage = _sentinel,
    bool? isAdjusting,
    Object? adjustSuccessMessage = _sentinel,
    bool? isUpdating,
    Object? updateSuccessMessage = _sentinel,
  }) {
    return StockDetailState(
      status: status ?? this.status,
      stock: stock ?? this.stock,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
      isAdjusting: isAdjusting ?? this.isAdjusting,
      adjustSuccessMessage: identical(adjustSuccessMessage, _sentinel)
          ? this.adjustSuccessMessage
          : adjustSuccessMessage as String?,
      isUpdating: isUpdating ?? this.isUpdating,
      updateSuccessMessage: identical(updateSuccessMessage, _sentinel)
          ? this.updateSuccessMessage
          : updateSuccessMessage as String?,
    );
  }

  bool get isInitial => status == StockDetailStatus.initial;
  bool get isLoading => status == StockDetailStatus.loading;
  bool get isReady => status == StockDetailStatus.ready;
  bool get isFailure => status == StockDetailStatus.failure;

  List<StockDetailBatch> get batches => stock?.batches ?? const [];
  bool get hasBatches => batches.isNotEmpty;
}

const _sentinel = Object();