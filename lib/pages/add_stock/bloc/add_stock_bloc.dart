import 'dart:async';

import 'package:arena/models/enums/role.dart';
import 'package:arena/models/metadata/dropdown_item_model.dart';
import 'package:arena/models/widgets/stock_item_model.dart';
import 'package:arena/pages/add_stock/bloc/add_stock_event.dart';
import 'package:arena/pages/add_stock/bloc/add_stock_state.dart';
import 'package:arena/repositories/product/product_repository.dart';
import 'package:arena/repositories/stock/stock_repository.dart';
import 'package:arena/services/auth/user_session.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _ProductOption {
  final String displayName;
  final String ukuran;
  final String ring;
  final String productId;

  _ProductOption({
    required this.displayName,
    required this.ukuran,
    required this.ring,
    required this.productId,
  });
}

class AddStockBloc extends Bloc<AddStockEvent, AddStockState> {
  final ProductRepository productRepository;
  final StockRepository stockRepository;

  List<_ProductOption> _options = [];
  int _productNamePage = 1;
  int _productNameTotalPages = 1;
  String _productNameSearch = '';
  Timer? _searchDebounce;

  AddStockBloc({required this.productRepository, required this.stockRepository})
    : super(const AddStockState()) {
    on<InitializeAddStock>(_onInitializeAddStock);
    on<LoadProductNames>(_onLoadProductNames);
    on<LoadMoreProductNames>(_onLoadMoreProductNames);
    on<SearchProductNames>(_onSearchProductNames);
    on<ProductSelected>(_onProductSelected);
    on<SizeSelected>(_onSizeSelected);
    on<RingSelected>(_onRingSelected);
    on<NoteChanged>(_onNoteChanged);
    on<DotAdded>(_onDotAdded);
    on<DotUpdated>(_onDotUpdated);
    on<DotRemoved>(_onDotRemoved);
    on<SaveStockItem>(_onSaveStockItem);
    on<EditStockItem>(_onEditStockItem);
    on<DiscardCurrentItem>(_onDiscardCurrentItem);
    on<RemoveStockItems>(_onRemoveStockItems);
    on<SubmitPressed>(_onSubmitPressed);
    on<LoadExistingStock>(_onLoadExistingStock);
    on<ResetAddStock>(_onResetAddStock);
  }

  void _onInitializeAddStock(
    InitializeAddStock event,
    Emitter<AddStockState> emit,
  ) {
    add(LoadProductNames());
  }

