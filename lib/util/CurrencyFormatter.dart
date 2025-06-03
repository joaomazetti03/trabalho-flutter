import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatBRL(double? amount) {
    if (amount == null) return 'R\$ --,--';
    final format = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$', decimalDigits: 2);
    return format.format(amount);
  }

  static String formatUSD(double? amount) {
    if (amount == null) return '\$ --.--';
    final format = NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 2);
    return format.format(amount);
  }
}