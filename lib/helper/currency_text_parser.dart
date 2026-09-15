import 'package:intl/intl.dart';

extension CurrencyTextParser on String {
  int? toCurrencyInt() {
    final isNegative = trim().startsWith('-');
    // CurrencyInputFormatter menulis desimal setelah koma (mis. "1.500.000,00"),
    // jadi bagian itu harus dibuang sebelum digit dibaca.
    final digitsOnly = split(',').first.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.isEmpty) return null;

    final value = int.parse(digitsOnly);
    return isNegative ? -value : value;
  }

  double? toCurrencyDouble({String? locale}) {
    if (trim().isEmpty) return null;

    final currentLocale = locale ?? Intl.systemLocale;

    final cleaned = replaceAll(RegExp(r'[^0-9\-,.]'), '');
    if (cleaned.isEmpty) return null;

    try {
      final result = NumberFormat.decimalPattern(currentLocale).parse(cleaned);
      return result.toDouble();
    } on FormatException {
      final digitsOnly = cleaned.replaceAll(RegExp(r'[^0-9\-]'), '');
      if (digitsOnly.isEmpty) return null;
      return double.tryParse(digitsOnly);
    }
  }

  num? toCurrencyNum({String? locale}) {
    final asDouble = toCurrencyDouble(locale: locale);
    if (asDouble == null) return null;
    return asDouble == asDouble.roundToDouble() ? asDouble.toInt() : asDouble;
  }
}

String formatInitialCurrency(
  num? value, {
  bool isIDR = true,
  String locale = 'id_ID',
}) {
  if (value == null) return '';
  var formatted = NumberFormat.decimalPattern(locale).format(value);
  if (isIDR) {
    formatted = '$formatted,00';
  }
  return formatted;
}
