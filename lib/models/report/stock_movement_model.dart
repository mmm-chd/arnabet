import 'dart:convert';

import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/helper/json_parse_helpers.dart';
import 'package:arena/helper/safe_helpers.dart';

StockMovementModel parseStockMovement(String json) =>
    StockMovementModel.fromJson(jsonDecode(json) as Map<String, dynamic>);

class StockMovementModel {
  final bool? success;
  final String? message;
  final StockMovementData? data;

  StockMovementModel({this.success, this.message, this.data});

  factory StockMovementModel.fromJson(Map<String, dynamic> json) {
    final dataJson = jsonMap(json, "data");
    return StockMovementModel(
      success: jsonBool(json, "success"),
      message: jsonString(json, "message"),
      data: dataJson != null ? StockMovementData.fromJson(dataJson) : null,
    );
  }
}

class StockMovementData {
  final MovementPeriod? period;
  final MovementKpi? kpi;
  final MovementSummary? movementSummary;
  final MovementChart? chart;

  StockMovementData({this.period, this.kpi, this.movementSummary, this.chart});

  factory StockMovementData.fromJson(Map<String, dynamic> json) {
    final periodJson = jsonMap(json, "period");
    final kpiJson = jsonMap(json, "kpi");
    final movementSummaryJson = jsonMap(json, "movement_summary");
    final chartJson = jsonMap(json, "chart");
    return StockMovementData(
      period: periodJson != null ? MovementPeriod.fromJson(periodJson) : null,
      kpi: kpiJson != null ? MovementKpi.fromJson(kpiJson) : null,
      movementSummary: movementSummaryJson != null
          ? MovementSummary.fromJson(movementSummaryJson)
          : null,
      chart: chartJson != null ? MovementChart.fromJson(chartJson) : null,
    );
  }
}

class MovementPeriod {
  final String? type;
  final String? startDate;
  final String? endDate;

  MovementPeriod({this.type, this.startDate, this.endDate});

  factory MovementPeriod.fromJson(Map<String, dynamic> json) {
    return MovementPeriod(
      type: jsonString(json, "type"),
      startDate: jsonString(json, "start_date"),
      endDate: jsonString(json, "end_date"),
    );
  }

  String get displayType => safeString(type);
}

class MovementKpi {
  final MovementItem? incoming;
  final MovementItem? outgoing;
  final MovementItem? adjustment;

  MovementKpi({this.incoming, this.outgoing, this.adjustment});

  factory MovementKpi.fromJson(Map<String, dynamic> json) {
    final incomingJson = jsonMap(json, "incoming");
    final outgoingJson = jsonMap(json, "outgoing");
    final adjustmentJson = jsonMap(json, "adjustment");
    return MovementKpi(
      incoming: incomingJson != null
          ? MovementItem.fromJson(incomingJson)
          : null,
      outgoing: outgoingJson != null
          ? MovementItem.fromJson(outgoingJson)
          : null,
      adjustment: adjustmentJson != null
          ? MovementItem.fromJson(adjustmentJson)
          : null,
    );
  }
}

class MovementItem {
  final int? qty;
  final int? value;
  final double? trendPercentage;
  final String? trendDirection;

  MovementItem({
    this.qty,
    this.value,
    this.trendPercentage,
    this.trendDirection,
  });

  factory MovementItem.fromJson(Map<String, dynamic> json) {
    return MovementItem(
      qty: jsonInt(json, "qty"),
      value: jsonInt(json, "value"),
      trendPercentage: jsonNum(json, "trend_percentage")?.toDouble(),
      trendDirection: jsonString(json, "trend_direction"),
    );
  }

  String get displayQty => safeString(qty);
  String get displayValue => safeString(value?.toLocaleCurrency());
  String get displayTrendPercentage => safeString(trendPercentage);
  String get displayTrendDirection => safeString(trendDirection);
}

class MovementSummary {
  final int? openingStock;
  final int? incoming;
  final int? outgoing;
  final int? adjustment;
  final int? closingStock;

  MovementSummary({
    this.openingStock,
    this.incoming,
    this.outgoing,
    this.adjustment,
    this.closingStock,
  });

  factory MovementSummary.fromJson(Map<String, dynamic> json) {
    return MovementSummary(
      openingStock: jsonInt(json, "opening_stock"),
      incoming: jsonInt(json, "incoming"),
      outgoing: jsonInt(json, "outgoing"),
      adjustment: jsonInt(json, "adjustment"),
      closingStock: jsonInt(json, "closing_stock"),
    );
  }

  String get displayOpeningStock => safeString(openingStock);
  String get displayIncoming => safeString(incoming);
  String get displayOutgoing => safeString(outgoing);
  String get displayAdjustment => safeString(adjustment);
  String get displayClosingStock => safeString(closingStock);
}

class MovementChart {
  final List<String>? labels;
  final List<int>? incoming;
  final List<int>? outgoing;

  MovementChart({this.labels, this.incoming, this.outgoing});

  factory MovementChart.fromJson(Map<String, dynamic> json) {
    return MovementChart(
      labels: jsonStringList(json, "labels"),
      incoming: jsonIntList(json, "incoming"),
      outgoing: jsonIntList(json, "outgoing"),
    );
  }
}
