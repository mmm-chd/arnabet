import 'package:arena/config/network/client.dart';
import 'package:arena/config/network/constant_api.dart';
import 'package:arena/models/dashboard/dashboard_model.dart';
import 'package:arena/models/dashboard/warehouse_dashboard_model.dart';
import 'package:arena/utils/extract_server_message.dart';
import 'package:dio/dio.dart';

class DashboardService {
  static const _dashboardPath = ConstantApi.dashboard;
  static const _warehousePath = ConstantApi.dashboardWarehouse;

  Future<DashboardModel> getDashboard({required String period}) async {
    try {
      final response = await Client.dio.get(
        _dashboardPath,
        queryParameters: {"period": period},
      );
      final body = DashboardModel.fromJson(response.data);
      if (body.success == true) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal memuat dashboard");
      }
    } on DioException catch (e) {
      final serverMessage = extractServerMessage(e);
      throw Exception(serverMessage ?? "Gagal memuat dashboard");
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<WarehouseDashboardModel> getWarehouseDashboard({
    required String period,
  }) async {
    try {
      final response = await Client.dio.get(
        _warehousePath,
        queryParameters: {"period": period},
      );
      final body = WarehouseDashboardModel.fromJson(response.data);
      if (body.success == true) {
        return body;
      } else {
        throw Exception(body.message ?? "Gagal memuat dashboard gudang");
      }
    } on DioException catch (e) {
      final serverMessage = extractServerMessage(e);
      throw Exception(serverMessage ?? "Gagal memuat dashboard gudang");
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
