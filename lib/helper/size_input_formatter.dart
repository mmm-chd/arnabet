import 'package:flutter/services.dart';

class SizeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.length > 5) {
      digitsOnly = digitsOnly.substring(0, 5);
    }

    final String formatted = digitsOnly.length <= 3
        ? digitsOnly
        : '${digitsOnly.substring(0, 3)}/${digitsOnly.substring(3)}';

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}