
import 'package:arena/helper/safe_helpers.dart';

class OrderModel {
  final String id;
  final String status;
  final int total;
  final List<Map<String, dynamic>> items;
  final DateTime createdAt;
  final bool isDummy;

  // Display Getters
  String get displayId => safeString(id);
  String get displayStatus => safeString(status);
  String get displayTotal => safeString(total);

  OrderModel({
    required this.id,
    required this.status,
    required this.total,
    required this.items,
    required this.createdAt,
    this.isDummy = false,
  });
}
