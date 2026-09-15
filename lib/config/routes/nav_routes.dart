import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/models/enums/role.dart';

class NavRoutes {
  static String getHomeRoute(Role role) {
    switch (role) {
      case Role.owner:
      case Role.developer:
        return AppRoutes.dashboardOwner;
      case Role.customerServices:
        return AppRoutes.orderListCs;
      case Role.cashier:
        return AppRoutes.orderListCashier;
      case Role.warehouseStaff:
        return AppRoutes.dashboardWarehouse;
      case Role.unknown:
        return AppRoutes.login;
    }
  }

  static String getStockListRoute(Role role) {
    switch (role) {
      case Role.owner:
      case Role.developer:
        return AppRoutes.stockListOwner;
      case Role.customerServices:
        return AppRoutes.stockListCs;
      case Role.cashier:
        return AppRoutes.stockListCashier;
      case Role.warehouseStaff:
        return AppRoutes.stockListWarehouse;
      case Role.unknown:
        return AppRoutes.login;
    }
  }

  static String getOrderListRoute(Role role) {
    switch (role) {
      case Role.owner:
      case Role.developer:
        return AppRoutes.dashboardOwner;
      case Role.customerServices:
        return AppRoutes.orderListCs;
      case Role.cashier:
        return AppRoutes.orderListCashier;
      case Role.warehouseStaff:
        return AppRoutes.orderListWarehouse;
      case Role.unknown:
        return AppRoutes.login;
    }
  }

  static String getInboxRoute(Role role) {
    switch (role) {
      case Role.owner:
      case Role.developer:
        return AppRoutes.inboxOwner;
      case Role.customerServices:
        return AppRoutes.inboxCs;
      case Role.cashier:
        return AppRoutes.inboxCashier;
      case Role.warehouseStaff:
        return AppRoutes.inboxWarehouse;
      case Role.unknown:
        return AppRoutes.login;
    }
  }
}
