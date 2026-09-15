import 'dart:math' as math;

import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/currency_local_formatter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DoubleBarChart extends StatefulWidget {
  final double? bottomLeft, bottomRight, topLeft, topRight;
  final List<String>? labels;
  final List<int>? incoming;
  final List<int>? outgoing;
  final String? subtitle;

  const DoubleBarChart({
    super.key,
    this.bottomLeft,
    this.bottomRight,
    this.topLeft,
    this.topRight,
    this.labels,
    this.incoming,
    this.outgoing,
    this.subtitle,
  });

  @override
  State<DoubleBarChart> createState() => _DoubleBarChartState();
}

class _DoubleBarChartState extends State<DoubleBarChart> {
  final ScrollController _scrollController = ScrollController();
  Color? _touchedRodColor;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<String> get _labels => widget.labels ?? const [];

  List<int> get _incoming => widget.incoming ?? const [];
  List<int> get _outgoing => widget.outgoing ?? const [];

  int get _pointCount {
    final n = _incoming.length < _outgoing.length
        ? _incoming.length
        : _outgoing.length;
    return _labels.isNotEmpty && _labels.length < n ? _labels.length : n;
  }

  bool get _hasData => _pointCount > 0;

  bool get _showChart => _hasData || _labels.isNotEmpty;

  double get _chartWidth {
    final n = _pointCount > 0 ? _pointCount : _labels.length;
    if (n <= 0) return 880;
    return n * 120;
  }

  String get _subtitle {
    if (widget.subtitle != null) return widget.subtitle!;
    if (_labels.isNotEmpty) {
      return _labels.length == 1
          ? _labels.first
          : "${_labels.first} – ${_labels.last}";
    }
    return "";
  }

  int get _peak {
    var peak = 0;
    for (final v in _incoming) {
      if (v > peak) peak = v;
    }
    for (final v in _outgoing) {
      if (v > peak) peak = v;
    }
    return peak;
  }

  int get _trough {
    var trough = 0;
    for (final v in _incoming) {
      if (v < trough) trough = v;
    }
    for (final v in _outgoing) {
      if (v < trough) trough = v;
    }
    return trough;
  }

  double get _minY {
    if (_trough >= 0) return 0;
    return _trough * 1.2;
  }

  double get _maxY {
    if (_peak <= 0) {
      if (_trough < 0) return 0;
      return 10;
    }
    return _peak * 1.2;
  }

  double get _yInterval => _calcInterval(_maxY - _minY);

