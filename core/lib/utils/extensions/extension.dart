export 'context.dart';
export 'string.dart';
export 'text_theme.dart';


import 'package:intl/intl.dart';

extension RupeeFormatter on num {
  String inRupeesFormat({int decimalDigits = 2}) {
    return NumberFormat.currency(
      name: "INR",
      locale: 'en_IN',
      decimalDigits: decimalDigits,
      symbol: '₹',
    ).format(this);
  }
}


