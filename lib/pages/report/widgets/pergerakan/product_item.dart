import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String name;
  final String size;
  final int stock;

  const ProductItem({
    super.key,
    required this.name,
    required this.size,
    required this.stock,
  });

  bool get isLow => stock < 10;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isLow ? Colors.red.shade100 : Colors.green.shade100,
            child: Icon(
              Icons.inventory_2,
              color: isLow ? Colors.red : Colors.green,
            ),
          ),
          const CustomSpacing(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: name, style: const TextStyle(fontWeight: FontWeight.w600)),
                CustomText(text: size, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          CustomText(
            text: "$stock pcs",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isLow ? Colors.red : Colors.black,
            ),
          )
        ],
      ),
    );
  }
}