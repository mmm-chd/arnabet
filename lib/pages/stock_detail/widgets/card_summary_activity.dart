import 'package:arena/components/cards/history_card.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:flutter/material.dart';

class CardSummaryActivity extends StatelessWidget {
  const CardSummaryActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: CustomText(
              text: "Ringkasan Aktivitas",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        CustomSpacing(height: 2),
        HistoryCard(
          user: "user",
          activity: "activity",
          qty: "qty",
          product: "product",
          before: "before",
          after: "after",
          invoice: "invoice",
          totalDot: "totalDot",
          batches: [],
          size: "size",
          ring: "ring",
          createdAt: "createdAt",
          reason: "reason",
          bottomLeft: 16,
          bottomRight: 16,
          onExpandToogle: () {},
          expanded: false,
        ),
      ],
    );
  }
}
