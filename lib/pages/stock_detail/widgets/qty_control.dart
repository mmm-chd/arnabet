import 'package:arena/components/custom_text.dart';
import 'package:flutter/material.dart';

class QtyControl extends StatefulWidget {
  const QtyControl({super.key});

  @override
  State<QtyControl> createState() => _QtyControlState();
}

class _QtyControlState extends State<QtyControl> {
  int qty = 5;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _btn(Icons.remove, () {
          if (qty > 1) setState(() => qty--);
        }),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomText(
            text: "$qty",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16, 
            ),
          ),
        ),

        _btn(Icons.add, () {
          setState(() => qty++);
        }),
      ],
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: Colors.black),
      ),
    );
  }
}
