import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/design/status_color_config.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/report/stock_health_model.dart';
import 'package:flutter/material.dart';

class TotalStockCard extends StatelessWidget {
  final StockAging? aging;

  const TotalStockCard({super.key, this.aging});

  @override
  Widget build(BuildContext context) {
    final bool highlighted = aging?.isHighlighted ?? false;
    final style = StockConfig.getStyleByName(aging?.label);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SupportAppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: highlighted
            ? Border.all(color: SupportAppColors.normalRed, width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// VALUE + BADGE
          CustomText(
            text: aging?.displayTotalValue ?? "-",
            style: const TextStyle(
              color: SupportAppColors.greyDarkerColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const CustomSpacing(height: 4),

          CustomText(
            text: "Nilai HPP beli",
            style: TextStyle(color: SupportAppColors.greyColor, fontSize: 14),
          ),
          const CustomSpacing(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: style.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomText(
              text: aging?.displayLabel ?? "-",
              style: TextStyle(
                color: style.foreground,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),

          const CustomSpacing(height: 14),

          Row(
            children: [
              Expanded(
                child: _MiniInfo(
                  title: "Total Item",
                  value: "${aging?.displayTotalSkus ?? "0"} SKU",
                  textColor: SupportAppColors.greyDarkerColor,
                  valueColor: SupportAppColors.greyColor,
                ),
              ),
              const CustomSpacing(width: 8),
              Expanded(
                child: _MiniInfo(
                  title: "Volume",
                  value: aging?.displayVolumePercentageLabel ?? "0%",
                  textColor: SupportAppColors.greyDarkerColor,
                  valueColor: SupportAppColors.greyColor,
                ),
              ),
              const CustomSpacing(width: 8),
              Expanded(
                child: _MiniInfo(
                  title: "Jumlah",
                  value: "${aging?.displayTotalQty ?? "0"} pcs",
                  textColor: SupportAppColors.greyDarkerColor,
                  valueColor: SupportAppColors.greyColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniInfo extends StatelessWidget {
  final String title;
  final String value;
  final Color textColor, valueColor;

  const _MiniInfo({
    required this.title,
    required this.value,
    required this.textColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const CustomSpacing(height: 2),
          CustomText(
            text: value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
