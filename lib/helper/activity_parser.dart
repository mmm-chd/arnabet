import 'package:arena/models/enums/enums.dart';

String parseActivity(String? activity) {
  if (activity == null || activity.trim().isEmpty) return '-';

  switch (activity.trim().toUpperCase()) {
    case 'IN':
    case 'STOCK_IN':
      return 'Stock In';
    case 'OUT':
    case 'STOCK_OUT':
      return 'Stock Out';
    case 'ADJ_IN':
    case 'ADJUSTMENT_IN':
      return 'Penyesuaian Masuk';
    case 'ADJ_OUT':
    case 'ADJUSTMENT_OUT':
      return 'Penyesuaian Keluar';
    default:
      return activity;
  }
}

bool isActivityIn(String? activity) {
  if (activity == null) return false;
  final a = activity.trim().toUpperCase();
  return a == 'IN' || a == 'STOCK_IN' || a == 'ADJ_IN' || a == 'ADJUSTMENT_IN';
}

bool isActivityOut(String? activity) {
  if (activity == null) return false;
  final a = activity.trim().toUpperCase();
  return a == 'OUT' ||
      a == 'STOCK_OUT' ||
      a == 'ADJ_OUT' ||
      a == 'ADJUSTMENT_OUT';
}
