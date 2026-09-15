import 'package:arena/components/animations/animated_expandable_content.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/config/design/status_color_config.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/stock/stock_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StockCard extends StatelessWidget {
  final bool expanded;
  final VoidCallback onExpandToggle;
  final String productName,
      size,
      ring,
      stock,
      status,
      totalBatches,
      lastRestock;
  final List<StockListBatch> batches;
  final double? topLeft, topRight, bottomLeft, bottomRight;
  final VoidCallback onTap;

  const StockCard({
    super.key,
    required this.expanded,
    required this.onExpandToggle,
    required this.productName,
    required this.size,
    required this.ring,
    required this.stock,
    required this.status,
    required this.batches,
    required this.onTap,
    required this.totalBatches,
    required this.lastRestock,
    this.topLeft,
    this.topRight,
    this.bottomLeft,
    this.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    final maxStockDOTItem = batches.length.clamp(0, 2);
    final style = StockConfig.getStyleByName(status);

    return Material(
      color: SupportAppColors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(topLeft ?? 0),
        topRight: Radius.circular(topRight ?? 0),
        bottomLeft: Radius.circular(bottomLeft ?? 0),
        bottomRight: Radius.circular(bottomRight ?? 0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeft ?? 0),
          topRight: Radius.circular(topRight ?? 0),
          bottomLeft: Radius.circular(bottomLeft ?? 0),
          bottomRight: Radius.circular(bottomRight ?? 0),
        ),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topLeft ?? 0),
            topRight: Radius.circular(topRight ?? 0),
            bottomLeft: Radius.circular(bottomLeft ?? 0),
            bottomRight: Radius.circular(bottomRight ?? 0),
          ),
          elevation: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 12, 13, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomText(
                            text: productName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: SupportAppColors.greyDarkerColor,
                            ),
                          ),
                        ),
                        const CustomSpacing(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: style.background,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: style.foreground,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const CustomSpacing(width: 8),
                              CustomText(
                                text: status,
                                style: TextStyle(
                                  color: style.foreground,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const CustomSpacing(height: 4),
                    Row(
                      children: [
                        CustomText(
                          text: size,
                          style: TextStyle(color: SupportAppColors.greyColor),
                        ),
                        const CustomSpacing(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: SupportAppColors.greyColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const CustomSpacing(width: 8),
                        CustomText(
                          text: ring,
                          style: TextStyle(color: SupportAppColors.greyColor),
                        ),
                      ],
                    ),
                    const CustomSpacing(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Terakhir Restock",
                          style: TextStyle(color: SupportAppColors.greyColor),
                        ),
                        CustomText(
                          text: lastRestock,
                          style: TextStyle(
                            color: SupportAppColors.greyDarkerColor,
                          ),
                        ),
                      ],
                    ),
                    const CustomSpacing(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "DOT",
                              style: TextStyle(
                                color: SupportAppColors.greyColor,
                              ),
                            ),
                            CustomText(
                              text: "$totalBatches Batch",
                              style: TextStyle(
                                color: SupportAppColors.greyDarkerColor,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomText(
                              text: "Stok saat ini",
                              style: TextStyle(
                                color: SupportAppColors.greyColor,
                              ),
                            ),
                            CustomText(
                              text: stock,
                              style: TextStyle(
                                color: SupportAppColors.greyDarkerColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              AnimatedExpandableContent(
                expanded: expanded,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
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
                      : Column(
                          children: List.generate(maxStockDOTItem, (index) {
                            final dot = batches[index];
                            final topItem = index == 0;
                            final batchStyle = StockConfig.getStyleByName(
                              dot.displayStockStatus,
                            );

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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: dot.displayBatchCode,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: SupportAppColors
                                                .greyDarkerColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            CustomText(
                                              text:
                                                  "${dot.displayQuantity} pcs",
                                              maxLines: 1,
                                              style: TextStyle(
                                                color:
                                                    SupportAppColors.greyColor,
                                              ),
                                            ),
                                            CustomSpacing(width: 8),
                                            Container(
                                              width: 4,
                                              height: 4,
                                              decoration: BoxDecoration(
                                                color:
                                                    SupportAppColors.greyColor,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            CustomSpacing(width: 8),
                                            CustomText(
                                              maxLines: 1,
                                              text:
                                                  dot.displayDaysInStock == "1"
                                                  ? "1 day"
                                                  : "${dot.displayDaysInStock} days",
                                              style: TextStyle(
                                                color:
                                                    SupportAppColors.greyColor,
                                                fontWeight: FontWeight.w500,
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
                                      color: batchStyle.background,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: CustomText(
                                      maxLines: 1,
                                      text: dot.displayStockStatus,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: batchStyle.foreground,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(14, expanded ? 0 : 12, 14, 12),
                child: Center(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: onExpandToggle,
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
                              CustomIcons.arrowDown,
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
            ],
          ),
        ),
      ),
    );
  }
}
