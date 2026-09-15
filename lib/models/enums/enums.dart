enum PageStatus { initial, loading, success, failure, empty }

// Inbox
enum InboxSubject { stok, perubahan, aging, pengguna, laporan, unknown }

// STOCK
enum ItemType { PRODUCT, SERVICE }

final itemTypeValues = EnumValues({
  "PRODUCT": ItemType.PRODUCT,
  "SERVICE": ItemType.SERVICE,
});

enum PaymentMethod { CASH, VIRTUAL_ACCOUNT, QRIS }

final paymentMethodValues = EnumValues({
  "CASH": PaymentMethod.CASH,
  "VIRTUAL_ACCOUNT": PaymentMethod.VIRTUAL_ACCOUNT,
  "QRIS": PaymentMethod.QRIS,
});

extension PaymentMethodParser on PaymentMethod {
  bool get isOnlinePayment =>
      this == PaymentMethod.QRIS || this == PaymentMethod.VIRTUAL_ACCOUNT;

  String toIndonesian() {
    switch (this) {
      case PaymentMethod.CASH:
        return 'Cash';
      case PaymentMethod.VIRTUAL_ACCOUNT:
        return 'Virtual Account';
      case PaymentMethod.QRIS:
        return 'QRIS';
    }
  }
}

enum PaymentStatus { PAID, UNPAID, PROCESSING, FAILED, EXPIRED, REFUNDED }

final paymentStatusValues = EnumValues({
  "PAID": PaymentStatus.PAID,
  "UNPAID": PaymentStatus.UNPAID,
  "PROCESSING": PaymentStatus.PROCESSING,
  "FAILED": PaymentStatus.FAILED,
  "EXPIRED": PaymentStatus.EXPIRED,
  "REFUNDED": PaymentStatus.REFUNDED,
});

extension PaymentStatusParser on PaymentStatus {
  String toIndonesian() {
    switch (this) {
      case PaymentStatus.PAID:
        return 'Dibayar';
      case PaymentStatus.UNPAID:
        return 'Belum Dibayar';
      case PaymentStatus.PROCESSING:
        return 'Diproses';
      case PaymentStatus.FAILED:
        return 'Gagal';
      case PaymentStatus.EXPIRED:
        return 'Kadaluarsa';
      case PaymentStatus.REFUNDED:
        return 'Dikembalikan';
    }
  }
}

enum OrderStatus { NEED_PICKUP, PROCESSING, COMPLETED, CANCELLED }

final orderStatusValues = EnumValues({
  "NEED_PICKUP": OrderStatus.NEED_PICKUP,
  "PROCESSING": OrderStatus.PROCESSING,
  "COMPLETED": OrderStatus.COMPLETED,
  "CANCELLED": OrderStatus.CANCELLED,
});

extension OrderStatusParser on OrderStatus {
  String toIndonesian() {
    switch (this) {
      case OrderStatus.NEED_PICKUP:
        return 'Perlu Diambil';
      case OrderStatus.PROCESSING:
        return 'Diproses';
      case OrderStatus.COMPLETED:
        return 'Selesai';
      case OrderStatus.CANCELLED:
        return 'Dibatalkan';
    }
  }
}

enum StockHistoryType { IN, OUT, ADJUSTMENT_OUT, ADJUSTMENT_IN }

final stockHistoryTypeValues = EnumValues({
  "IN": StockHistoryType.IN,
  "OUT": StockHistoryType.OUT,
  "ADJUSTMENT_OUT": StockHistoryType.ADJUSTMENT_OUT,
  "ADJUSTMENT_IN": StockHistoryType.ADJUSTMENT_IN,
});

extension StockHistoryTypeX on StockHistoryType {
  String get label {
    switch (this) {
      case StockHistoryType.IN:
        return "Stock In";
      case StockHistoryType.OUT:
        return "Stock Out";
      case StockHistoryType.ADJUSTMENT_IN:
        return "Penyesuaian Masuk";
      case StockHistoryType.ADJUSTMENT_OUT:
        return "Penyesuaian Keluar";
    }
  }

  String toIndonesian() {
    switch (this) {
      case StockHistoryType.IN:
        return "Stok Masuk";
      case StockHistoryType.OUT:
        return "Stok Keluar";
      case StockHistoryType.ADJUSTMENT_IN:
        return "Penyesuaian Masuk";
      case StockHistoryType.ADJUSTMENT_OUT:
        return "Penyesuaian Keluar";
    }
  }

  bool matchesFilterLabel(String filterLabel) {
    final f = filterLabel.trim().toLowerCase();
    switch (this) {
      case StockHistoryType.IN:
        return f == "stock in" || f == "stok masuk";
      case StockHistoryType.OUT:
        return f == "stock out" || f == "stok keluar";
      case StockHistoryType.ADJUSTMENT_IN:
        return f == "adjustment in" ||
            f == "penyesuaian masuk" ||
            f == "adj in";
      case StockHistoryType.ADJUSTMENT_OUT:
        return f == "adjustment out" ||
            f == "penyesuaian keluar" ||
            f == "adj out";
    }
  }
}

enum StockHistoryReferenceType { ORDER, RESTOCK, ADJUSTMENT }

final stockHistoryReferenceTypeValues = EnumValues({
  "ORDER": StockHistoryReferenceType.ORDER,
  "RESTOCK": StockHistoryReferenceType.RESTOCK,
  "ADJUSTMENT": StockHistoryReferenceType.ADJUSTMENT,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
