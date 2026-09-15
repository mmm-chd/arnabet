import 'dart:async';

import 'package:arena/components/bottom_sheet/custom_bottom_sheet_v2.dart';
import 'package:arena/components/build/build_label.dart';
import 'package:arena/components/build/build_searchable_dropdown.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/text_field/custom_text_field.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/helper/safe_helpers.dart';
import 'package:arena/models/enums/role.dart';
import 'package:arena/models/metadata/dropdown_item_model.dart';
import 'package:arena/models/product/create_product_request_model.dart';
import 'package:arena/models/product/product_list_model.dart';
import 'package:arena/models/product/update_product_request_model.dart';
import 'package:arena/pages/product/bloc/product_list_bloc.dart';
import 'package:arena/pages/product/bloc/product_list_event.dart';
import 'package:arena/repositories/brand/brand_repository.dart';
import 'package:arena/services/auth/user_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductSheet extends StatefulWidget {
  final ProductModel? product;
  final ProductListDatum? brand;
  final TextEditingController nameController;
  final TextEditingController reasonController;
  final ValueNotifier<DropdownItemModel?> selectedBrandNotifier;
  final ValueNotifier<String?> brandErrorNotifier;
  final ValueNotifier<String?> nameErrorNotifier;
  final ValueNotifier<String?> reasonErrorNotifier;
  final bool isWarehouse;

  const ProductSheet({
    super.key,
    this.product,
    this.brand,
    required this.nameController,
    required this.reasonController,
    required this.selectedBrandNotifier,
    required this.brandErrorNotifier,
    required this.nameErrorNotifier,
    required this.reasonErrorNotifier,
    required this.isWarehouse,
  });

  static void show(
    BuildContext context, {
    ProductModel? product,
    ProductListDatum? brand,
  }) {
    final productListBloc = context.read<ProductListBloc>();

    final nameController = TextEditingController(
      text: product?.displayModelName ?? '',
    );
    final reasonController = TextEditingController();
    final selectedBrandNotifier = ValueNotifier<DropdownItemModel?>(
      product != null && brand != null && brand.brandId != null
          ? DropdownItemModel(id: brand.brandId!, name: brand.displayBrandName)
          : null,
    );
    final canSaveNotifier = ValueNotifier<bool>(false);
    final brandErrorNotifier = ValueNotifier<String?>(null);
    final nameErrorNotifier = ValueNotifier<String?>(null);
    final reasonErrorNotifier = ValueNotifier<String?>(null);

    final isEditing = product != null;
    final userRole = UserSession.role;
    final isWarehouse = userRole == Role.warehouseStaff;

    void syncCanSave() {
      final hasName = nameController.text.trim().isNotEmpty;
      final hasBrand = selectedBrandNotifier.value != null;
      final hasReason =
          !isEditing || !isWarehouse || reasonController.text.trim().isNotEmpty;

      if (hasName) nameErrorNotifier.value = null;
      if (hasBrand) brandErrorNotifier.value = null;
      if (hasReason) reasonErrorNotifier.value = null;

      canSaveNotifier.value = hasName && hasBrand && hasReason;
    }

    nameController.addListener(syncCanSave);
    reasonController.addListener(syncCanSave);
    selectedBrandNotifier.addListener(syncCanSave);
    syncCanSave();

    CustomBottomSheetV2.show(
      context,
      title: product == null ? 'Tambah Produk' : 'Edit Produk',
      isSaveEnabled: canSaveNotifier,
      onSave: () {
        final selectedBrand = selectedBrandNotifier.value;

        if (selectedBrand == null) {
          brandErrorNotifier.value = "Pilih brand terlebih dahulu";
          AppSnackBar.warning(
            context: context,
            message: "Pilih brand terlebih dahulu",
          );

          return false;
        }

        if (nameController.text.trim().isEmpty) {
          nameErrorNotifier.value = "Nama produk tidak boleh kosong";
          AppSnackBar.warning(
            context: context,
            message: "Nama produk tidak boleh kosong",
          );

          return false;
        }

        if (isEditing && isWarehouse && reasonController.text.trim().isEmpty) {
          reasonErrorNotifier.value = "Alasan perubahan wajib diisi";
          AppSnackBar.warning(
            context: context,
            message: "Alasan perubahan wajib diisi",
          );

          return false;
        }

        final name = nameController.text.trim();
        final reason = reasonController.text.trim();

        if (product == null) {
          productListBloc.add(
            CreateProduct(
              CreateProductRequestModel(
                brandId: selectedBrand.id,
                productName: name,
              ),
            ),
          );
        } else {
          final parentId = safeString(product.productId, fallback: '');

          if (parentId.isEmpty) {
            AppSnackBar.warning(
              context: context,
              message: "Produk tidak memiliki ID untuk diubah",
            );

            return false;
          }

          productListBloc.add(
            UpdateProduct(
              parentId,
              UpdateProductRequestModel(
                name: name,
                brandId: selectedBrand.id,
                reason: isWarehouse && reason.isNotEmpty ? reason : null,
              ),
            ),
          );
        }

        return true;
      },
      onDismissed: () {
        nameController.dispose();
        reasonController.dispose();
        selectedBrandNotifier.dispose();
        canSaveNotifier.dispose();
        brandErrorNotifier.dispose();
        nameErrorNotifier.dispose();
        reasonErrorNotifier.dispose();
      },
      children: [
        BlocProvider.value(
          value: productListBloc,
          child: ProductSheet(
            product: product,
            brand: brand,
            nameController: nameController,
            reasonController: reasonController,
            selectedBrandNotifier: selectedBrandNotifier,
            brandErrorNotifier: brandErrorNotifier,
            nameErrorNotifier: nameErrorNotifier,
            reasonErrorNotifier: reasonErrorNotifier,
            isWarehouse: isWarehouse,
          ),
        ),
      ],
    );
  }

  @override
  State<ProductSheet> createState() => _ProductSheetState();
}

