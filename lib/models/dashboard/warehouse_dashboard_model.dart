import 'package:arena/models/dashboard/dashboard_model.dart';

/// Mirrors backend WarehouseDashboardResponse:
/// {
///   "period": { "type": string, "start_date": string, "end_date": string },
///   "total_stock": KPIValue,
///   "stock_in": KPIValue,
///   "stock_out": KPIValue
/// }
class WarehouseDashboardModel {
  final bool? success;
  final String? message;
  final WarehouseDashboardData? data;

  WarehouseDashboardModel({this.success, this.message, this.data});

  factory WarehouseDashboardModel.fromJson(Map<String, dynamic> json) {
    return WarehouseDashboardModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] != null
          ? WarehouseDashboardData.fromJson(json["data"])
          : null,
    );
  }
}

class WarehouseDashboardData {
  final DashboardPeriod? period;
  final KpiValue? totalStock;
  final KpiValue? stockIn;
  final KpiValue? stockOut;

  WarehouseDashboardData({
    this.period,
    this.totalStock,
    this.stockIn,
    this.stockOut,
  });

  factory WarehouseDashboardData.fromJson(Map<String, dynamic> json) {
    return WarehouseDashboardData(
      period: json["period"] != null
          ? DashboardPeriod.fromJson(json["period"])
          : null,
      totalStock: json["total_stock"] != null
          ? KpiValue.fromJson(json["total_stock"])
          : null,
      stockIn: json["stock_in"] != null
          ? KpiValue.fromJson(json["stock_in"])
          : null,
      stockOut: json["stock_out"] != null
          ? KpiValue.fromJson(json["stock_out"])
          : null,
    );
  }
}
