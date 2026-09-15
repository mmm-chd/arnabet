import 'package:arena/components/text_field/custom_text_field.dart';
import 'package:arena/helper/currency_local_formatter.dart';
import 'package:flutter/material.dart';
import '../../../models/dot_model.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';

class DotItem extends StatefulWidget {
  final DotModel dot;
  final Function(int) onChanged;

  const DotItem({super.key, required this.dot, required this.onChanged});

  @override
  State<DotItem> createState() => _DotItemState();
}

class _DotItemState extends State<DotItem> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.dot.jumlah.toString());
  }

  @override
  void didUpdateWidget(covariant DotItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dot.jumlah != widget.dot.jumlah) {
      controller.text = widget.dot.jumlah.toString();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          /// DOT CODE
          Expanded(
            child: CustomText(
              text: widget.dot.kode,

              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),

          /// MINUS
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () {
              if (widget.dot.jumlah > 0) {
                final newQty = widget.dot.jumlah - 1;
                controller.text = newQty.toString();
                widget.onChanged(newQty);
              }
            },
          ),

          /// INPUT
          CustomSpacing(
            width: 60,
            child: CustomTextField(
              controller: controller,
              isNumber: true,
              hint: "0",
              textInputType: TextInputType.number,
              onChanged: (value) {
                final qty = int.tryParse(value) ?? 0;
                widget.onChanged(qty);
              },
            ),
          ),

          /// PLUS
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              final newQty = widget.dot.jumlah + 1;
              controller.text = newQty.toString();
              widget.onChanged(newQty);
            },
          ),

          const CustomSpacing(width: 12),

          /// PRICE
          CustomText(
            text: widget.dot.hargaBeli?.toLocaleCurrency() ?? '-',
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
