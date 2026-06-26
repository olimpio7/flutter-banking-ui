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
