import 'package:arena/models/order_model.dart';

class OrderDummy {
  static final List<OrderModel> orders = [
    OrderModel(
      id: "INV-2025-0201",
      status: "Urgent",
      createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 49)),
      total: 5000000,
      isDummy: true,
      items: [
  {
    "brand": "Bridgestone",
    "name": "Ecopia EP150",
    "size": "185/65",
    "ring": "R15",
    "dot": "TO05A",
    "price": 500000,
    "qty": 5,
    "total": 2500000,
  },
  {
    "brand": "Bridgestone",
    "name": "Potenza RE003",
    "size": "185/65",
    "ring": "R15",
    "dot": "AB12C",
    "price": 625000,
    "qty": 4,
    "total": 2500000,
  },
],
    ),
    OrderModel(
      id: "INV-2025-0202",
      status: "Proses",
      createdAt: DateTime.now().subtract(const Duration(minutes: 49)),
      total: 5000000,
      isDummy: true,
      items: [
  {
    "brand": "Bridgestone",
    "name": "Ecopia EP150",
    "size": "185/65",
    "ring": "R15",
    "dot": "TO05A",
    "price": 500000,
    "qty": 5,
    "total": 2500000,
  },
  {
    "brand": "Bridgestone",
    "name": "Potenza RE003",
    "size": "185/65",
    "ring": "R15",
    "dot": "AB12C",
    "price": 625000,
    "qty": 4,
    "total": 2500000,
  },
],
    ),
    OrderModel(
      id: "INV-2025-0203",
      status: "Selesai",
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      total: 5100000,
      isDummy: true,
      items: [
  {
    "brand": "Bridgestone",
    "name": "Turanza T005A",
    "size": "205/55",
    "ring": "R16",
    "dot": "LM88P",
    "price": 850000,
    "qty": 5,
    "total": 2550000,
  },
  {
    "brand": "Bridgestone",
    "name": "Potenza RE003",
    "size": "185/65",
    "ring": "R16",
    "dot": "LM88P",
    "price": 850000,
    "qty": 4,
    "total": 2550000,
  },
],
    ),
  ];
}
