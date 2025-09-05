import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

const String dateTimeFormatPattern = 'dd/MM/yyyy';
const String dateFormat = 'dd/MM/yyyy hh:mm a';

extension DateTimeExtension on DateTime {
  /// Return a string representing [date] formatted according to our locale
  String format({
    String pattern = dateTimeFormatPattern,
    String? locale,
  }) {
    if (locale != null && locale.isNotEmpty) {
      initializeDateFormatting(locale);
    }
    return DateFormat(pattern, locale).format(this);
  }
}

getCurrentDate(){
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('ddMMyyyy').format(now);
  return formattedDate; // 19/04/2023 - 11:15:45
}

getLastLogin()
{
  DateTime now = DateTime.now();
  String formattedDate = DateFormat(dateFormat).format(now);
  return formattedDate;
}

extension StringDateExtension on String{
  String formatDate({String pattern = "dd MMM yyyy"}) {
    final date = DateTime.parse(this);
    return DateFormat(pattern).format(date);
  }
}