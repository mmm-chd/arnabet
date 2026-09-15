import 'package:arena/components/custom_text.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/enums/enums.dart';
import 'package:arena/models/order/order_detail_model.dart';
import 'package:arena/pages/order_detail/components/order_item_card.dart';
import 'package:flutter/material.dart';

class OrderItemSections {
  static List<Widget> build({
    required List<OrderDetailItem> items,
    bool showPrice = true,
  }) {
    final products = items
        .where((e) => e.itemType != ItemType.SERVICE)
        .toList();
    final services = items
        .where((e) => e.itemType == ItemType.SERVICE)
        .toList();

    return [
      if (products.isNotEmpty) ...[
        const _SectionLabel(text: 'Product'),
        ...products.map(
          (item) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: OrderItemCard(item: item, showPrice: showPrice),
          ),
        ),
      ],
      if (services.isNotEmpty) ...[
        _SectionLabel(text: 'Service', topPadding: products.isEmpty ? 12 : 20),
        ...services.map(
          (item) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: OrderItemCard(item: item, showPrice: showPrice),
          ),
        ),
      ],
    ];
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final double topPadding;

  const _SectionLabel({required this.text, this.topPadding = 12});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, topPadding, 20, 4),
      child: CustomText(
        text: text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: SupportAppColors.greyDarkerColor,
        ),
      ),
    );
  }
}
