import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/models/dot_model.dart';
import 'package:arena/models/metadata/dropdown_item_model.dart';
import 'package:arena/models/widgets/stock_item_model.dart';
import 'package:equatable/equatable.dart';

enum AddStockStatus { initial, loading, ready, submitting, success, failure }

class AddStockState extends Equatable {
  final AddStockStatus status;

  final List<StockItemModel> stockItems;

  final List<DotModel> dots;
  final String? editingItemId;

  final List<DropdownItemModel> productNames;
  final List<DropdownItemModel> productSize;
  final List<DropdownItemModel> productRing;

  final int productNamePage;
  final int productNameTotalPages;
  final bool isLoadingMoreProductNames;

  final String selectedProductName;
  final String selectedSize;
  final String selectedRing;
  final String note;

  final String? errorMessage;

  const AddStockState({
    this.status = AddStockStatus.initial,
    this.stockItems = const [],
    this.dots = const [],
    this.editingItemId,
    this.productNames = const [],
    this.productSize = const [],
    this.productRing = const [],
    this.productNamePage = 1,
    this.productNameTotalPages = 1,
    this.isLoadingMoreProductNames = false,
    this.selectedProductName = '',
    this.selectedSize = '',
    this.selectedRing = '',
    this.note = '',
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    status,
    stockItems,
    dots,
    editingItemId,
    productNames,
    productSize,
    productRing,
    productNamePage,
    productNameTotalPages,
    isLoadingMoreProductNames,
    selectedProductName,
    selectedSize,
    selectedRing,
    note,
    errorMessage,
  ];

  AddStockState copyWith({
    AddStockStatus? status,
    List<StockItemModel>? stockItems,
    List<DotModel>? dots,
    Object? editingItemId = _sentinel,
    List<DropdownItemModel>? productNames,
    List<DropdownItemModel>? productSize,
    List<DropdownItemModel>? productRing,
    int? productNamePage,
    int? productNameTotalPages,
    bool? isLoadingMoreProductNames,
    String? selectedProductName,
    String? selectedSize,
    String? selectedRing,
    String? note,
    Object? errorMessage = _sentinel,
  }) {
    return AddStockState(
      status: status ?? this.status,
      stockItems: List.unmodifiable(stockItems ?? this.stockItems),
      dots: List.unmodifiable(dots ?? this.dots),
      editingItemId: identical(editingItemId, _sentinel)
          ? this.editingItemId
          : editingItemId as String?,
      productNames: List.unmodifiable(productNames ?? this.productNames),
      productSize: List.unmodifiable(productSize ?? this.productSize),
      productRing: List.unmodifiable(productRing ?? this.productRing),
      productNamePage: productNamePage ?? this.productNamePage,
      productNameTotalPages:
          productNameTotalPages ?? this.productNameTotalPages,
      isLoadingMoreProductNames:
          isLoadingMoreProductNames ?? this.isLoadingMoreProductNames,
      selectedProductName: selectedProductName ?? this.selectedProductName,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedRing: selectedRing ?? this.selectedRing,
      note: note ?? this.note,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  bool get isLoading => status == AddStockStatus.loading;
  bool get isSubmitting => status == AddStockStatus.submitting;
  bool get isFailure => status == AddStockStatus.failure;
  bool get isSuccess => status == AddStockStatus.success;

  bool get isFormDirty =>
      selectedProductName.isNotEmpty ||
      selectedSize.isNotEmpty ||
      selectedRing.isNotEmpty ||
      dots.isNotEmpty ||
      totalPcs > 0;

  bool get isFormFilled =>
      selectedProductName.isNotEmpty &&
      selectedSize.isNotEmpty &&
      selectedRing.isNotEmpty &&
      dots.isNotEmpty &&
      totalPcs > 0;

  bool get hasStockItems => stockItems.isNotEmpty;

  int get totalPcs => dots.fold(0, (sum, e) => sum + e.jumlah);

  int get totalHargaBeli =>
      dots.fold(0, (sum, e) => sum + (e.jumlah * (e.hargaBeli ?? 0)));

  int get totalHargaJual =>
      dots.fold(0, (sum, e) => sum + (e.jumlah * (e.hargaJual ?? 0)));

  String get displayTotalPcs => totalPcs.toString();

  String get displayTotalHargaBeli => totalHargaBeli.toLocaleCurrency();
  String get displayTotalHargaJual => totalHargaJual.toLocaleCurrency();

  String get displayHargaBeli =>
      dots.fold(0, (sum, e) => sum + e.hargaBeli!).toLocaleCurrency();

  String get displayTotalBatch => dots.length.toString();
}

const _sentinel = Object();