class _ProductSheetState extends State<ProductSheet> {
  final BrandRepository _brandRepository = BrandRepository();

  List<DropdownItemModel> _brandItems = [];
  bool _isLoadingBrand = true;
  bool _isLoadingMoreBrand = false;
  int _brandPage = 1;
  int _brandTotalPages = 1;
  String _brandSearch = '';
  Timer? _brandSearchDebounce;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _loadBrands();
  }

  @override
  void dispose() {
    _brandSearchDebounce?.cancel();
    super.dispose();
  }

  Future<void> _loadBrands({int page = 1, String? search}) async {
    if (page > 1) {
      setState(() => _isLoadingMoreBrand = true);
    } else {
      setState(() => _isLoadingBrand = true);
    }

    try {
      final response = await _brandRepository.getBrands(
        page: page,
        limit: 20,
        search: search,
      );

      final items = (response.data ?? [])
          .where((e) => e.id != null && (e.name ?? '').trim().isNotEmpty)
          .map((e) => DropdownItemModel(id: e.id!, name: e.name!))
          .toList();

      setState(() {
        if (page > 1) {
          _brandItems.addAll(items);
        } else {
          _brandItems = items;
        }
        _brandPage = page;
        _brandTotalPages = response.meta?.pagination?.totalPages ?? page;
      });

      if (page == 1 &&
          widget.product != null &&
          widget.brand != null &&
          _brandItems.isNotEmpty) {
        widget.selectedBrandNotifier.value = _brandItems.firstWhere(
          (e) => e.id == widget.brand!.brandId,
          orElse: () => _brandItems.first,
        );
      }
    } catch (_) {
      if (mounted) {
        AppSnackBar.warning(
          context: context,
          message: "Gagal memuat daftar brand",
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoadingBrand = false;
        _isLoadingMoreBrand = false;
      });
    }
  }

  void _onBrandSearch(String query) {
    _brandSearchDebounce?.cancel();
    if (query.trim() == _brandSearch) return;
    _brandSearch = query;
    _brandSearchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      _loadBrands(page: 1, search: _brandSearch);
    });
  }

  void _onBrandLoadMore() {
    if (_isLoadingMoreBrand || _brandPage >= _brandTotalPages) return;
    _loadBrands(page: _brandPage + 1, search: _brandSearch);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const BuildLabel(text: "Brand", isRequired: true),
            const CustomSpacing(width: 8),
            _isLoadingBrand
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        ValueListenableBuilder<DropdownItemModel?>(
          valueListenable: widget.selectedBrandNotifier,
          builder: (context, selectedBrand, _) {
            return ValueListenableBuilder<String?>(
              valueListenable: widget.brandErrorNotifier,
              builder: (context, brandError, _) {
                return BuildSearchableDropdown(
                  hint: "Pilih Brand",
                  items: _brandItems,
                  value: selectedBrand,
                  errorText: brandError,
                  onChanged: (value) =>
                      widget.selectedBrandNotifier.value = value,
                  onSearch: _onBrandSearch,
                  isLoading: _isLoadingBrand || _isLoadingMoreBrand,
                  onLoadMore: _onBrandLoadMore,
                  hasMore: _brandPage < _brandTotalPages,
                );
              },
            );
          },
        ),
        const CustomSpacing(height: 20),
        const BuildLabel(text: "Nama", isRequired: true),
        ValueListenableBuilder<String?>(
          valueListenable: widget.nameErrorNotifier,
          builder: (context, nameError, _) {
            return CustomTextField(
              controller: widget.nameController,
              label: 'Nama Produk',
              hint: "Turanza T005A",
              filled: true,
              errorText: nameError,
            );
          },
        ),
        if (_isEditing && widget.isWarehouse) ...[
          const CustomSpacing(height: 4),
          const BuildLabel(text: "Alasan Perubahan", isRequired: true),
          ValueListenableBuilder<String?>(
            valueListenable: widget.reasonErrorNotifier,
            builder: (context, reasonError, _) {
              return CustomTextField(
                controller: widget.reasonController,
                label: 'Alasan perubahan nama/brand',
                alignLabelWithHint: true,
                hint: "Contoh: penyesuaian nama produk dari supplier",
                errorText: reasonError,
                filled: true,
                maxLines: 3,
              );
            },
          ),
        ],
      ],
    );
  }
}
