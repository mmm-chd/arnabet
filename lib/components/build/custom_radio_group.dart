import 'package:arena/models/metadata/dropdown_item_model.dart';
import 'package:flutter/material.dart';

class CustomRadioGroup extends StatelessWidget {
  final List<DropdownItemModel> items;
  final DropdownItemModel? value;
  final ValueChanged<DropdownItemModel?> onChanged;

  const CustomRadioGroup({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        final selected = item == value;
        return RadioListTile<DropdownItemModel>(
          title: Text(item.name),
          value: item,
          groupValue: value,
          onChanged: onChanged,
          activeColor: Theme.of(context).primaryColor,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          selected: selected,
        );
      }).toList(),
    );
  }
}
