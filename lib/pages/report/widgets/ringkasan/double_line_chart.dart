import 'dart:math' as math;

import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/models/report/summary_report_model.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/currency_local_formatter.dart';
import 'package:fl_chart/fl_chart.dart';

class DoubleLineChart extends StatelessWidget {
  final ReportChart? chart;

  const DoubleLineChart({super.key, this.chart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      decoration: BoxDecoration(
        color: SupportAppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Omzet vs Laba Kotor",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: SupportAppColors.greyDarkerColor,
                  ),
                ),
                const CustomSpacing(height: 4),
                CustomText(
                  text: "Laba Kotor — belum potong biaya operasional",
                  style: TextStyle(
                    fontSize: 12,
                    color: SupportAppColors.greyColor,
                  ),
                ),
                const CustomSpacing(height: 12),

                /// LEGEND
                Row(
                  children: [
                    _buildLegend(
                      color: SupportAppColors.secondarySoftBlue,
                      label: "Omzet",
                    ),
                    const CustomSpacing(width: 16),
                    _buildLegend(
                      color: SupportAppColors.normalOrange,
                      label: "Laba Kotor",
                    ),
                  ],
                ),
              ],
            ),
          ),

          const CustomSpacing(height: 12),

          RepaintBoundary(child: _ChartContent(chart: chart)),
        ],
      ),
    );
  }

  Widget _buildLegend({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const CustomSpacing(width: 6),
        CustomText(
          text: label,
          style: TextStyle(fontSize: 12, color: SupportAppColors.greyColor),
        ),
      ],
    );
  }
}

class _ChartContent extends StatelessWidget {
  final ReportChart? chart;

  const _ChartContent({this.chart});

  @override
  Widget build(BuildContext context) {
    final omsetSpots = List.generate(
      chart?.omset?.length ?? 0,
      (i) => FlSpot(i.toDouble(), chart!.omset![i].toDouble()),
    );

    final labaSpots = List.generate(
      chart?.labaKotor?.length ?? 0,
      (i) => FlSpot(i.toDouble(), chart!.labaKotor![i].toDouble()),
    );

    final values = [...?chart?.omset, ...?chart?.labaKotor];

    final maxValue = values.isEmpty
        ? 10.0
        : values.reduce((a, b) => a > b ? a : b).toDouble();
    final minValue = values.isEmpty
        ? 0
        : values.reduce((a, b) => a < b ? a : b).toDouble();

    double calcInterval(double maxY) {
      if (maxY <= 0) return 10;
      final raw = maxY / 5;
      final magnitude = math
          .pow(10, (math.log(raw) / math.ln10).floor())
          .toDouble();
      final residual = raw / magnitude;
      double niceResidual;
      if (residual > 5) {
        niceResidual = 10;
      } else if (residual > 2) {
        niceResidual = 5;
      } else if (residual > 1) {
        niceResidual = 2;
      } else {
        niceResidual = 1;
      }
      return niceResidual * magnitude;
    }

    final double chartMinY = minValue < 0 ? minValue * 1.2 : 0;
    final double chartMaxY = maxValue > 0
        ? maxValue * 1.2
        : (minValue < 0 ? 0 : 50.0);
    final double gridInterval = calcInterval(chartMaxY - chartMinY);
    return CustomSpacing(
      height: 250,
      child: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: CustomSpacing(
                width: (chart?.labels?.length ?? 6) * 90,
                child: Padding(
                  padding: const EdgeInsets.only(left: 54),
                  child: LineChart(
                    LineChartData(
                      minX: -0.15,
                      maxX: ((chart?.labels?.length ?? 1) - 1).toDouble(),
                      minY: chartMinY,
                      maxY: chartMaxY,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        verticalInterval: 1,
                        horizontalInterval: gridInterval,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: SupportAppColors.greyMidColor,
                          strokeWidth: 1,
                        ),
                        getDrawingVerticalLine: (value) => FlLine(
                          color: SupportAppColors.greyMidColor,
                          strokeWidth: 0.8,
                          dashArray: [10, 10],
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineTouchData: LineTouchData(
                        enabled: true,
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (touchedSpot) =>
                              SupportAppColors.greyMidTermColor,
                          getTooltipItems: (touchedSpots) => touchedSpots
                              .map(
                                (spot) => LineTooltipItem(
                                  spot.y.toAxisValue(isCurrency: true),
                                  TextStyle(
                                    color: spot.y < 0
                                        ? SupportAppColors.normalRed
                                        : SupportAppColors.normalGreen,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                              .toList(),
                          fitInsideHorizontally: true,
                          fitInsideVertically: true,
                          tooltipBorderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            interval: 1,
                            reservedSize: 48,
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final labels = chart?.labels ?? [];
                              if (value.toInt() < 0 ||
                                  value.toInt() >= labels.length) {
                                return const CustomSpacing();
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 2,
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  constraints: const BoxConstraints(
                                    minWidth: 44,
                                  ),
                                  decoration: BoxDecoration(
                                    color: SupportAppColors.greyMidTermColor,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: CustomText(
                                    text: labels[value.toInt()],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: SupportAppColors.greyColor,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: omsetSpots,
                          isCurved: false,
                          color: SupportAppColors.secondarySoftBlue,
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                SupportAppColors.secondarySoftBlue.withValues(
                                  alpha: 0.15,
                                ),
                                SupportAppColors.secondarySoftBlue.withValues(
                                  alpha: 0.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        LineChartBarData(
                          spots: labaSpots,
                          isCurved: false,
                          color: SupportAppColors.normalOrange,
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                SupportAppColors.normalOrange.withValues(
                                  alpha: 0.15,
                                ),
                                SupportAppColors.normalOrange.withValues(
                                  alpha: 0.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Container(
                width: 90,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      SupportAppColors.white,
                      SupportAppColors.white,
                      SupportAppColors.white.withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
                padding: const EdgeInsets.only(left: 16, top: 24, bottom: 48),
                child: CustomSpacing(
                  width: 42,
                  child: LineChart(
                    LineChartData(
                      minY: chartMinY,
                      maxY: chartMaxY,
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        show: true,
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: gridInterval,
                            reservedSize: 72,
                            getTitlesWidget: (value, meta) {
                              if (value == 0) return const CustomSpacing();
                              return CustomText(
                                text: value.toAxisValue(isCurrency: true),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: SupportAppColors.greyColor,
                                ),
                              );
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
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
