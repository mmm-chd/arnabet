import 'package:arena/models/dashboard/dashboard_model.dart';
import 'package:arena/models/dashboard/warehouse_dashboard_model.dart';
import 'package:arena/services/dashboard/dashboard_service.dart';

class DashboardRepository {
  final DashboardService _dashboardService;

  DashboardRepository({DashboardService? dashboardService})
    : _dashboardService = dashboardService ?? DashboardService();

  Future<DashboardModel> getDashboard({required String period}) async {
    return await _dashboardService.getDashboard(period: period);
  }

  Future<WarehouseDashboardModel> getWarehouseDashboard({
    required String period,
  }) async {
    return await _dashboardService.getWarehouseDashboard(period: period);
  }
}
