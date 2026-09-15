import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/design/status_color_config.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/stock/dot_status_rule_model.dart';
import 'package:flutter/material.dart';

class DotStatusRulesTable extends StatelessWidget {
  final List<Datum> rules;
  final void Function(Datum rule)? onEdit;

  const DotStatusRulesTable({super.key, required this.rules, this.onEdit});

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
            child: CustomText(
              text: "Dot Status Rules",
              style: TextStyle(fontWeight: FontWeight.w600),
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
                          _buildHeaderCell("Min Bulan"),
                          _buildHeaderCell("Max Bulan"),
                          _buildHeaderCell("Prioritas"),
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
                            _buildCell(rule.minMonth?.toString() ?? "-"),
                            _buildCell(rule.maxMonth?.toString() ?? "∞"),
                            _buildCell(rule.priority?.toString() ?? "-"),
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
