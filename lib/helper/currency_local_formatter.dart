import 'package:intl/intl.dart';

extension CurrencyLocalFormatter on num {
  String toLocaleCurrency({
    String? symbol = 'Rp ',
    String? locale = 'id_ID',
    int decimalDigits = 2,
    bool showSymbol = true,
    bool compact = false,
  }) {
    final currentLocale = locale ?? Intl.systemLocale;

    final formatter = compact
        ? NumberFormat.compactCurrency(
            locale: currentLocale,
            symbol: showSymbol ? (symbol ?? '') : '',
            decimalDigits: decimalDigits,
          )
        : NumberFormat.currency(
            locale: currentLocale,
            symbol: showSymbol ? (symbol ?? '') : '',
            decimalDigits: decimalDigits,
          );

    if (!showSymbol && symbol == null) {
      return NumberFormat.decimalPattern(currentLocale).format(this);
    }

    return formatter.format(this);
  }

  String toAxisValue({bool isCurrency = false}) {
    if (isCurrency) {
      return toLocaleCurrency(symbol: 'Rp ', decimalDigits: 1, compact: true);
    }
    final v = toDouble();
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(1).replaceAll('.', ',');
  }
}
