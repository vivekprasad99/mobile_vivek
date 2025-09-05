import 'package:intl/intl.dart';

class ConvertDateTime {
  static String convert(String date) {
    if (date == "") date = '0000-00-00';
    try {
      DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      DateTime dateTime = dateFormat.parse(date);
      // String formattedDate =
      //     dateTime.format(pattern: 'yyyy-MM-dd hh:mm:ss a', locale: 'en_US');

      DateFormat outputDateFormat = DateFormat('d MMM yyyy');

      // Format the DateTime object to the desired output format
      String formattedDate = outputDateFormat.format(dateTime);
      return formattedDate;
    } catch (e) {
      DateFormat dateFormat = DateFormat('dd/MM/yyyy');
      DateTime dateTime = dateFormat.parse(date);
      // String formattedDate =
      //     dateTime.format(pattern: 'yyyy-MM-dd hh:mm:ss a', locale: 'en_US');

      DateFormat outputDateFormat = DateFormat('d MMM yyyy');
      String formattedDate = outputDateFormat.format(dateTime);
      return formattedDate;
    }
  }

  static String convertDateTime(String date) {
    if (date == "") date = '0000-00-00';
    try {
      DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      DateTime dateTime = dateFormat.parse(date);
      // String formattedDate =
      //     dateTime.format(pattern: 'yyyy-MM-dd hh:mm:ss a', locale: 'en_US');

      DateFormat outputDateFormat = DateFormat('d MMM yyyy');

      // Format the DateTime object to the desired output format
      String formattedDate = outputDateFormat.format(dateTime);
      return formattedDate;
    } catch (e) {
      DateFormat dateFormat = DateFormat('dd/MM/yyyy');
      DateTime dateTime = dateFormat.parse(date);
      // String formattedDate =
      //     dateTime.format(pattern: 'yyyy-MM-dd hh:mm:ss a', locale: 'en_US');

      DateFormat outputDateFormat = DateFormat('d MMM yyyy');
      String formattedDate = outputDateFormat.format(dateTime);
      return formattedDate;
    }
  }

  static DateTime getDateBeforeTwoDays(String? loanDate) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    DateTime dateTime = dateFormat.parse(loanDate!);
    // Subtract two days from the loan date
    return dateTime.subtract(const Duration(days: 2));
  }

  static String getCurrentDateInDDMMYYY() {
    DateFormat outputDateFormat = DateFormat('d-MMM-yyyy');
    String formattedDate = outputDateFormat.format(DateTime.now());
    return formattedDate;
  }
  static String convertDateFormat(String date) {
    String formattedDate = "";
    try {
      String originalDateStr = date;
      DateTime? originalDate = DateTime.parse(originalDateStr);
      formattedDate = DateFormat('dd/MM/yyyy').format(originalDate);
      return formattedDate;
    } catch (e) {
      return formattedDate;
    }
  }
}
