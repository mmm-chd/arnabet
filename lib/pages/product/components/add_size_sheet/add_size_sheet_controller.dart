import 'package:arena/models/product/product_list_model.dart';
import 'package:arena/pages/product/components/add_size_sheet/size_row_data.dart';
import 'package:flutter/material.dart';

class AddSizeSheetController {
  final bool requirePrice;

  final selectedProduct = ValueNotifier<ProductModel?>(null);
  final rows = ValueNotifier<List<SizeRowData>>([]);
  final canSave = ValueNotifier<bool>(false);

  final showErrors = ValueNotifier<bool>(false);

  int _nextId = 0;
  bool _disposed = false;

  AddSizeSheetController({this.requirePrice = true}) {
    selectedProduct.addListener(syncCanSave);
  }

  void syncCanSave() {
    final currentRows = rows.value;
    canSave.value =
        selectedProduct.value != null &&
        currentRows.isNotEmpty &&
        currentRows.every((row) => row.isValid);
  }

  SizeRowData addRow() {
    final row = SizeRowData(_nextId++, requirePrice: requirePrice);
    row.addListener(syncCanSave);
    rows.value = [...rows.value, row];
    syncCanSave();
    return row;
  }

  void removeRow(int id) {
    SizeRowData? removed;
    rows.value = rows.value.where((row) {
      if (row.id == id) {
        removed = row;
        return false;
      }
      return true;
    }).toList();

    if (removed != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => removed!.dispose());
    }

    syncCanSave();
  }

  SizeRowData? get firstInvalidRow {
    for (final row in rows.value) {
      if (!row.isValid) return row;
    }
    return null;
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;

    for (final row in rows.value) {
      row.dispose();
    }
    selectedProduct.dispose();
    rows.dispose();
    canSave.dispose();
    showErrors.dispose();
  }
}