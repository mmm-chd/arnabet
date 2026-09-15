import 'dart:convert';

import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/helper/json_parse_helpers.dart';
import 'package:arena/helper/safe_helpers.dart';

StockHealthModel parseStockHealth(String json) =>
    StockHealthModel.fromJson(jsonDecode(json) as Map<String, dynamic>);

class StockHealthModel {
  final bool? success;
  final String? message;
  final StockHealthData? data;

  StockHealthModel({this.success, this.message, this.data});

  factory StockHealthModel.fromJson(Map<String, dynamic> json) {
    final dataJson = jsonMap(json, "data");
    return StockHealthModel(
      success: jsonBool(json, "success"),
      message: jsonString(json, "message"),
      data: dataJson != null ? StockHealthData.fromJson(dataJson) : null,
    );
  }
}

class StockHealthData {
  final StockHealthPeriod? period;
  final String? asOf;
  final StockOverview? overview;
  final List<StockAging>? aging;
  final List<LowStockAlert>? lowStockAlerts;

  String get displayAsOf => safeDate(asOf);

  StockHealthData({
    this.period,
    this.asOf,
    this.overview,
    this.aging,
    this.lowStockAlerts,
  });

  factory StockHealthData.fromJson(Map<String, dynamic> json) {
    final periodJson = jsonMap(json, "period");
    final overviewJson = jsonMap(json, "overview");
    return StockHealthData(
      period: periodJson != null
          ? StockHealthPeriod.fromJson(periodJson)
          : null,
      asOf: jsonString(json, "as_of"),
      overview: overviewJson != null
          ? StockOverview.fromJson(overviewJson)
          : null,
      aging: jsonMapList(
        json,
        "aging",
      ).map((e) => StockAging.fromJson(e)).toList(),
      lowStockAlerts: jsonMapList(
        json,
        "low_stock_alerts",
      ).map((e) => LowStockAlert.fromJson(e)).toList(),
    );
  }
}

class StockHealthPeriod {
  final String? type;
  final String? startDate;
  final String? endDate;

  StockHealthPeriod({this.type, this.startDate, this.endDate});

  factory StockHealthPeriod.fromJson(Map<String, dynamic> json) {
    return StockHealthPeriod(
      type: jsonString(json, "type"),
      startDate: jsonString(json, "start_date"),
      endDate: jsonString(json, "end_date"),
    );
  }

  String get displayType => safeString(type);
}

class TrendValueQty {
  final num? value;
  final num? trendPercentage;
  final String? trendDirection;

  String get displayValue => safeString(value);
  String get displayTrendPercentage => safeString(trendPercentage);
  String get displayTrendDirection => safeString(trendDirection);

  TrendValueQty({this.value, this.trendPercentage, this.trendDirection});

  factory TrendValueQty.fromJson(Map<String, dynamic> json) {
    return TrendValueQty(
      value: jsonNum(json, "value"),
      trendPercentage: jsonNum(json, "trend_percentage"),
      trendDirection: jsonString(json, "trend_direction"),
    );
  }
}

class TrendValue {
  final num? value;
  final num? trendPercentage;
  final String? trendDirection;

  String get displayValue => safeString(value?.toLocaleCurrency());
  String get displayTrendPercentage => safeString(trendPercentage);
  String get displayTrendDirection => safeString(trendDirection);

  TrendValue({this.value, this.trendPercentage, this.trendDirection});

  factory TrendValue.fromJson(Map<String, dynamic> json) {
    return TrendValue(
      value: jsonNum(json, "value"),
      trendPercentage: jsonNum(json, "trend_percentage"),
      trendDirection: jsonString(json, "trend_direction"),
    );
  }
}

class StockOverview {
  final TrendValueQty? totalStockQty;
  final TrendValue? totalStockValue;

  StockOverview({this.totalStockQty, this.totalStockValue});

  factory StockOverview.fromJson(Map<String, dynamic> json) {
    final qtyJson = jsonMap(json, "total_stock_qty");
    final valueJson = jsonMap(json, "total_stock_value");
    return StockOverview(
      totalStockQty: qtyJson != null ? TrendValueQty.fromJson(qtyJson) : null,
      totalStockValue: valueJson != null
          ? TrendValue.fromJson(valueJson)
          : null,
    );
  }
}

class StockAging {
  final String? bracket;
  final String? label;
  final num? totalValue;
  final int? totalSkus;
  final int? totalQty;
  final num? volumePercentage;
  final bool? isHighlight;

  String get displayBracket => safeString(bracket);
  String get displayLabel => safeString(label);
  String get displayTotalValue => safeString(totalValue?.toLocaleCurrency());
  String get displayTotalSkus => safeString(totalSkus);
  String get displayTotalQty => safeString(totalQty);
  String get displayVolumePercentage => safeString(volumePercentage);
  String get displayVolumePercentageLabel =>
      '${safeString(volumePercentage, fallback: '0')}%';
  bool get isHighlighted => isHighlight == true;

  StockAging({
    this.bracket,
    this.label,
    this.totalValue,
    this.totalSkus,
    this.totalQty,
    this.volumePercentage,
    this.isHighlight,
  });

  factory StockAging.fromJson(Map<String, dynamic> json) {
    return StockAging(
      bracket: jsonString(json, "bracket"),
      label: jsonString(json, "label"),
      totalValue: jsonNum(json, "total_value"),
      totalSkus: jsonInt(json, "total_skus"),
      totalQty: jsonInt(json, "total_qty"),
      volumePercentage: jsonNum(json, "volume_percentage"),
      isHighlight: jsonBool(json, "is_highlight"),
    );
  }
}

class LowStockAlert {
  final int? rank;
  final String? productId;
  final String? name;
  final String? size;
  final String? ring;
  final String? spec;
  final int? currentQty;
  final String? status;

  String get displayRank => safeString(rank);
  String get displayName => safeString(name);
  String get displaySize => safeString(size);
  String get displayRing => safeString(ring);
  String get displaySpec => safeString(spec);
  String get displayCurrentQty => safeString(currentQty);
  String get displayStatus => safeString(status);

  LowStockAlert({
    this.rank,
    this.productId,
    this.name,
    this.size,
    this.ring,
    this.spec,
    this.currentQty,
    this.status,
  });

  factory LowStockAlert.fromJson(Map<String, dynamic> json) {
    return LowStockAlert(
      rank: jsonInt(json, "rank"),
      productId: jsonString(json, "product_id"),
      name: jsonString(json, "name"),
      size: jsonString(json, "size"),
      ring: jsonString(json, "ring"),
      spec: jsonString(json, "spec"),
      currentQty: jsonInt(json, "current_qty"),
      status: jsonString(json, "status"),
    );
  }
}
