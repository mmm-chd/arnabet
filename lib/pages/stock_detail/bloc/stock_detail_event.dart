import 'package:arena/models/stock/update_stock_request_model.dart';
import 'package:equatable/equatable.dart';

sealed class StockDetailEvent extends Equatable {
  const StockDetailEvent();

  @override
  List<Object?> get props => [];
}

class StockDetailFetched extends StockDetailEvent {
  final String productId;

  const StockDetailFetched({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class AdjustStockSubmitted extends StockDetailEvent {
  final String productId;
  final String stockId;
  final int newQuantity;
  final String reason;

  const AdjustStockSubmitted({
    required this.productId,
    required this.stockId,
    required this.newQuantity,
    required this.reason,
  });

  @override
  List<Object?> get props => [productId, stockId, newQuantity, reason];
}

class UpdateStockSubmitted extends StockDetailEvent {
  final String stockId;
  final String productId;
  final UpdateStockRequestModel request;

  const UpdateStockSubmitted({
    required this.stockId,
    required this.productId,
    required this.request,
  });

  @override
  List<Object?> get props => [stockId, productId, request];
}