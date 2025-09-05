import 'package:intl/intl.dart';
import 'package:product_details/utils/constants.dart';
import '../extensions.dart';

String inputFiledAmountFormatter(String amount) {
  try {
    double amount0 =
        double.parse(amount.replaceAll("₹", "").replaceAll(",", ""));
    String formattedAmount =
        RupeeFormatter(amount0).inRupeesFormat(decimalDigits: 0);

    return formattedAmount;
  } catch (e) {
    return "0";
  }
}

String rupeeFormatter(String amount) {
  String value = (amount.replaceAll("₹", "").replaceAll(",", ""));
  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  mathFunc(Match match) => '${match[1]},';
  String result = value.replaceAllMapped(reg, mathFunc);
  if (result.split('.').length > 1) {
    String afterDecimalVal = result.split('.').last;
    if (afterDecimalVal.length > 2) {
      result = '${result.split('.').first}.${afterDecimalVal.substring(0, 2)}';
    }
  }

  return '${PaymentConstants.rupeeSymbol}$result';
}

double getAmountAsDouble(String amount) {
  try {
    return double.parse(amount.replaceAll("₹", "").replaceAll(",", ""));
  } catch (e) {
    return 0;
  }
}

class AmountInWords {
  static const zero = "zero";
  static const oneToNine = [
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine"
  ];

  static const tenToNinteen = [
    "ten",
    "eleven",
    "twelve",
    "thirteen",
    "fourteen",
    "fifteen",
    "sixteen",
    "seventeen",
    "eighteen",
    "nineteen"
  ];

  static const dozens = [
    "ten",
    "twenty",
    "thirty",
    "forty",
    "fifty",
    "sixty",
    "seventy",
    "eighty",
    "ninety"
  ];

  static String solution(int number) {
    if (number == 0) {
      return zero;
    }
    return generate(number).trim();
  }

  static String generate(int number) {
    if (number >= 1000000000) {
      return "${generate(number ~/ 1000000000)} billion ${generate(number % 1000000000)}";
    } else if (number >= 1000000) {
      return "${generate(number ~/ 1000000)} million ${generate(number % 1000000)}";
    } else if (number >= 1000) {
      return "${generate(number ~/ 1000)} thousand ${generate(number % 1000)}";
    } else if (number >= 100) {
      return "${generate(number ~/ 100)} hundred ${generate(number % 100)}";
    }
    return generate1To99(number);
  }

  static String generate1To99(int number) {
    if (number == 0) {
      return "";
    } else if (number <= 9) {
      return oneToNine[number - 1];
    } else if (number <= 19) {
      return tenToNinteen[number % 10];
    } else {
      return "${dozens[number ~/ 10 - 1]} ${generate1To99(number % 10)}";
    }
  }
}

String capitalizeAmountString(String val) {
  String pre = val.substring(0, 1).toUpperCase();
  String post = val.substring(1);
  return "$pre$post";
}

String dateFormatter(DateTime date) {
  DateFormat outputDateFormat = DateFormat('dd MMM yyyy');
  String formattedDate = outputDateFormat.format(date);
  return formattedDate;
}

String timeFormatter(DateTime date) {
  DateFormat formatter = DateFormat('h:mm a');
  String time = formatter.format(date);
  return time;
}