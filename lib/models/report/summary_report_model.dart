import 'dart:convert';

import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/helper/json_parse_helpers.dart';
import 'package:arena/helper/safe_helpers.dart';

ReportSummaryModel reportSummaryModelFromJson(String str) =>
    ReportSummaryModel.fromJson(json.decode(str));

String reportSummaryModelToJson(ReportSummaryModel data) =>
    json.encode(data.toJson());

ReportSummaryModel parseReportSummary(String json) =>
    ReportSummaryModel.fromJson(jsonDecode(json) as Map<String, dynamic>);

class ReportSummaryModel {
  bool? success;
  String? message;
  ReportSummaryData? data;

  ReportSummaryModel({this.success, this.message, this.data});

  factory ReportSummaryModel.fromJson(Map<String, dynamic> json) {
    final dataJson = jsonMap(json, "data");
    return ReportSummaryModel(
      success: jsonBool(json, "success"),
      message: jsonString(json, "message"),
      data: dataJson != null ? ReportSummaryData.fromJson(dataJson) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class ReportSummaryData {
  Period? period;
  Kpi? kpi;
  ReportChart? chart;
  StockOverview? stockOverview;
  List<TopProductsPreview>? topProductsPreview;

  ReportSummaryData({
    this.period,
    this.kpi,
    this.chart,
    this.stockOverview,
    this.topProductsPreview,
  });

  factory ReportSummaryData.fromJson(Map<String, dynamic> json) {
    final periodJson = jsonMap(json, "period");
    final kpiJson = jsonMap(json, "kpi");
    final chartJson = jsonMap(json, "chart");
    final stockOverviewJson = jsonMap(json, "stock_overview");
    return ReportSummaryData(
      period: periodJson != null ? Period.fromJson(periodJson) : null,
      kpi: kpiJson != null ? Kpi.fromJson(kpiJson) : null,
      chart: chartJson != null ? ReportChart.fromJson(chartJson) : null,
      stockOverview: stockOverviewJson != null
          ? StockOverview.fromJson(stockOverviewJson)
          : null,
      topProductsPreview: jsonMapList(
        json,
        "top_products_preview",
      ).map((e) => TopProductsPreview.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "period": period?.toJson(),
    "kpi": kpi?.toJson(),
    "chart": chart?.toJson(),
    "stock_overview": stockOverview?.toJson(),
    "top_products_preview": topProductsPreview == null
        ? []
        : List<dynamic>.from(topProductsPreview!.map((x) => x.toJson())),
  };
}

class ReportChart {
  List<String>? labels;
  List<num>? omset;
  List<num>? labaKotor;

  ReportChart({this.labels, this.omset, this.labaKotor});

  factory ReportChart.fromJson(Map<String, dynamic> json) => ReportChart(
    labels: jsonStringList(json, "labels"),
    omset: jsonNumList(json, "omset"),
    labaKotor: jsonNumList(json, "laba_kotor"),
  );

  Map<String, dynamic> toJson() => {
    "labels": labels == null ? [] : List<dynamic>.from(labels!.map((x) => x)),
    "omset": omset == null ? [] : List<dynamic>.from(omset!.map((x) => x)),
    "laba_kotor": labaKotor == null
        ? []
        : List<dynamic>.from(labaKotor!.map((x) => x)),
  };
}

class Kpi {
  Hpp? omsetKotor;
  Hpp? hpp;
  Hpp? labaKotor;
  GrossMargin? grossMargin;
  Hpp? labaBersih;
  Hpp? totalItemsSold;

  Kpi({
    this.omsetKotor,
    this.hpp,
    this.labaKotor,
    this.grossMargin,
    this.labaBersih,
    this.totalItemsSold,
  });

  factory Kpi.fromJson(Map<String, dynamic> json) {
    final omsetJson = jsonMap(json, "omset_kotor");
    final hppJson = jsonMap(json, "hpp");
    final labaJson = jsonMap(json, "laba_kotor");
    final grossMarginJson = jsonMap(json, "gross_margin");
    final labaBersihJson = jsonMap(json, "laba_bersih");
    final itemsSoldJson = jsonMap(json, "total_items_sold");
    return Kpi(
      omsetKotor: omsetJson != null ? Hpp.fromJson(omsetJson) : null,
      hpp: hppJson != null ? Hpp.fromJson(hppJson) : null,
      labaKotor: labaJson != null ? Hpp.fromJson(labaJson) : null,
      grossMargin: grossMarginJson != null
          ? GrossMargin.fromJson(grossMarginJson)
          : null,
      labaBersih: labaBersihJson != null ? Hpp.fromJson(labaBersihJson) : null,
      totalItemsSold: itemsSoldJson != null
          ? Hpp.fromJson(itemsSoldJson)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "omset_kotor": omsetKotor?.toJson(),
    "hpp": hpp?.toJson(),
    "laba_kotor": labaKotor?.toJson(),
    "gross_margin": grossMargin?.toJson(),
    "laba_bersih": labaBersih?.toJson(),
    "total_items_sold": totalItemsSold?.toJson(),
  };
}

class GrossMargin {
  num? value;
  String? status;
  String? statusLabel;

  GrossMargin({this.value, this.status, this.statusLabel});

  String get displayValue => safeString(value);
  String get displayStatusLabel => safeString(statusLabel);

  factory GrossMargin.fromJson(Map<String, dynamic> json) => GrossMargin(
    value: jsonNum(json, "value"),
    status: jsonString(json, "status"),
    statusLabel: jsonString(json, "status_label"),
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "status": status,
    "status_label": statusLabel,
  };
}

class Hpp {
  num? value;
  num? trendPercentage;
  String? trendDirection;
  String? note;

  Hpp({this.value, this.trendPercentage, this.trendDirection, this.note});

  String get displayValue => safeString(value?.toLocaleCurrency());
  String get displayRawValue => safeString(value);
  String get displayTrendPercentage => safeString(trendPercentage);

  factory Hpp.fromJson(Map<String, dynamic> json) => Hpp(
    value: jsonNum(json, "value"),
    trendPercentage: jsonNum(json, "trend_percentage"),
    trendDirection: jsonString(json, "trend_direction"),
    note: jsonString(json, "note"),
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "trend_percentage": trendPercentage,
    "trend_direction": trendDirection,
    "note": note,
  };
}

class Period {
  String? type;
  DateTime? startDate;
  DateTime? endDate;

  Period({this.type, this.startDate, this.endDate});

  factory Period.fromJson(Map<String, dynamic> json) {
    final start = jsonString(json, "start_date");
    final end = jsonString(json, "end_date");
    return Period(
      type: jsonString(json, "type"),
      startDate: start != null ? DateTime.tryParse(start) : null,
      endDate: end != null ? DateTime.tryParse(end) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "type": type,
    "start_date": startDate == null
        ? null
        : "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    "end_date": endDate == null
        ? null
        : "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
  };
}

class StockOverview {
  Hpp? totalStockQty;
  Hpp? totalStockValue;

  StockOverview({this.totalStockQty, this.totalStockValue});

  String get displayTotalStockQty => totalStockQty?.displayRawValue ?? "-";
  String get displayTotalStockValue => totalStockValue?.displayValue ?? "-";

  factory StockOverview.fromJson(Map<String, dynamic> json) {
    final qtyJson = jsonMap(json, "total_stock_qty");
    final valueJson = jsonMap(json, "total_stock_value");
    return StockOverview(
      totalStockQty: qtyJson != null ? Hpp.fromJson(qtyJson) : null,
      totalStockValue: valueJson != null ? Hpp.fromJson(valueJson) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "total_stock_qty": totalStockQty?.toJson(),
    "total_stock_value": totalStockValue?.toJson(),
  };
}

class TopProductsPreview {
  int? rank;
  String? productId;
  String? name;
  String? size;
  String? ring;
  String? spec;
  int? qtySold;
  num? omset;
  num? laba;
  num? marginPercentage;

  TopProductsPreview({
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

  String get displayRank => safeString(rank);
  String get displayName => safeString(name);
  String get displaySpec => safeString(spec);
  String get displayOmset => safeString(omset?.toLocaleCurrency());
  String get displayMarginPercentage => safeString(marginPercentage);

  factory TopProductsPreview.fromJson(Map<String, dynamic> json) =>
      TopProductsPreview(
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

  Map<String, dynamic> toJson() => {
    "rank": rank,
    "product_id": productId,
    "name": name,
    "size": size,
    "ring": ring,
    "spec": spec,
    "qty_sold": qtySold,
    "omset": omset,
    "laba": laba,
    "margin_percentage": marginPercentage,
  };
}
