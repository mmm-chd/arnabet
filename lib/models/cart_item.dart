
import 'package:arena/helper/safe_helpers.dart';

class CartItem {
  final String name;
  final String brand;
  final String dot;
  final String size;
  final String ring;
  final int price;
  final int qty;

  // Display Getters
  String get displayName => safeString(name);
  String get displayBrand => safeString(brand);
  String get displayDot => safeString(dot);
  String get displaySize => safeString(size);
  String get displayRing => safeString(ring);

  CartItem({
    required this.name,
    required this.brand,
    required this.dot,
    required this.size,
    required this.ring,
    required this.price,
    required this.qty,
  });

  CartItem copyWith({
    String? name,
    String? brand,
    String? dot,
    String? size,
    String? ring,
    int? price,
    int? qty,
  }) {
    return CartItem(
      name: name ?? this.name,
      brand: brand ?? this.brand,
      dot: dot ?? this.dot,
      size: size ?? this.size,
      ring: ring ?? this.ring,
      price: price ?? this.price,
      qty: qty ?? this.qty,
    );
  }
}
