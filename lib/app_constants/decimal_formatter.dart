import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;
  final int integerRange;

  DecimalTextInputFormatter({this.decimalRange = 2, this.integerRange = 7})
      : assert(decimalRange >= 0),
        assert(integerRange > 0);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // Check if the text is empty or is only a decimal point.
    if (text.isEmpty || text == '.') {
      return newValue;
    }

    // Check if the text matches the pattern.
    final regExp = RegExp(r'^\d{0,' +
        integerRange.toString() +
        r'}(\.\d{0,' +
        decimalRange.toString() +
        r'})?$');
    if (!regExp.hasMatch(text)) {
      return oldValue;
    }

    // If the text matches the pattern, return the new value.
    return newValue;
  }
}
