import 'package:arena/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:arena/components/custom_spacing.dart';

class DotSelector extends StatefulWidget {
  const DotSelector({super.key});

  @override
  State<DotSelector> createState() => _DotSelectorState();
}

class _DotSelectorState extends State<DotSelector> {
  String selected = "0314";

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _item("0314"),
        const CustomSpacing(width: 8),
        _item("0524"),
      ],
    );
  }

  Widget _item(String value) {
    final isActive = selected == value;

    return GestureDetector(
      onTap: () {
        setState(() => selected = value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.red : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: CustomText(
          text: value,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}