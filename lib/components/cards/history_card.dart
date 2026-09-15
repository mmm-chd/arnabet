import 'package:arena/components/animations/animated_expandable_content.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/design/status_color_config.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/activity_parser.dart';
import 'package:arena/models/stock/stock_history_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HistoryCard extends StatelessWidget {
  final String user;
  final String activity;
  final String qty;
  final String product;
  final String size, ring;
  final String before;
  final String after;
  final String invoice;
  final String reason;
  final String totalDot;
  final String createdAt;
  final List<StockHistoryAffectedBatch> batches;
  final StockHistoryBatchStatus? batchStatus;
  final double? topLeft, topRight, bottomLeft, bottomRight;
  final VoidCallback onExpandToogle;
  final bool expanded;
  final arrowDown = CustomIcons.arrowDown;

  const HistoryCard({
    super.key,
    required this.user,
    required this.activity,
    required this.qty,
    required this.product,
    required this.before,
    required this.after,
    required this.invoice,
    required this.reason,
    required this.totalDot,
    required this.batches,
    required this.size,
    required this.ring,
    required this.onExpandToogle,
    required this.expanded,
    required this.createdAt,
    this.batchStatus,
    this.topLeft,
    this.topRight,
    this.bottomLeft,
    this.bottomRight,
  });
  @override
  Widget build(BuildContext context) {
    final maxHistoryDOTItem = batches.length.clamp(0, 2);
    final batchStyle = StockConfig.getStyleByName(batchStatus?.name);
    return Container(
      margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(
        color: SupportAppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeft ?? 0),
          topRight: Radius.circular(topRight ?? 0),
          bottomLeft: Radius.circular(bottomLeft ?? 0),
          bottomRight: Radius.circular(bottomRight ?? 0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: user,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: SupportAppColors.greyDarkerColor,
                            ),
                          ),
                          CustomText(
                            text: parseActivity(activity),
                            maxLines: 1,
                            style: TextStyle(
                              color: SupportAppColors.greyColor,
                              fontSize: 14,
                            ),
                          ),
                          if (batchStatus?.name != null)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: batchStyle.background,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: CustomText(
                                text: batchStatus!.name!,
                                maxLines: 1,
                                style: TextStyle(
                                  color: batchStyle.foreground,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (activity.toLowerCase().contains("in") ||
                                  activity.toLowerCase().contains("penjualan"))
                                Icon(
                                  Icons.add,
                                  color: SupportAppColors.normalGreen,
                                  size: 20,
                                ),
                              if (activity.toLowerCase().contains("out") ||
                                  activity.toLowerCase().contains("keluar"))
                                Icon(
                                  Icons.remove,
                                  color: SupportAppColors.normalRed,
                                  size: 20,
                                ),
                              const CustomSpacing(width: 4),
                              CustomText(
                                text: "$qty pcs",
                                maxLines: 1,
                                style: TextStyle(
                                  color:
                                      (activity.toLowerCase().contains("in") ||
                                          activity.toLowerCase().contains(
                                            "penjualan",
                                          ))
                                      ? SupportAppColors.normalGreen
                                      : (activity.toLowerCase().contains(
                                              "out",
                                            ) ||
                                            activity.toLowerCase().contains(
                                              "keluar",
                                            ))
                                      ? SupportAppColors.normalRed
                                      : SupportAppColors.greyDarkerColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          CustomText(
                            text: createdAt,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 12,
                              color: SupportAppColors.greyColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const CustomSpacing(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        text: "Produk",
                        style: TextStyle(color: SupportAppColors.greyColor),
                      ),
                    ),
                    Expanded(
                      child: CustomText(
                        text: product,
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        style: TextStyle(
                          color: SupportAppColors.greyDarkerColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const CustomSpacing(height: 6),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        text: "Ukuran",
                        style: TextStyle(color: SupportAppColors.greyColor),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomText(
                            text: size,
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            style: TextStyle(
                              color: SupportAppColors.greyDarkerColor,
                            ),
                          ),
                          const CustomSpacing(width: 8),
                          CustomText(
                            text: ring,
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            style: TextStyle(
                              color: SupportAppColors.greyDarkerColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const CustomSpacing(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Stok Sebelum",
                            style: TextStyle(color: SupportAppColors.greyColor),
                          ),
                          CustomText(
                            text: "$before pcs",
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: SupportAppColors.greyDarkerColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomText(
                            text: "Stok saat ini",
                            style: TextStyle(color: SupportAppColors.greyColor),
                          ),
                          CustomText(
                            text: "$after pcs",
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: SupportAppColors.greyDarkerColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const CustomSpacing(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "No. Invoice",
                            style: TextStyle(color: SupportAppColors.greyColor),
                          ),
                          CustomText(
                            text: invoice,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: SupportAppColors.greyDarkerColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomText(
                            text: "Total DOT",
                            style: TextStyle(color: SupportAppColors.greyColor),
                          ),
                          CustomText(
                            text: totalDot,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: SupportAppColors.greyDarkerColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const CustomSpacing(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Alasan",
                            style: TextStyle(color: SupportAppColors.greyColor),
                          ),
                          CustomText(
                            text: reason,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: SupportAppColors.greyDarkerColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          AnimatedExpandableContent(
            expanded: expanded,
            child: batches.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: CustomText(
                      text: "Tidak ditemukan DOT",
                      style: TextStyle(
                        color: SupportAppColors.normalRed,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: maxHistoryDOTItem,
                    itemBuilder: (context, index) {
                      final dot = batches[index];
                      final style = StockConfig.getStyleByName(dot.stockStatus);
                      final topItem = index == 0;
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 0.5,
                              color: SupportAppColors.greyMidColor,
                              style: topItem
                                  ? BorderStyle.solid
                                  : BorderStyle.none,
                            ),
                            bottom: BorderSide(
                              width: 0.5,
                              color: SupportAppColors.greyMidColor,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: dot.displayBatchCode,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: style.foreground,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      CustomText(
                                        text: "${dot.displayBalanceBefore} pcs",
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: SupportAppColors.greyColor,
                                        ),
                                      ),
                                      const CustomSpacing(width: 8),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        color: SupportAppColors.greyDarkColor,
                                        size: 20,
                                      ),
                                      const CustomSpacing(width: 8),
                                      CustomText(
                                        text: "${dot.displayBalanceAfter} pcs",
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: SupportAppColors.greyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: style.background,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: CustomText(
                                maxLines: 1,
                                text: dot.displayStockStatus,
                                style: TextStyle(
                                  color: style.foreground,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(14, expanded ? 0 : 12, 14, 12),
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: onExpandToogle,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedRotation(
                          turns: expanded ? -0.5 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: SvgPicture.asset(
                            arrowDown,
                            colorFilter: ColorFilter.mode(
                              SupportAppColors.greyColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const CustomSpacing(width: 8),
                        CustomText(
                          text: "Lihat Selengkapnya",
                          style: TextStyle(color: SupportAppColors.greyColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
