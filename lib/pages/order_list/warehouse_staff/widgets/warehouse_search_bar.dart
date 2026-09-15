import 'package:arena/components/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:arena/components/custom_spacing.dart';

class WarehouseSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const WarehouseSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey),
                const CustomSpacing(width: 8),
                Expanded(
                  child: CustomTextField(
                    controller: controller,
                    onChanged: onChanged,
                    hint: "Search...",
                    useBorder: false,
                    filled: false,
                  ),
                ),
              ],
            ),
          ),
        ),
        const CustomSpacing(width: 10),
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.tune),
        ),
      ],
    );
  }
}
