import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/design/status_color_config.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/models/stock/stock_detail_model.dart';
import 'package:flutter/material.dart';

class TableStockDot extends StatefulWidget {
  final List<StockDetailBatch> batches;
  final int sellPrice;
  final int buyPrice;
  final void Function(StockDetailBatch batch)? onAdjustBatch;
  final bool isOwner;

  const TableStockDot({
    super.key,
    required this.batches,
    required this.sellPrice,
    required this.buyPrice,
    this.onAdjustBatch,
    this.isOwner = false,
  });

  @override
  State<TableStockDot> createState() => _TableStockDotState();
}

class _TableStockDotState extends State<TableStockDot> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int totalQty = 0;

    int totalHargaBeli = 0;
    int totalTotalHargaBeli = 0;
    int totalHargaJual = 0;
    int totalTotalHargaJual = 0;

    for (var e in widget.batches) {
      final qty = e.quantity ?? 0;
      final buyPrice = e.buyPrice ?? widget.buyPrice;
      final sellPrice = e.sellPrice ?? widget.sellPrice;
      totalQty += qty;
      totalHargaBeli += buyPrice;
      totalHargaJual += sellPrice;
      totalTotalHargaBeli += buyPrice * qty;
      totalTotalHargaJual += sellPrice * qty;
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: SupportAppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: CustomText(
              text: "Stok Per DOT",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),

        CustomSpacing(height: 2),

        /// TABLE
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: SupportAppColors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            thickness: 4,
            radius: Radius.circular(100),
            trackVisibility: false,
            child: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width - 32,
                ),
                child: Table(
                  defaultColumnWidth: const IntrinsicColumnWidth(),
                  border: TableBorder(
                    horizontalInside: BorderSide(
                      color: SupportAppColors.greyMidTermColor,
                    ),
                  ),
                  children: [
                    TableRow(
                      children: [
                        _buildHeaderCell("DOT"),
                        _buildHeaderCell("QTY"),
                        if (widget.isOwner) _buildHeaderCell("Harga Beli /pcs"),
                        if (widget.isOwner)
                          _buildHeaderCell("Total Harga Beli"),
                        _buildHeaderCell("Harga Jual /pcs"),
                        _buildHeaderCell("Total Harga Jual"),
                        _buildHeaderCell("Umur"),
                        _buildHeaderCell("Status"),
                      ],
                    ),

                    ...widget.batches.map((e) {
                      final style = StockConfig.getStyleByName(
                        e.displayStockStatus,
                      );
                      final cells = [
                        _buildDotCell(
                          id: e.displayBatchCode,
                          color: style.foreground,
                        ),
                        _buildCell((e.quantity ?? 0).toString()),
                        if (widget.isOwner)
                          _buildCell(
                            (e.buyPrice ?? widget.buyPrice).toLocaleCurrency(),
                            color: SupportAppColors.greyColor,
                          ),
                        if (widget.isOwner)
                          _buildCell(
                            ((e.buyPrice ?? widget.buyPrice) *
                                    (e.quantity ?? 0))
                                .toLocaleCurrency(),
                            isBold: true,
                          ),
                        _buildCell(
                          (e.sellPrice ?? widget.sellPrice).toLocaleCurrency(),
                          color: SupportAppColors.greyColor,
                        ),
                        _buildCell(
                          ((e.sellPrice ?? widget.sellPrice) *
                                  (e.quantity ?? 0))
                              .toLocaleCurrency(),
                          isBold: true,
                        ),
                        _buildUmurCell(
                          "${e.displayDaysInStock} hari",
                          style.foreground,
                        ),
                        _buildUmurCell(e.displayStockStatus, style.foreground),
                      ];

                      if (widget.onAdjustBatch == null) {
                        return TableRow(children: cells);
                      }

                      return TableRow(
                        children: cells
                            .map(
                              (cell) => GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => widget.onAdjustBatch!(e),
                                child: cell,
                              ),
                            )
                            .toList(),
                      );
                    }),

                    /// TOTAL ROW
                    TableRow(
                      children: [
                        _buildCell(
                          "TOTAL",
                          isBold: true,
                          align: TextAlign.left,
                        ),
                        _buildCell(totalQty.toString(), isBold: true),
                        if (widget.isOwner)
                          _buildCell(
                            totalHargaBeli.toLocaleCurrency(),
                            color: SupportAppColors.greyColor,
                          ),
                        if (widget.isOwner)
                          _buildCell(
                            totalTotalHargaBeli.toLocaleCurrency(),
                            isBold: true,
                          ),
                        _buildCell(
                          totalHargaJual.toLocaleCurrency(),
                          color: SupportAppColors.greyColor,
                        ),
                        _buildCell(
                          totalTotalHargaJual.toLocaleCurrency(),
                          isBold: true,
                        ),
                        const CustomSpacing(),
                        const CustomSpacing(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildHeaderCell(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    child: CustomText(
      text: text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        color: SupportAppColors.greyColor,
        fontSize: 14,
      ),
    ),
  );
}

Widget _buildDotCell({required String id, required Color color}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    child: CustomText(
      text: id,
      style: TextStyle(color: color, fontWeight: FontWeight.w600),
    ),
  );
}

Widget _buildUmurCell(String umur, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    child: Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomText(
          text: umur,
          style: TextStyle(color: color, fontSize: 12),
        ),
      ),
    ),
  );
}

Widget _buildCell(
  String text, {
  bool isBold = false,
  Color? color,
  TextAlign align = TextAlign.center,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    child: CustomText(
      text: text,
      textAlign: align,
      style: TextStyle(
        fontWeight: isBold ? FontWeight.w500 : FontWeight.normal,
        color: color ?? SupportAppColors.greyDarkerColor,
        fontSize: 15,
      ),
    ),
  );
}
