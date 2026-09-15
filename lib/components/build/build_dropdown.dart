import 'package:arena/components/dropdown/dropdown_form_field.dart';
import 'package:arena/models/metadata/dropdown_item_model.dart';
import 'package:flutter/material.dart';

class BuildDropdown extends StatelessWidget {
  final String hint;
  final List<DropdownItemModel> items;
  final ValueChanged<DropdownItemModel?> onChanged;
  final DropdownItemModel? value;
  final String? Function(DropdownItemModel?)? validator;
  final List<int>? disabledIndexes;

  const BuildDropdown({
    super.key,
    required this.hint,
    required this.items,
    required this.onChanged,
    required this.value,
    this.validator,
    this.disabledIndexes,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownFormField<DropdownItemModel>(
      items: items,
      hint: hint,
      itemLabel: (item) => item.name,
      onChanged: onChanged,
      value: value,
      validator: validator,
      disabledIndexes: disabledIndexes ?? [],
    );
  }
}
