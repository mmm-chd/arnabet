import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/models/report/top_products_model.dart';
import 'package:arena/pages/report/widgets/ringkasan/card_stat.dart';
import 'package:arena/pages/report/widgets/penjualan/one_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/report_bloc.dart';
import '../bloc/report_state.dart';

class PenjualanTab extends StatefulWidget {
  const PenjualanTab({super.key});

  @override
  State<PenjualanTab> createState() => _PenjualanTabState();
}

class _PenjualanTabState extends State<PenjualanTab> {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ReportBloc,
      ReportState,
      (ReportStatus, TopProductsData?, String?)
    >(
      selector: (state) =>
          (state.status, state.topProducts, state.errorMessage),
      builder: (context, selected) {
        final status = selected.$1;
        final data = selected.$2;
        final errorMessage = selected.$3;

        if (status == ReportStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (status == ReportStatus.failure) {
          return Center(
            child: CustomText(text: errorMessage ?? "Terjadi kesalahan"),
          );
        }
        final summary = data?.summary;

        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            GridView.count(
              padding: EdgeInsets.zero,
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.1,
              children: [
                CardStat(
                  title: "Total Omzet",
                  value: summary?.omsetKotor?.displayValue ?? "0",
                  trend:
                      "${summary?.omsetKotor?.displayTrendPercentage ?? "0"}%",
                  trendDown: summary?.omsetKotor?.trendDirection == "down",
                  trendUp: summary?.omsetKotor?.trendDirection == "up",
                  neutral: summary?.omsetKotor?.trendPercentage == null,
                ),
                CardStat(
                  title: "Barang Terjual (pcs)",
                  value: summary?.totalItemsSold?.displayValue ?? "0",
                  trend:
                      "${summary?.totalItemsSold?.displayTrendPercentage ?? "0"}%",
                  trendDown: summary?.totalItemsSold?.trendDirection == "down",
                  trendUp: summary?.totalItemsSold?.trendDirection == "up",
                  neutral: summary?.totalItemsSold?.trendPercentage == null,
                  fontSize: 32,
                ),
                CardStat(
                  title: "Total Transaksi",
                  value: summary?.totalTransactions?.displayValue ?? "0",
                  trend:
                      "${summary?.totalTransactions?.displayTrendPercentage ?? "0"}%",
                  trendDown:
                      summary?.totalTransactions?.trendDirection == "down",
                  trendUp: summary?.totalTransactions?.trendDirection == "up",
                  neutral: summary?.totalTransactions?.trendPercentage == null,
                  fontSize: 32,
                ),
                CardStat(
                  title: "Rata-Rata Transaksi",
                  value: summary?.avgOrderValue?.displayValue ?? "0",
                  trend:
                      "${summary?.avgOrderValue?.displayTrendPercentage ?? "0"}%",
                  trendDown: summary?.avgOrderValue?.trendDirection == "down",
                  trendUp: summary?.avgOrderValue?.trendDirection == "up",
                  neutral: summary?.avgOrderValue?.trendPercentage == null,
                ),
              ],
            ),
            const CustomSpacing(height: 12),
            // SummaryCard(),
            // const CustomSpacing(height: 12),
            OneLineChart(chart: data?.chart),
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
