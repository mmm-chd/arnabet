import 'dart:convert';

import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/helper/json_parse_helpers.dart';
import 'package:arena/helper/safe_helpers.dart';

TopProductsModel parseTopProducts(String json) =>
    TopProductsModel.fromJson(jsonDecode(json) as Map<String, dynamic>);

class TopProductsModel {
  final bool? success;
  final String? message;
  final TopProductsData? data;

  TopProductsModel({this.success, this.message, this.data});

  factory TopProductsModel.fromJson(Map<String, dynamic> json) {
    final dataJson = jsonMap(json, "data");
    return TopProductsModel(
      success: jsonBool(json, "success"),
      message: jsonString(json, "message"),
      data: dataJson != null ? TopProductsData.fromJson(dataJson) : null,
    );
  }
}

class TopProductsData {
  final ReportPeriod? period;
  final TopProductsSummary? summary;
  final List<TopProduct>? products;
  final TopProductsTotals? totals;
  final TopProductsChart? chart;

  TopProductsData({
    this.period,
    this.summary,
    this.products,
    this.totals,
    this.chart,
  });

  factory TopProductsData.fromJson(Map<String, dynamic> json) {
    final periodJson = jsonMap(json, "period");
    final summaryJson = jsonMap(json, "summary");
    final totalsJson = jsonMap(json, "totals");
    final chartJson = jsonMap(json, "chart");
    return TopProductsData(
      period: periodJson != null ? ReportPeriod.fromJson(periodJson) : null,
      summary: summaryJson != null
          ? TopProductsSummary.fromJson(summaryJson)
          : null,
      products: jsonMapList(
        json,
        "products",
      ).map((e) => TopProduct.fromJson(e)).toList(),
      totals: totalsJson != null
          ? TopProductsTotals.fromJson(totalsJson)
          : null,
      chart: chartJson != null ? TopProductsChart.fromJson(chartJson) : null,
    );
  }
}

class ReportPeriod {
  final String? type;
  final String? startDate;
  final String? endDate;

  ReportPeriod({this.type, this.startDate, this.endDate});

  factory ReportPeriod.fromJson(Map<String, dynamic> json) {
    return ReportPeriod(
      type: jsonString(json, "type"),
      startDate: jsonString(json, "start_date"),
      endDate: jsonString(json, "end_date"),
    );
  }

  String get displayType => safeString(type);
}

class TopProductsSummary {
  final TrendValue? omsetKotor;
  final TrendValueItem? totalItemsSold;
  final TrendValueItem? totalTransactions;
  final TrendValue? avgOrderValue;

  TopProductsSummary({
    this.omsetKotor,
    this.totalItemsSold,
    this.totalTransactions,
    this.avgOrderValue,
  });

  factory TopProductsSummary.fromJson(Map<String, dynamic> json) {
    final omsetJson = jsonMap(json, "omset_kotor");
    final itemsJson = jsonMap(json, "total_items_sold");
    final transactionsJson = jsonMap(json, "total_transactions");
    final avgJson = jsonMap(json, "avg_order_value");
    return TopProductsSummary(
      omsetKotor: omsetJson != null ? TrendValue.fromJson(omsetJson) : null,
      totalItemsSold: itemsJson != null
          ? TrendValueItem.fromJson(itemsJson)
          : null,
      totalTransactions: transactionsJson != null
          ? TrendValueItem.fromJson(transactionsJson)
          : null,
      avgOrderValue: avgJson != null ? TrendValue.fromJson(avgJson) : null,
    );
  }
}

class TrendValue {
  final num? value;
  final num? trendPercentage;
  final String? trendDirection;

  TrendValue({this.value, this.trendPercentage, this.trendDirection});

  factory TrendValue.fromJson(Map<String, dynamic> json) {
    return TrendValue(
      value: jsonNum(json, "value"),
      trendPercentage: jsonNum(json, "trend_percentage"),
      trendDirection: jsonString(json, "trend_direction"),
    );
  }

  String get displayValue => safeString(value?.toLocaleCurrency());
  String get displayTrendPercentage => safeString(trendPercentage);
  String get displayTrendDirection => safeString(trendDirection);
}

class TrendValueItem {
  final num? value;
  final num? trendPercentage;
  final String? trendDirection;

  TrendValueItem({this.value, this.trendPercentage, this.trendDirection});

  factory TrendValueItem.fromJson(Map<String, dynamic> json) {
    return TrendValueItem(
      value: jsonNum(json, "value"),
      trendPercentage: jsonNum(json, "trend_percentage"),
      trendDirection: jsonString(json, "trend_direction"),
    );
  }

  String get displayValue => safeString(value);
  String get displayTrendPercentage => safeString(trendPercentage);
  String get displayTrendDirection => safeString(trendDirection);
}

class TopProduct {
  final int? rank;
  final String? productId;
  final String? name;
  final String? size;
  final String? ring;
  final String? spec;
  final int? qtySold;
  final num? omset;
  final num? laba;
  final num? marginPercentage;

  TopProduct({
    this.rank,
    this.productId,
    this.name,
    this.size,
    this.ring,
    this.spec,
    this.qtySold,
    this.omset,
    this.laba,
    this.marginPercentage,
  });

  factory TopProduct.fromJson(Map<String, dynamic> json) {
    return TopProduct(
      rank: jsonInt(json, "rank"),
      productId: jsonString(json, "product_id"),
      name: jsonString(json, "name"),
      size: jsonString(json, "size"),
      ring: jsonString(json, "ring"),
      spec: jsonString(json, "spec"),
      qtySold: jsonInt(json, "qty_sold"),
      omset: jsonNum(json, "omset"),
      laba: jsonNum(json, "laba"),
      marginPercentage: jsonNum(json, "margin_percentage"),
    );
  }

  String get displayRank => safeString(rank);
  String get displayProductId => safeString(productId);
  String get displayName => safeString(name);
  String get displaySize => safeString(size);
  String get displayRing => safeString(ring);
  String get displaySpec => safeString(spec);
  String get displayQtySold => safeString(qtySold);
  String get displayOmset => safeString(omset?.toLocaleCurrency());
  String get displayLaba => safeString(laba?.toLocaleCurrency());
  String get displayMarginPercentage => safeString(marginPercentage);
}

class TopProductsTotals {
  final int? qtySold;
  final num? omset;
  final num? laba;
  final num? marginPercentage;

  TopProductsTotals({
    this.qtySold,
    this.omset,
    this.laba,
    this.marginPercentage,
  });

  factory TopProductsTotals.fromJson(Map<String, dynamic> json) {
    return TopProductsTotals(
      qtySold: jsonInt(json, "qty_sold"),
      omset: jsonNum(json, "omset"),
      laba: jsonNum(json, "laba"),
      marginPercentage: jsonNum(json, "margin_percentage"),
    );
  }

  String get displayQtySold => safeString(qtySold);
  String get displayOmset => safeString(omset?.toLocaleCurrency());
  String get displayLaba => safeString(laba?.toLocaleCurrency());
  String get displayMarginPercentage => safeString(marginPercentage);
}

class TopProductsChart {
  final List<String>? labels;
  final List<num>? omset;

  TopProductsChart({this.labels, this.omset});

  factory TopProductsChart.fromJson(Map<String, dynamic> json) {
    return TopProductsChart(
      labels: jsonStringList(json, "labels"),
      omset: jsonNumList(json, "omset"),
    );
  }
}
