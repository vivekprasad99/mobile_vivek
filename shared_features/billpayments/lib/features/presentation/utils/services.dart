


import 'package:core/utils/extensions/extension.dart';

String inputFiledAmountFormatter(String amount) {
  try {
    double amountDouble =
        double.parse(amount.replaceAll("₹", "").replaceAll(",", ""));
    String formattedAmount =
        RupeeFormatter(amountDouble).inRupeesFormat(decimalDigits: 0);

    return formattedAmount;
  } catch (e) {
    return "0";
  }
}

double getAmountAsDouble(String amount) {
  try {
    return double.parse(amount.replaceAll("₹", "").replaceAll(",", ""));
  } catch (e) {
    return 0;
  }
}