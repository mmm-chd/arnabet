import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/list_header.dart';
import 'package:flutter/material.dart';

class SummaryCard extends StatefulWidget {
  const SummaryCard({super.key});

  @override
  State<SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListHeader(
          title: "Produk Terlaris",
          description: "Berdasarkan periode ini",
          isArrow: false,
        ),

        const CustomSpacing(height: 2),

        /// TABLE CONTAINER
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Scrollbar(
            controller: scrollController,
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
                    horizontalInside: BorderSide(color: Colors.grey.shade100),
                  ),
                  children: [
                    /// HEADER ROW
                    TableRow(
                      children: [
                        _buildHeaderCell("PRODUK", align: TextAlign.left),
                        _buildHeaderCell("QTY"),
                        _buildHeaderCell("OMZET"),
                        _buildHeaderCell("LABA"),
                        _buildHeaderCell("MGN"),
                      ],
                    ),

                    /// DATA ROWS
                    _buildDataRow(
                      "Turanza T005A",
                      "185/65 R15",
                      "124",
                      "53,9jt",
                      "10,8jt",
                      "20%",
                    ),
                    _buildDataRow(
                      "Potenza RE003",
                      "185/65 R15",
                      "37",
                      "96jt",
                      "23,9jt",
                      "25%",
                    ),
                    _buildDataRow(
                      "Potenza RE003",
                      "185/65 R15",
                      "96",
                      "76jt",
                      "19jt",
                      "25%",
                    ),
                    _buildDataRow(
                      "Potenza RE003",
                      "185/65 R15",
                      "72",
                      "54jt",
                      "9,4jt",
                      "17%",
                    ),
                    _buildDataRow(
                      "Potenza RE003",
                      "185/65 R15",
                      "52",
                      "37jt",
                      "5,4jt",
                      "15%",
                    ),

                    /// TOTAL ROW
                    TableRow(
                      children: [
                        _buildCell(
                          "TOTAL",
                          isBold: true,
                          align: TextAlign.left,
                        ),
                        _buildCell("381", isBold: true),
                        _buildCell("317jt", isBold: true, color: Colors.green),
                        _buildCell("68jt", isBold: true, color: Colors.green),
                        _buildCell(
                          "22%",
                          isBold: true,
                          color: Colors.grey.shade700,
                        ),
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

  TableRow _buildDataRow(
    String name,
    String subtitle,
    String qty,
    String omzet,
    String laba,
    String mgn,
  ) {
    return TableRow(
      children: [
        /// PRODUK
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const CustomSpacing(height: 2),
              CustomText(
                text: subtitle,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
              ),
            ],
          ),
        ),
        _buildCell(qty),
        _buildCell(omzet, color: Colors.green),
        _buildCell(laba, color: Colors.green),
        _buildCell(mgn, color: Colors.grey.shade700),
      ],
    );
  }

  Widget _buildHeaderCell(String text, {TextAlign align = TextAlign.center}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: CustomText(
        text: text,
        textAlign: align,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          fontSize: 12,
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
          fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          color: color ?? Colors.black87,
          fontSize: 13,
        ),
      ),
    );
  }
}
