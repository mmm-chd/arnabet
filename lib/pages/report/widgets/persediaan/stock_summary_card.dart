import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/models/report/stock_movement_model.dart';
import 'package:flutter/material.dart';
import 'stock_summary_row.dart';

class StockSummaryCard extends StatelessWidget {
  final MovementSummary? summary;

  const StockSummaryCard({
    super.key,
    this.summary,});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Ringkasan Pergerakan",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          CustomSpacing(height: 12),

          StockSummaryRow(title: "Stok awal periode",value: "${summary?.displayOpeningStock ?? "0"} pcs",),
          StockSummaryRow(title: "(+) Masuk",value: "+${summary?.displayIncoming ?? "0"} pcs",color: Colors.green,),
          StockSummaryRow(title: "(-) Keluar", value: "-${summary?.displayOutgoing ?? "0"} pcs", color: Colors.red),
          StockSummaryRow(title: "(±) Adjustment", value: "${summary?.displayAdjustment ?? "0"} pcs", color: Colors.orange),

          Divider(),

          StockSummaryRow(title: "Stok Akhir",value: "${summary?.displayClosingStock ?? "0"} pcs",),
        ],
      ),
    );
  }
}