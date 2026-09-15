import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/helper/safe_helpers.dart';

class DashboardModel {
  final bool? success;
  final String? message;
  final DashboardData? data;

  DashboardModel({this.success, this.message, this.data});

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] != null ? DashboardData.fromJson(json["data"]) : null,
    );
  }
}

class DashboardData {
  final DashboardPeriod? period;
  final DashboardCatalog? catalog;
  final DashboardSales? sales;
  final DashboardMovement? movement;
  final MovementChart? chart;

  DashboardData({
    this.period,
    this.catalog,
    this.sales,
    this.movement,
    this.chart,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      period: json["period"] != null
          ? DashboardPeriod.fromJson(json["period"])
          : null,
      catalog: json["catalog"] != null
          ? DashboardCatalog.fromJson(json["catalog"])
          : null,
      sales: json["sales"] != null
          ? DashboardSales.fromJson(json["sales"])
          : null,
      movement: json["movement"] != null
          ? DashboardMovement.fromJson(json["movement"])
          : null,
      chart: json["chart"] != null
          ? MovementChart.fromJson(json["chart"])
          : null,
    );
  }
}

class DashboardPeriod {
  final String? type;
  final String? startDate;
  final String? endDate;

  DashboardPeriod({this.type, this.startDate, this.endDate});

  factory DashboardPeriod.fromJson(Map<String, dynamic> json) {
    return DashboardPeriod(
      type: json["type"],
      startDate: json["start_date"],
      endDate: json["end_date"],
    );
  }
}

class DashboardCatalog {
  final int? totalProducts;
  final KpiValue? stockUnits;

  DashboardCatalog({this.totalProducts, this.stockUnits});

  factory DashboardCatalog.fromJson(Map<String, dynamic> json) {
    return DashboardCatalog(
      totalProducts: json["total_products"],
      stockUnits: json["stock_units"] != null
          ? KpiValue.fromJson(json["stock_units"])
          : null,
    );
  }

  String get displayTotalProducts => safeString(totalProducts);
}

class DashboardSales {
  final KpiValue? totalOrders;
  final KpiValue? omset;

  DashboardSales({this.totalOrders, this.omset});

  factory DashboardSales.fromJson(Map<String, dynamic> json) {
    return DashboardSales(
      totalOrders: json["total_orders"] != null
          ? KpiValue.fromJson(json["total_orders"])
          : null,
      omset: json["omset"] != null ? KpiValue.fromJson(json["omset"]) : null,
    );
  }
}

class DashboardMovement {
  final MovementItem? incoming;
  final MovementItem? outgoing;

  DashboardMovement({this.incoming, this.outgoing});

  factory DashboardMovement.fromJson(Map<String, dynamic> json) {
    return DashboardMovement(
      incoming: json["incoming"] != null
          ? MovementItem.fromJson(json["incoming"])
          : null,
      outgoing: json["outgoing"] != null
          ? MovementItem.fromJson(json["outgoing"])
          : null,
    );
  }
}

class MovementItem {
  final int? qty;
  final num? value;
  final num? trendPercentage;
  final String? trendDirection;

  MovementItem({
    this.qty,
    this.value,
    this.trendPercentage,
    this.trendDirection,
  });

  factory MovementItem.fromJson(Map<String, dynamic> json) {
    return MovementItem(
      qty: json["qty"],
      value: json["value"],
      trendPercentage: json["trend_percentage"],
      trendDirection: json["trend_direction"],
    );
  }

  bool get isDown => (trendDirection ?? "").toLowerCase() == "down";

  String get displayQty => safeString(qty);

  String get displayTrendPercentage {
    if (trendPercentage == null) return "-";
    final sign = isDown ? "-" : "+";
    return "$sign${trendPercentage!.abs()}%";
  }
}

class KpiValue {
  final num? value;
  final num? trendPercentage;
  final String? trendDirection;

  KpiValue({this.value, this.trendPercentage, this.trendDirection});

  factory KpiValue.fromJson(Map<String, dynamic> json) {
    return KpiValue(
      value: json["value"],
      trendPercentage: json["trend_percentage"],
      trendDirection: json["trend_direction"],
    );
  }

  bool get isDown => (trendDirection ?? "").toLowerCase() == "down";

  String get displayValue => safeString(value);
  String get displayCurrency => safeString(value?.toLocaleCurrency());

  String get displayCount {
    if (value == null) return "-";
    return value!.toLocaleCurrency(showSymbol: false, symbol: null);
  }

  String get displayTrendPercentage {
    if (trendPercentage == null) return "-";
    final sign = isDown ? "-" : "+";
    return "$sign${trendPercentage!.abs()}%";
  }
}

class MovementChart {
  final List<String> labels;
  final List<int> incoming;
  final List<int> outgoing;

  MovementChart({
    this.labels = const [],
    this.incoming = const [],
    this.outgoing = const [],
  });

  factory MovementChart.fromJson(Map<String, dynamic> json) {
    return MovementChart(
      labels:
          (json["labels"] as List?)?.map((e) => e.toString()).toList() ?? [],
      incoming:
          (json["incoming"] as List?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      outgoing:
          (json["outgoing"] as List?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
    );
  }

  int get totalIncoming => incoming.fold(0, (sum, e) => sum + e);
  int get totalOutgoing => outgoing.fold(0, (sum, e) => sum + e);
}
