import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/list_header.dart';
import 'package:arena/models/report/summary_report_model.dart';
import 'package:arena/pages/report/widgets/ringkasan/product_item.dart';
import 'package:arena/pages/report/widgets/ringkasan/card_stat.dart';
import 'package:arena/pages/report/widgets/ringkasan/card_stat_wide.dart';
import 'package:arena/pages/report/widgets/ringkasan/double_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/report_bloc.dart';
import '../bloc/report_state.dart';

class RingkasanTab extends StatefulWidget {
  const RingkasanTab({super.key});

  @override
  State<RingkasanTab> createState() => _RingkasanTabState();
}

class _RingkasanTabState extends State<RingkasanTab> {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ReportBloc,
      ReportState,
      (ReportStatus, ReportSummaryData?, String?)
    >(
      selector: (state) => (state.status, state.report, state.errorMessage),
      builder: (context, selected) {
        final status = selected.$1;
        final report = selected.$2;
        final errorMessage = selected.$3;

        if (status == ReportStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (status == ReportStatus.failure) {
          return Center(child: Text(errorMessage ?? "Terjadi kesalahan"));
        }
        final kpi = report?.kpi;
        final topProducts = report?.topProductsPreview ?? [];

        return CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(right: 16, left: 16),
              sliver: SliverList.list(
                children: [
                  GridView.count(
                    padding: EdgeInsets.zero,
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.15,
                    children: [
                      CardStat(
                        title: "Total Omzet",
                        value: kpi?.omsetKotor?.displayValue.toString() ?? "",
                        trend:
                            "${kpi?.omsetKotor?.displayTrendPercentage ?? "0"}%",
                        trendDown: kpi?.omsetKotor?.trendDirection == "down",
                        trendUp: kpi?.omsetKotor?.trendDirection == "up",
                        neutral: kpi?.omsetKotor?.trendPercentage == null,
                        isGrid: true,
                      ),
                      CardStat(
                        title: "HPP",
                        value: kpi?.hpp?.displayValue.toString() ?? "",
                        trend: "${kpi?.hpp?.displayTrendPercentage ?? "0"}%",
                        trendDown: kpi?.hpp?.trendDirection == "down",
                        trendUp: kpi?.hpp?.trendDirection == "up",
                        neutral: kpi?.hpp?.trendPercentage == null,
                        isGrid: true,
                      ),
                      CardStat(
                        title: "Laba Kotor",
                        value: kpi?.labaKotor?.displayValue.toString() ?? "",
                        trend:
                            "${kpi?.labaKotor?.displayTrendPercentage ?? "0"}%",
                        trendDown: kpi?.labaKotor?.trendDirection == "down",
                        trendUp: kpi?.labaKotor?.trendDirection == "up",
                        neutral: kpi?.labaKotor?.trendPercentage == null,
                        isGrid: true,
                      ),
                      CardStat(
                        fontSize: 24,
                        title: "Gross Margin",
                        value: "${kpi?.grossMargin?.displayValue}%",
                        trend: kpi?.grossMargin?.displayStatusLabel ?? "",
                        trendUp: kpi?.grossMargin?.status == "healthy",
                        trendDown: kpi?.grossMargin?.status == "critical",
                        neutral: kpi?.grossMargin?.status == null,
                        isGrid: true,
                      ),
                    ],
                  ),
                  const CustomSpacing(height: 12),
                  CardStatWide(
                    title: "Total Nilai Stok di Gudang",
                    value:
                        report?.stockOverview?.displayTotalStockValue
                            .toString() ??
                        "0",
                    subtitle:
                        "${report?.stockOverview?.displayTotalStockQty ?? 0} pcs",
                    trend:
                        "${report?.stockOverview?.totalStockValue?.displayTrendPercentage ?? "0"}%",
                    trendUp:
                        report
                            ?.stockOverview
                            ?.totalStockValue
                            ?.trendDirection ==
                        "up",
                    trendDown:
                        report
                            ?.stockOverview
                            ?.totalStockValue
                            ?.trendDirection ==
                        "down",
                    neutral:
                        report
                            ?.stockOverview
                            ?.totalStockValue
                            ?.trendPercentage ==
                        null,
                  ),
                  const CustomSpacing(height: 12),
                  DoubleLineChart(chart: report?.chart),
                  const CustomSpacing(height: 12),
                ],
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(right: 16, left: 16, bottom: 2),
              sliver: SliverToBoxAdapter(
                child: ListHeader(
                  title: "Produk Terlaris",
                  description: "Berdasarkan omzet periode ini",
                  isArrow: false,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<ReportBloc, ReportState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return Container(
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          color: SupportAppColors.white,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(16),
                          ),
                        ),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    }

                    if (state.isReady) {
                      final restockList = state.report?.topProductsPreview
                          ?.toList();

                      final displayList = restockList?.take(3).toList() ?? [];

                      if (displayList.isEmpty) {
                        return Container(
                          margin: const EdgeInsets.only(top: 2),
                          decoration: BoxDecoration(
                            color: SupportAppColors.white,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(16),
                            ),
                          ),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: CustomText(text: "Belum ada produk"),
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: displayList.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          final e = topProducts[index];
                          final rank = int.tryParse(e.displayRank) ?? index + 1;

                          return Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: ProductItem(
                              rank: index + 1,
                              name: item.displayName,
                              detail: item.displaySpec,
                              price: item.displayOmset,
                              margin: item.displayMarginPercentage,
                              bigPrice: true,
                              bottomLeft: topProducts.length == rank ? 16 : 0,
                              bottomRight: topProducts.length == rank ? 16 : 0,
                            ),
                          );
                        }).toList(),
                      );
                    }

                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24.0),
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        color: SupportAppColors.white,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: SupportAppColors.normalRed,
                            size: 32,
                          ),
                          const CustomSpacing(height: 8),
                          CustomText(
                            text: "Gagal memuat stok",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: SupportAppColors.greyDarkerColor,
                            ),
                          ),
                          const CustomSpacing(height: 4),
                          CustomText(
                            text: "Tarik ke bawah untuk memuat ulang",
                            style: TextStyle(
                              fontSize: 12,
                              color: SupportAppColors.greyColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // SliverPadding(
            //   padding: const EdgeInsets.only(right: 16, left: 16),
            //   sliver: SliverList.builder(
            //     itemCount: topProducts.length,
            //     itemBuilder: (context, index) {
            //       final e = topProducts[index];
            //       final rank = int.tryParse(e.displayRank) ?? index + 1;
            //       return Padding(
            //         padding: const EdgeInsets.only(bottom: 2),
            //         child: ProductItem(
            //           rank: rank,
            //           name: e.displayName,
            //           detail: e.displaySpec,
            //           price: e.displayOmset,
            //           margin: e.displayMarginPercentage,
            //           bigPrice: true,
            //           bottomLeft: topProducts.length == rank ? 16 : 0,
            //           bottomRight: topProducts.length == rank ? 16 : 0,
            //         ),
            //       );
            //     },
            //   ),
            // ),
            const SliverToBoxAdapter(child: CustomSpacing(height: 32)),
            SliverToBoxAdapter(
              child: Container(
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
            ),
            const SliverToBoxAdapter(child: CustomSpacing(height: 42)),
          ],
        );
      },
    );
  }
}
