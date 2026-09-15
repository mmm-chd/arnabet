import 'package:arena/components/cards/history_card.dart';
import 'package:arena/models/stock/stock_history_model.dart';
import 'package:flutter/material.dart';

class ExpandableHistoryCard extends StatefulWidget {
  final StockHistoryDatum item;
  final bool lastItem;
  final bool? firstItem;
  final String size, ring;

  const ExpandableHistoryCard({
    super.key,
    required this.item,
    required this.lastItem,
    required this.size,
    required this.ring,
    this.firstItem,
  });

  @override
  State<ExpandableHistoryCard> createState() => ExpandableHistoryCardState();
}

class ExpandableHistoryCardState extends State<ExpandableHistoryCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: HistoryCard(
        expanded: expanded,
        onExpandToogle: () => setState(() => expanded = !expanded),
        user: widget.item.displayUserName,
        activity: widget.item.displayTypeName,
        qty: widget.item.displayQuantity,
        product: widget.item.displayProductName,
        size: widget.size,
        ring: widget.ring,
        before: widget.item.displayStockBefore,
        after: widget.item.displayStockAfter,
        invoice: widget.item.displayInvoiceNumber,
        reason: widget.item.displayReason,
        totalDot: widget.item.displayTotalDot,
        batches: widget.item.affectedBatches ?? [],
        createdAt: widget.item.displayCreatedAt,
        topLeft: widget.firstItem == true ? 16 : 0,
        topRight: widget.firstItem == true ? 16 : 0,
        bottomLeft: widget.lastItem ? 16 : 0,
        bottomRight: widget.lastItem ? 16 : 0,
      ),
    );
  }
}
