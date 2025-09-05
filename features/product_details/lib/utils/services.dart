import 'dart:convert';

import 'package:core/config/string_resource/strings.dart';
import 'package:product_details/data/models/active_loan_detail_response.dart';
import 'package:product_details/data/models/active_loan_list_response.dart';
import 'package:product_details/utils/constants.dart';
import 'package:product_details/utils/extension.dart';

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

// below methods are for converting amount into sentence.
String oneToNineteen(int n) {
  List<String> words = [
    "",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
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
  return words[n];
}

String tens(int n) {
  List<String> words = [
    "",
    "",
    "twenty",
    "thirty",
    "forty",
    "fifty",
    "sixty",
    "seventy",
    "eighty",
    "ninety"
  ];
  return words[n];
}

String twoDigitNumber(int n) {
  if (n < 20) {
    return oneToNineteen(n);
  } else {
    return tens(n ~/ 10) + (n % 10 == 0 ? '' : ' ${oneToNineteen(n % 10)}');
  }
}

String threeDigitNumber(int n) {
  if (n < 100) {
    return twoDigitNumber(n);
  } else {
    return "${oneToNineteen(n ~/ 100)} hundred${n % 100 == 0 ? '' : ' and ${twoDigitNumber(n % 100)}'}";
  }
}

String numberToWords(int num) {
  if (num == 0) {
    return "zero rupees";
  }

  int crore = num ~/ 10000000;
  num %= 10000000;
  int lakh = num ~/ 100000;
  num %= 100000;
  int thousand = num ~/ 1000;
  num %= 1000;
  int hundred = num;

  String result = "";
  if (crore > 0) {
    result += "${threeDigitNumber(crore)} crore";
  }
  if (lakh > 0) {
    result += "${result.isEmpty ? '' : ' '}${threeDigitNumber(lakh)} lakh";
  }
  if (thousand > 0) {
    result +=
        "${result.isEmpty ? '' : ' '}${threeDigitNumber(thousand)} thousand";
  }
  if (hundred > 0) {
    result += (result.isEmpty ? '' : ' ') + threeDigitNumber(hundred);
  }

  return '${result.trim()} rupees';
}

String capitalizeAmountString(String val) {
  String pre = val.substring(0, 1).toUpperCase();
  String post = val.substring(1);
  return "$pre$post";
}

num getCharges(BasicChargeDetails? basicChargeDetails) {
  double sum =
      double.parse(basicChargeDetails?.additionalInterestCharges ?? '0') +
          double.parse(basicChargeDetails?.chequeReturnCharges ?? '0') +
          double.parse(basicChargeDetails?.otherCharges ?? '0') +
          double.parse(basicChargeDetails?.repossessionCharges ?? '0');
  return sum;
}

String createSOAurl(ActiveLoanData activeLoanData) {
  String signature = 'HRFhBomVNSPA1UNqB+d4LHSqyh8=';
  String htmlContent = '''
     <html>
   <body>
      <form id="loginForm" method="post" action="https://commonwebapp.mahindrafs.com/SOA_MOBILE_UAT/SOA_Mobile/GenSOA">
         <input type="hidden" name="contractNo" value=${activeLoanData.loanNumber}>
         <input type="hidden" name="empcode" value=${activeLoanData.mobileNumber}>
         <input type="hidden" name="fromDate" value=${PaymentConstants.constDate}>
         <input type="hidden" name="appn_no" value=${activeLoanData.loanNumber}>
         <input type="hidden" name="signature" value=$signature>
      </form>
      <script type="text/javascript">document.getElementById("loginForm").submit();</script>
   </body>
</html>
    ''';
  String base64Html = base64Encode(const Utf8Encoder().convert(htmlContent));
  String dataUri = 'data:text/html;base64,$base64Html';
  return dataUri;
}

String getAmountValidationMsg(
    {required double forecloseAmount, required double enteredAmount}) {
  return "₹$enteredAmount ${getString(lblForeclosureAmount)} $forecloseAmount. \n\n${getString(lblMsgProceed)}";
}

String getMaxCapWarningMsg({required double maxCap}) {
  return '${getString(lblAmountGreaterThan)}$maxCap';
}
