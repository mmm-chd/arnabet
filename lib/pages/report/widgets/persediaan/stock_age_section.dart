import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/report/stock_health_model.dart';
import 'package:flutter/material.dart';

class StockAgeSection extends StatelessWidget {
  final List<StockAging> aging;

  const StockAgeSection({super.key, this.aging = const []});

  static const List<List<Color>> _palette = [
    [SupportAppColors.lightOrange, SupportAppColors.normalOrange],
    [SupportAppColors.lightGreen, SupportAppColors.normalGreen],
  ];

  @override
  Widget build(BuildContext context) {
    if (aging.isEmpty) {
      return const SizedBox.shrink();
    }

    final children = <Widget>[];
    for (var i = 0; i < aging.length; i++) {
      final item = aging[i];
      final colors = _palette[i % _palette.length];
      if (i > 0) {
        children.add(const CustomSpacing(width: 12));
      }
      children.add(
        Expanded(
          child: StockAgeCard(
            label: item.displayLabel,
            value: item.displayTotalValue,
            subtitle: "Nilai HPP beli",
            totalItem: "${item.displayTotalSkus} SKU",
            volume: "${item.displayTotalQty} pcs",
            badgeBgColor: colors[0],
            textBadgeColor: colors[1],
            textSecondaryColor: SupportAppColors.greyColor,
          ),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class StockAgeCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final String totalItem;
  final String volume;
  final Color backgroundColor;
  final Color textPrimaryColor, textSecondaryColor;
  final Color badgeBgColor, textBadgeColor;

  const StockAgeCard({
    super.key,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.totalItem,
    required this.volume,
    this.backgroundColor = SupportAppColors.white,
    this.textPrimaryColor = SupportAppColors.greyDarkerColor,
    required this.badgeBgColor,
    required this.textSecondaryColor,
    required this.textBadgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomText(
              text: label,
              style: TextStyle(
                color: textBadgeColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const CustomSpacing(height: 10),

          /// VALUE
          CustomText(
            text: value,
            style: TextStyle(
              color: textPrimaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          const CustomSpacing(height: 2),

          /// SUBTITLE
          CustomText(
            text: subtitle,
            style: TextStyle(color: textSecondaryColor, fontSize: 12),
          ),

          const CustomSpacing(height: 12),

          /// INFO BOX
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Total Item",
                  style: TextStyle(
                    color: textPrimaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                CustomText(
                  text: totalItem,
                  style: TextStyle(
                    color: textSecondaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const CustomSpacing(height: 6),
                CustomText(
                  text: "Volume",
                  style: TextStyle(
                    color: textPrimaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                CustomText(
                  text: volume,
                  style: TextStyle(
                    color: textSecondaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
