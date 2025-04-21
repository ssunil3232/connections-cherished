import 'package:intl/intl.dart';

// Date formatting function
String dateFormatUtil(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

String monthDayYearFormatter(DateTime date) {
  return DateFormat('MM/dd/yyyy').format(date);
}

String monthDayYearString(DateTime date) {
  return DateFormat('MM/dd/yy').format(date);
}

String createAgeString(DateTime date) {
  final now = DateTime.now();
  final age = now.difference(date);
  final years = age.inDays ~/ 365;
  final months = (age.inDays % 365) ~/ 30;
  if (months == 0){
    return '$years yr.';
  }
  else {
    return '$years yr. $months mo.';
  }
  
}