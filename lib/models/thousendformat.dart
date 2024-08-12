import 'package:flutter/services.dart';

class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Get the numeric value without commas
    String newText = newValue.text.replaceAll(',', '');

    // Add commas as thousands separators for display
    final regEx = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String formattedText =
        newText.replaceAllMapped(regEx, (Match match) => '${match[1]},');

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
