 

import 'package:flutter/services.dart';

class DoubleInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow empty input
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Check if the input is a valid double
    final doubleValue = double.tryParse(newValue.text);
    if (doubleValue != null) {
      return newValue;
    }

    // Prevent more than one dot
    if (newValue.text.split('.').length - 1 > 1) {
      return oldValue;
    }

    // Reject invalid input
    return oldValue;
  }
}