  Future<void> _onLoadProductNames(
    LoadProductNames event,
    Emitter<AddStockState> emit,
  ) async {
    emit(state.copyWith(status: AddStockStatus.loading));

    try {
      final response = await productRepository.getProducts(
        page: 1,
        limit: 20,
        search: _productNameSearch.isEmpty ? null : _productNameSearch,
      );

      _options = _buildOptions(response.data ?? []);
      _productNamePage = 1;
      _productNameTotalPages = response.meta?.totalPages?.toInt() ?? 1;

      final nameDropdown = _buildNameDropdown(_options);

      emit(
        state.copyWith(
          status: AddStockStatus.ready,
          productNames: nameDropdown,
          productNamePage: _productNamePage,
          productNameTotalPages: _productNameTotalPages,
          isLoadingMoreProductNames: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AddStockStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadMoreProductNames(
    LoadMoreProductNames event,
    Emitter<AddStockState> emit,
  ) async {
    if (state.isLoadingMoreProductNames ||
        _productNamePage >= _productNameTotalPages) {
      return;
    }

    emit(state.copyWith(isLoadingMoreProductNames: true));

    try {
      final nextPage = _productNamePage + 1;
      final response = await productRepository.getProducts(
        page: nextPage,
        limit: 20,
        search: _productNameSearch.isEmpty ? null : _productNameSearch,
      );

      _options.addAll(_buildOptions(response.data ?? []));
      _options = _dedupeOptions(_options);
      _productNamePage = nextPage;
      _productNameTotalPages = response.meta?.totalPages?.toInt() ??
          _productNameTotalPages;

      emit(
        state.copyWith(
          status: AddStockStatus.ready,
          productNames: _buildNameDropdown(_options),
          productNamePage: _productNamePage,
          productNameTotalPages: _productNameTotalPages,
          isLoadingMoreProductNames: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AddStockStatus.ready,
          isLoadingMoreProductNames: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSearchProductNames(
    SearchProductNames event,
    Emitter<AddStockState> emit,
  ) async {
    _searchDebounce?.cancel();
    if (event.query.trim() == _productNameSearch) return;
    _searchDebounce = Timer(const Duration(milliseconds: 400), () async {
      if (!isClosed) {
        _productNameSearch = event.query.trim();
        add(LoadProductNames());
      }
    });
  }

  List<_ProductOption> _buildOptions(List<dynamic> data) {
    return [
      for (final brand in data)
        for (final model in brand.models)
          for (final variant in model.variants)
            if ((variant.size?.isNotEmpty ?? false) &&
                (variant.ring?.isNotEmpty ?? false))
              _ProductOption(
                displayName: model.displayModelName,
                ukuran: variant.size!,
                ring: variant.ring!,
                productId: variant.productId,
              ),
    ];
  }

  List<_ProductOption> _dedupeOptions(List<_ProductOption> options) {
    final seen = <String>{};
    return [
      for (final option in options)
        if (seen.add(
          '${option.displayName}|${option.ukuran}|${option.ring}|${option.productId}',
        ))
          option,
    ];
  }

  List<DropdownItemModel> _buildNameDropdown(List<_ProductOption> options) {
    final names = options.map((e) => e.displayName).toSet().toList()..sort();

    return names
        .asMap()
        .entries
        .map((e) => DropdownItemModel(id: e.key + 1, name: e.value))
        .toList();
  }

  List<DropdownItemModel> _sizesFor(String productName) {
    final sizes = _options
        .where((e) => e.displayName == productName)
        .map((e) => e.ukuran)
        .toSet()
        .toList();

    return sizes
        .asMap()
        .entries
        .map((e) => DropdownItemModel(id: e.key + 1, name: e.value))
        .toList();
  }

  List<DropdownItemModel> _ringsFor(String productName, String ukuran) {
    final rings = _options
        .where((e) => e.displayName == productName && e.ukuran == ukuran)
        .map((e) => e.ring)
        .toSet()
        .toList();

    return rings
        .asMap()
        .entries
        .map((e) => DropdownItemModel(id: e.key + 1, name: e.value))
        .toList();
  }

  void _onProductSelected(ProductSelected event, Emitter<AddStockState> emit) {
    final sizeDropdown = _sizesFor(event.productName);

    emit(
      state.copyWith(
        selectedProductName: event.productName,
        productSize: sizeDropdown,
        productRing: const [],
        selectedSize: '',
        selectedRing: '',
      ),
    );
  }

  void _onSizeSelected(SizeSelected event, Emitter<AddStockState> emit) {
    final ringDropdown = _ringsFor(state.selectedProductName, event.size);

    emit(
      state.copyWith(
        selectedSize: event.size,
        productRing: ringDropdown,
        selectedRing: '',
      ),
    );
  }

  void _onRingSelected(RingSelected event, Emitter<AddStockState> emit) {
    emit(state.copyWith(selectedRing: event.ring));
  }

  void _onNoteChanged(NoteChanged event, Emitter<AddStockState> emit) {
    emit(state.copyWith(note: event.note));
  }

  void _onDotAdded(DotAdded event, Emitter<AddStockState> emit) {
    emit(state.copyWith(dots: [...state.dots, event.dot]));
  }

  void _onDotUpdated(DotUpdated event, Emitter<AddStockState> emit) {
    if (event.index < 0 || event.index >= state.dots.length) return;

    final dots = [...state.dots];
    dots[event.index] = event.dot;

    emit(state.copyWith(dots: dots));
  }

  void _onDotRemoved(DotRemoved event, Emitter<AddStockState> emit) {
    final dots = [...state.dots];
    dots.removeAt(event.index);

    emit(state.copyWith(dots: dots));
  }

  void _onSaveStockItem(SaveStockItem event, Emitter<AddStockState> emit) {
    final id =
        state.editingItemId ?? DateTime.now().microsecondsSinceEpoch.toString();

    final newItem = StockItemModel(
      id: id,
      productName: state.selectedProductName,
      size: state.selectedSize,
      ring: state.selectedRing,
      note: state.note,
      dots: state.dots,
    );

    final items = [...state.stockItems];
    final existingIndex = items.indexWhere((e) => e.id == id);

    if (existingIndex != -1) {
      items[existingIndex] = newItem;
    } else {
      items.add(newItem);
    }

    emit(
      state.copyWith(
        stockItems: items,
        selectedProductName: '',
        selectedSize: '',
        selectedRing: '',
        note: '',
        dots: const [],
        productSize: const [],
        productRing: const [],
        editingItemId: null,
      ),
    );
  }

  void _onEditStockItem(EditStockItem event, Emitter<AddStockState> emit) {
    final item = state.stockItems.firstWhere((e) => e.id == event.id);

    emit(
      state.copyWith(
        selectedProductName: item.productName,
        selectedSize: item.size,
        selectedRing: item.ring,
        note: item.note,
        dots: item.dots,
        productSize: _sizesFor(item.productName),
        productRing: _ringsFor(item.productName, item.size),
        editingItemId: item.id,
      ),
    );
  }

  void _onDiscardCurrentItem(
    DiscardCurrentItem event,
    Emitter<AddStockState> emit,
  ) {
    emit(
      state.copyWith(
        selectedProductName: '',
        selectedSize: '',
        selectedRing: '',
        note: '',
        dots: const [],
        productSize: const [],
        productRing: const [],
        editingItemId: null,
      ),
    );
  }

  void _onRemoveStockItems(
    RemoveStockItems event,
    Emitter<AddStockState> emit,
  ) {
    final items = state.stockItems
        .where((e) => !event.ids.contains(e.id))
        .toList();

    emit(state.copyWith(stockItems: items));
  }

  String? _resolveProductId(String productName, String ukuran, String ring) {
    try {
      final match = _options.firstWhere(
        (e) =>
            e.displayName == productName &&
            e.ukuran == ukuran &&
            e.ring == ring,
      );

      return match.productId;
    } catch (_) {
      return null;
    }
  }

  Future<void> _onSubmitPressed(
    SubmitPressed event,
    Emitter<AddStockState> emit,
  ) async {
    emit(state.copyWith(status: AddStockStatus.submitting, errorMessage: null));

    try {
      for (final item in state.stockItems) {
        final productId = _resolveProductId(
          item.productName,
          item.size,
          item.ring,
        );

        if (productId == null) {
          throw Exception(
            "Kombinasi produk untuk '${item.productName}' tidak ditemukan",
          );
        }

        final userRole = await UserSession.getOrFetchRole();

        final stockBatches = item.dots.map((dot) {
          final batchMap = <String, dynamic>{
            "batch_code": dot.kode,
            "quantity": dot.jumlah,
          };

          if (userRole != Role.warehouseStaff) {
            batchMap["buy_price"] = dot.hargaBeli;
            batchMap["sell_price"] = dot.hargaJual;
          }

          return batchMap;
        }).toList();

        await stockRepository.addStock(
          productId: productId,
          note: item.note,
          stockBatches: stockBatches,
        );
      }

      emit(state.copyWith(status: AddStockStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: AddStockStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onLoadExistingStock(
    LoadExistingStock event,
    Emitter<AddStockState> emit,
  ) {
    final productName = _options
        .map((e) => e.displayName)
        .firstWhere(
          (name) => name.toLowerCase() == event.productName.toLowerCase(),
          orElse: () => event.productName,
        );

    emit(
      state.copyWith(
        selectedProductName: productName,
        productSize: _sizesFor(productName),
        selectedSize: event.size,
        productRing: _ringsFor(productName, event.size),
        selectedRing: event.ring,
        note: event.note,
        dots: event.dots,
      ),
    );
  }

  void _onResetAddStock(ResetAddStock event, Emitter<AddStockState> emit) {
    _searchDebounce?.cancel();
    emit(const AddStockState());
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
