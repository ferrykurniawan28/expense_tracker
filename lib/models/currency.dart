import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyFormat {
  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }
}

class DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.endsWith('.') &&
        newValue.selection.baseOffset == newValue.text.length) {
      // Add a digit after the dot if the dot is the last character
      return newValue.copyWith(
        text: '${newValue.text}0',
        selection: TextSelection.collapsed(offset: newValue.text.length + 1),
      );
    }
    return newValue;
  }
}
