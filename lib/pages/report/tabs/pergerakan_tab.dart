import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/state/error_state_widget.dart';
import 'package:arena/models/report/stock_movement_model.dart';
import 'package:arena/pages/report/widgets/pergerakan/pergerakan_stat_card.dart';
import 'package:arena/pages/report/widgets/persediaan/stock_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/report_bloc.dart';
import '../bloc/report_event.dart';
import '../bloc/report_state.dart';

class PergerakanTab extends StatefulWidget {
  final String? period;
  final DateTime? startDate;
  final DateTime? endDate;

  const PergerakanTab({
    super.key,
    this.period,
    this.startDate,
    this.endDate,
  });

  @override
  State<PergerakanTab> createState() => _PergerakanTabState();
}

class _PergerakanTabState extends State<PergerakanTab> {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ReportBloc,
      ReportState,
      (ReportStatus, StockMovementData?, String?)
    >(
      selector: (state) =>
          (state.status, state.stockMovement, state.errorMessage),
      builder: (context, selected) {
        final status = selected.$1;
        final data = selected.$2;
        final errorMessage = selected.$3;

        if (status == ReportStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (status == ReportStatus.failure) {
          return ErrorStateWidget(
            message: errorMessage ?? "Terjadi kesalahan",
            onRetry: () {
              final period = widget.period;
              if (period != null) {
                context.read<ReportBloc>().add(
                  LoadStockMovement(
                    period: period,
                    startDate: widget.startDate,
                    endDate: widget.endDate,
                  ),
                );
              }
            },
          );
        }
        final kpi = data?.kpi;
        final summary = data?.movementSummary;

        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: PergerakanStatCard(
                      title: "Masuk (pcs)",
                      value: kpi?.incoming?.displayQty ?? "0",
                      subtitle: kpi?.incoming?.displayValue ?? "Rp 0,00",
                      textColor: SupportAppColors.normalGreen,
                      backgroundColor: SupportAppColors.white,
                      icon: Icons.add_circle_outline,
                      trendPercentage: kpi?.incoming?.trendPercentage,
                      trendDirection: kpi?.incoming?.trendDirection,
                    ),
                  ),
                  const CustomSpacing(width: 8),
                  Expanded(
                    child: PergerakanStatCard(
                      title: "Keluar (pcs)",
                      value: kpi?.outgoing?.displayQty ?? "0",
                      subtitle: kpi?.outgoing?.displayValue ?? "Rp 0,00",
                      textColor: SupportAppColors.normalRed,
                      backgroundColor: SupportAppColors.white,
                      icon: Icons.remove_circle_outline,
                      trendPercentage: kpi?.outgoing?.trendPercentage,
                      trendDirection: kpi?.outgoing?.trendDirection,
                    ),
                  ),
                ],
              ),
            ),
            const CustomSpacing(height: 8),
            PergerakanStatCard(
              title: "Adjusment",
              value: kpi?.adjustment?.displayQty ?? "0",
              subtitle: kpi?.adjustment?.displayValue ?? "Rp 0,00",
              textColor: SupportAppColors.normalOrange,
              backgroundColor: SupportAppColors.white,
              icon: Icons.tune,
              trendPercentage: kpi?.adjustment?.trendPercentage,
              trendDirection: kpi?.adjustment?.trendDirection,
            ),
            const CustomSpacing(height: 16),
            StockSummaryCard(summary: summary),
            // const CustomSpacing(height: 16),
            // DoubleBarChart(
            //   labels: data?.chart?.labels,
            //   incoming: data?.chart?.incoming,
            //   outgoing: data?.chart?.outgoing,
            // ),
            const CustomSpacing(height: 32),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              child: CustomText(
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
}
