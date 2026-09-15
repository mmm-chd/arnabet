import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/list_header.dart';
import 'package:arena/helper/safe_helpers.dart';
import 'package:arena/models/report/stock_health_model.dart';
import 'package:arena/pages/report/widgets/persediaan/stock_item.dart';
import 'package:arena/pages/report/widgets/persediaan/total_stock_card.dart';
import 'package:arena/pages/report/widgets/persediaan/top_stat_card.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/report_bloc.dart';
import '../bloc/report_state.dart';

class PersediaanTab extends StatefulWidget {
  const PersediaanTab({super.key});

  @override
  State<PersediaanTab> createState() => _PersediaanTabState();
}

class _PersediaanTabState extends State<PersediaanTab> {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ReportBloc,
      ReportState,
      (ReportStatus, StockHealthData?, String?)
    >(
      selector: (state) =>
          (state.status, state.stockHealth, state.errorMessage),
      builder: (context, selected) {
        final status = selected.$1;
        final data = selected.$2;
        final errorMessage = selected.$3;

        if (status == ReportStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (status == ReportStatus.failure) {
          return Center(child: Text(errorMessage ?? "Terjadi kesalahan"));
        }
        final overview = data?.overview;
        final alerts = data?.lowStockAlerts ?? [];
        final aging = data?.aging ?? [];

        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            // if (data != null)
            //   Padding(
            //     padding: const EdgeInsets.only(bottom: 12),
            //     child: CustomText(
            //       text: _buildPeriodLabel(data),
            //       style: TextStyle(
            //         fontSize: 12,
            //         color: SupportAppColors.greyColor,
            //       ),
            //     ),
            //   ),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: TopStatCard(
                      title: "Total Stok (pcs)",
                      titleFontSize: 16,
                      valueFontSize: 40,
                      value: overview?.totalStockQty?.displayValue ?? "-",
                      percent:
                          "${overview?.totalStockQty?.displayTrendPercentage ?? "0"}%",
                      direction: overview?.totalStockQty?.trendDirection,
                    ),
                  ),
                  const CustomSpacing(width: 12),
                  Expanded(
                    child: TopStatCard(
                      title: "Nilai Stok (HPP FIFO)",
                      valueFontSize: 16,
                      value: overview?.totalStockValue?.displayValue ?? "-",
                      percent:
                          "${overview?.totalStockValue?.displayTrendPercentage ?? "0"}%",
                      direction: overview?.totalStockValue?.trendDirection,
                    ),
                  ),
                ],
              ),
            ),
            const CustomSpacing(height: 16),
            ...aging.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TotalStockCard(aging: entry.value),
              ),
            ),
            const CustomSpacing(height: 4),
            if (alerts.isNotEmpty) ...[
              const ListHeader(
                title: "Stok Hampir Habis",
                description: "Berdasarkan threshold yang ditentukan",
                isArrow: false,
              ),
              const CustomSpacing(height: 2),
              ...alerts.asMap().entries.map((entry) {
                final item = entry.value;
                final isLast = entry.key == alerts.length - 1;
                return Column(
                  children: [
                    StockItem(
                      index: entry.key + 1,
                      name: item.displayName,
                      spec: item.displaySpec,
                      status: item.displayStatus,
                      qty: "${item.displayCurrentQty} pcs",
                      bottomLeft: isLast ? 16 : 0,
                      bottomRight: isLast ? 16 : 0,
                    ),
                    const CustomSpacing(height: 2),
                  ],
                );
              }),
            ],
            const CustomSpacing(height: 32),
            Container(
              alignment: Alignment.center,
              child: const CustomText(
                text: "Akhir dari perjalanan. Butuh bantuan lain?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: SupportAppColors.greyColor,
                  fontSize: 14,
                ),
              ),
            ),
            const CustomSpacing(height: 42),
          ],
        );
      },
    );
  }

  String _buildPeriodLabel(StockHealthData data) {
    final period = data.period;
    final periodText = period == null
        ? null
        : "Periode "
              "${safeDate(period.startDate)} – ${safeDate(period.endDate)}";
    final asOf = data.asOf;
    final asOfText = asOf == null ? null : "Per ${data.displayAsOf}";

    if (periodText != null && asOfText != null) {
      return "$periodText  ·  $asOfText";
    }
    return periodText ?? asOfText ?? "";
  }
}
