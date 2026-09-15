import 'package:arena/components/custom_text.dart';
import 'package:flutter/material.dart';

enum DotType { old, warning, good }

class DotItem extends StatelessWidget {
  final String dot;
  final String date;
  final String qty;
  final String satuan;
  final String total;
  final String umur;
  final DotType type;

  const DotItem({
    super.key,
    required this.dot,
    required this.date,
    required this.qty,
    required this.satuan,
    required this.total,
    required this.umur,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          /// DOT (2 BARIS)
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: dot,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _dotColor(),
                  ),
                ),
                CustomText(
                  text: date,
                  style: TextStyle(
                    fontSize: 12,
                    color: _dotColor(),
                  ),
                ),
              ],
            ),
          ),

          /// QTY
          Expanded(
            child: CustomText(text: qty,
              textAlign: TextAlign.center,
            ),
          ),

          /// SATUAN
          Expanded(
            child: CustomText(text: satuan,
              textAlign: TextAlign.center,
            ),
          ),

          /// TOTAL
          Expanded(
            child: CustomText(text: total,
              textAlign: TextAlign.center,
            ),
          ),

          /// UMUR (BADGE)
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _bgColor(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomText(text: umur,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _dotColor(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  
  Color _dotColor() {
    switch (type) {
      case DotType.old:
        return Colors.red;
      case DotType.warning:
        return Colors.orange;
      case DotType.good:
        return Colors.green;
    }
  }

  
  Color _bgColor() {
    switch (type) {
      case DotType.old:
        return Colors.red.shade100;
      case DotType.warning:
        return Colors.orange.shade100;
      case DotType.good:
        return Colors.green.shade100;
    }
  }
}