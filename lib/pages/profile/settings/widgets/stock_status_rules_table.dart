import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/design/status_color_config.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/stock/stock_status_rule_model.dart';
import 'package:flutter/material.dart';

class StockStatusRulesTable extends StatelessWidget {
  final List<StockStatusRuleItem> rules;
  final void Function(StockStatusRuleItem rule)? onEdit;

  const StockStatusRulesTable({super.key, required this.rules, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Threshold Stock",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                CustomSpacing(height: 2),
                CustomText(
                  text: "Untuk mengubah status yang akan tertera pada stock",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),

        const CustomSpacing(height: 2),

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
            thumbVisibility: true,
            radius: const Radius.circular(10),
            thickness: 4,
            controller: scrollController,
            child: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                          _buildHeaderCell("Status"),
                          _buildHeaderCell("Min Qty"),
                          _buildHeaderCell("Max Qty"),
                          _buildHeaderCell("Prioritas"),
                          _buildHeaderCell("Alert"),
                          _buildHeaderCell("Aktif"),
                          _buildHeaderCell(""),
                        ],
                      ),

                      ...rules.map((rule) {
                        final style = StockConfig.getStyleByName(rule.name);
                        return TableRow(
                          children: [
                            _buildStatusCell(
                              rule.displayName,
                              style.foreground,
                            ),
                            _buildCell(rule.displayMinQty),
                            _buildCell(rule.displayMaxQty),
                            _buildCell(rule.displayPriority),
                            _buildFlagCell(rule.isAlert == true),
                            _buildActiveCell(rule.isActive == true),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Center(
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 20,
                                    color: AppColors.primary,
                                  ),
                                  visualDensity: VisualDensity.compact,
                                  onPressed: onEdit == null
                                      ? null
                                      : () => onEdit!(rule),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
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

Widget _buildStatusCell(String name, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 8, color: color),
        const CustomSpacing(width: 6),
        CustomText(
          text: name,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}

Widget _buildFlagCell(bool isTrue) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    child: Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
          color: isTrue
              ? SupportAppColors.lightGreen
              : SupportAppColors.greyMidTermColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomText(
          text: isTrue ? "Ya" : "Tidak",
          style: TextStyle(
            color: isTrue
                ? SupportAppColors.normalGreen
                : SupportAppColors.greyDarkColor,
            fontSize: 12,
          ),
        ),
      ),
    ),
  );
}

Widget _buildActiveCell(bool isActive) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    child: Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
          color: isActive
              ? SupportAppColors.lightGreen
              : SupportAppColors.greyMidTermColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomText(
          text: isActive ? "Aktif" : "Nonaktif",
          style: TextStyle(
            color: isActive
                ? SupportAppColors.normalGreen
                : SupportAppColors.greyDarkColor,
            fontSize: 12,
          ),
        ),
      ),
    ),
  );
}

Widget _buildCell(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    child: CustomText(
      text: text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: SupportAppColors.greyDarkerColor,
        fontSize: 15,
      ),
    ),
  );
}