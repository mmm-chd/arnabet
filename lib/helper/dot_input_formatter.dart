import 'package:flutter/services.dart';

class DotCodeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.length > 4) {
      digitsOnly = digitsOnly.substring(0, 4);
    }

    return TextEditingValue(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: digitsOnly.length),
    );
  }
}

String? getDotCodeError(String value) {
  if (value.isEmpty) return null;

  final currentYearTwoDigit = DateTime.now().year % 100;

  if (value.length < 4) {
    return 'Kode DOT harus 4 digit';
  }

  final week = int.tryParse(value.substring(0, 2)) ?? -1;
  final year = int.tryParse(value.substring(2, 4)) ?? -1;

  if (week < 1 || week > 52) {
    return 'Minggu harus di antara 01-52';
  }

  if (year < 0 || year > currentYearTwoDigit) {
    return 'Tahun tidak boleh melebihi $currentYearTwoDigit (${DateTime.now().year})';
  }

  if (value == '0000') {
    return 'Kode DOT tidak boleh 0000';
  }

  return null;
}
