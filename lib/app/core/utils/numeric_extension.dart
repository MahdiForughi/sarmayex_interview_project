import 'package:intl/intl.dart' as intl;

extension DoubleUtils on double {
  String get toPriceFormatter => intl.NumberFormat('###,###,###').format(this);

  String get clearUnusedDecimalPoints {
    if ((this - truncate()) == 0) return toInt().toString();
    if (toStringAsFixed(1) == '0.0') return '0';
    return toStringAsFixed(1);
  }
}

extension IntUtils on int {
  String get toPriceFormatter => intl.NumberFormat('###,###,###').format(this);
}
