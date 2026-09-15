import 'package:arena/components/cards/stock_card.dart';
import 'package:arena/config/routes/app_name_route.dart';
import 'package:arena/models/stock/stock_list_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExpandableStockCard extends StatefulWidget {
  final StockListDatum item;
  final bool lastItem;
  final bool? firstItem;
  final String size, ring, dotStatus, totalBatches;

  const ExpandableStockCard({
    super.key,
    required this.item,
    required this.lastItem,
    required this.size,
    required this.ring,
    required this.totalBatches,
    required this.dotStatus,
    this.firstItem,
  });

  @override
  State<ExpandableStockCard> createState() => ExpandableStockCardState();
}

class ExpandableStockCardState extends State<ExpandableStockCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: StockCard(
        expanded: expanded,
        onExpandToggle: () => setState(() => expanded = !expanded),
        productName: widget.item.productName ?? "-",
        size: widget.size,
        ring: widget.ring,
        stock: (widget.item.totalQty ?? 0).toString(),
        status: widget.dotStatus,
        totalBatches: widget.totalBatches,
        lastRestock: widget.item.displayUpdatedAt,
        batches: widget.item.batches ?? [],
        onTap: () => context.pushNamed(
          AppNameRoute.stockDetail,
          pathParameters: {'id': widget.item.displayProductId},
        ),
        topLeft: widget.firstItem != null && widget.firstItem! ? 16 : 0,
        topRight: widget.firstItem != null && widget.firstItem! ? 16 : 0,
        bottomLeft: widget.lastItem ? 16 : 0,
        bottomRight: widget.lastItem ? 16 : 0,
      ),
    );
  }
}