  double _calcInterval(double maxY) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      decoration: BoxDecoration(
        color: SupportAppColors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(widget.bottomLeft ?? 16),
          bottomRight: Radius.circular(widget.bottomRight ?? 16),
          topLeft: Radius.circular(widget.topLeft ?? 16),
          topRight: Radius.circular(widget.topRight ?? 16),
        ),
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
                  text: "Pergerakan Stok",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: SupportAppColors.greyDarkerColor,
                  ),
                ),
                CustomText(
                  text: _subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: SupportAppColors.greyColor,
                  ),
                ),
                const CustomSpacing(height: 12),
                Row(
                  children: [
                    _buildLegend(
                      color: SupportAppColors.secondarySoftBlue,
                      label: "Barang Masuk",
                    ),
                    const CustomSpacing(width: 16),
                    _buildLegend(
                      color: SupportAppColors.secondaryYellow,
                      label: "Barang Keluar",
                    ),
                  ],
                ),
              ],
            ),
          ),
          CustomSpacing(
            height: 250,
            child: _showChart
                ? Stack(
                    children: [
                      Positioned.fill(
                        child: Scrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          thickness: 4,
                          radius: const Radius.circular(8),
                          scrollbarOrientation: ScrollbarOrientation.bottom,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            physics: const ClampingScrollPhysics(),
                            child: CustomSpacing(
                              width: _chartWidth,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 54,
                                  bottom: 8,
                                ),
                                child: BarChart(
                                  BarChartData(
                                    alignment: BarChartAlignment.spaceAround,
                                    maxY: _maxY,
                                    minY: _minY,
                                    gridData: FlGridData(
                                      show: true,
                                      drawVerticalLine: true,
                                      verticalInterval: 1,
                                      horizontalInterval: _yInterval,
                                      getDrawingHorizontalLine: (value) =>
                                          FlLine(
                                            color:
                                                SupportAppColors.greyMidColor,
                                            strokeWidth: 1,
                                          ),
                                      getDrawingVerticalLine: (value) => FlLine(
                                        color: SupportAppColors.greyMidColor,
                                        strokeWidth: 0.8,
                                        dashArray: [10, 10],
                                      ),
                                    ),
                                    borderData: FlBorderData(show: false),
                                    barTouchData: BarTouchData(
                                      touchCallback: (event, response) {
                                        final color = response?.spot
                                            ?.touchedRodData
                                            .color;
                                        if (color != _touchedRodColor) {
                                          setState(() {
                                            _touchedRodColor = color;
                                          });
                                        }
                                      },
                                      touchTooltipData: BarTouchTooltipData(
                                        getTooltipColor: (_) =>
                                            _touchedRodColor ??
                                            SupportAppColors.greyMidTermColor,
                                        getTooltipItem:
                                            (group, groupIndex, rod, rodIndex) {
                                          return BarTooltipItem(
                                            rod.toY.toInt().toString(),
                                            TextStyle(
                                              color: rod.toY < 0
                                                  ? SupportAppColors.normalRed
                                                  : SupportAppColors
                                                        .normalGreen,
                                              backgroundColor:
                                                  rod.color ??
                                                  SupportAppColors
                                                      .greyMidTermColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          );
                                        },
                                        fitInsideHorizontally: true,
                                        fitInsideVertically: true,
                                        tooltipBorderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                    ),
                                    titlesData: FlTitlesData(
                                      show: true,
                                      leftTitles: const AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                      rightTitles: const AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                      topTitles: const AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          interval: 1,
                                          reservedSize: 48,
                                          getTitlesWidget: (value, meta) {
                                            final labels = _labels;
                                            final idx = value.toInt() - 1;
                                            if (idx < 0 ||
                                                idx >= labels.length) {
                                              return const CustomSpacing();
                                            }
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 2,
                                                  ),
                                              child: Container(
                                                alignment: Alignment.center,
                                                constraints:
                                                    const BoxConstraints(
                                                      minWidth: 44,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: SupportAppColors
                                                      .greyMidTermColor,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                    ),
                                                child: CustomText(
                                                  text: labels[idx],
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: SupportAppColors
                                                        .greyColor,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    barGroups: _buildBarGroups(),
                                  ),
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
                            width: 70,
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
                            padding: const EdgeInsets.only(
                              left: 16,
                              top: 24,
                              bottom: 48,
                            ),
                            child: CustomSpacing(
                              width: 32,
                              child: BarChart(
                                BarChartData(
                                  minY: _minY,
                                  maxY: _maxY,
                                  gridData: const FlGridData(show: false),
                                  borderData: FlBorderData(show: false),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: _yInterval,
                                        reservedSize: 32,
                                        getTitlesWidget: (value, meta) {
                                          if (value == 0) {
                                            return const CustomSpacing();
                                          }
                                          return CustomText(
                                            text: value.toAxisValue(),
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: SupportAppColors
                                                  .greyDarkColor,
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
                  )
                : Center(
                    child: CustomText(
                      text: "Belum ada data pergerakan stok",
                      style: TextStyle(
                        fontSize: 14,
                        color: SupportAppColors.greyColor,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    if (!_hasData) {
      return List.generate(_labels.length, (i) {
        return BarChartGroupData(
          x: i + 1,
          barsSpace: 4,
          barRods: [
            BarChartRodData(
              toY: 1,
              color: SupportAppColors.greyMidTermColor,
              width: 6,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        );
      });
    }

    final count = _pointCount;

    return List.generate(count, (i) {
      return BarChartGroupData(
        x: i + 1,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: _incoming[i].toDouble(),
            color: SupportAppColors.secondarySoftBlue,
            width: 12,
            borderRadius: BorderRadius.circular(4),
          ),
          BarChartRodData(
            toY: _outgoing[i].toDouble(),
            color: SupportAppColors.secondaryYellow,
            width: 12,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
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
