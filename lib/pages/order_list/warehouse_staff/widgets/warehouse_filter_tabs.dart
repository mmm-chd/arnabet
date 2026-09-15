import 'package:flutter/material.dart';
import 'package:arena/components/custom_text.dart';

class WarehouseFilterTabs extends StatelessWidget {
  final int selected;
  final Function(int) onTap;

  const WarehouseFilterTabs({
    super.key,
    required this.selected,
    required this.onTap,
  });

  final List<String> tabs = const [
    "Semua",
    "Proses",
    "Selesai",
    "Urgent",
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(tabs.length, (index) {
        final isActive = selected == index;

        return Expanded(
          child: GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              margin: EdgeInsets.only(right: index != tabs.length - 1 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? Colors.red : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: CustomText(text: tabs[index],
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}