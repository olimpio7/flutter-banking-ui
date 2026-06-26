import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AppFormatters {
  /// Formats a double value to Brazilian Real (e.g., 1000.50 -> R$ 1.000,50)
  static String formatCurrency(double value) {
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(value);
  }

  /// Formats a double value to Brazilian format without the symbol (e.g., 1000.50 -> 1.000,50)
  static String formatNumberOnly(double value) {
    return NumberFormat.currency(locale: 'pt_BR', symbol: '').format(value).trim();
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: 'R\$ 0,00',
        selection: TextSelection.collapsed(offset: 7),
      );
    }

    double value = double.parse(digitsOnly) / 100;
    final formatted = AppFormatters.formatCurrency(value); // Retorna com R$

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
