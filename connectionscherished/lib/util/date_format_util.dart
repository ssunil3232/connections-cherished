import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

DateTime createDate(date) {
  if (date is DateTime) {
    return date;
  } else if (date is String) {
    return DateTime.parse(date);
  } else if (date is Timestamp) {
    return date.toDate();
  }
  return DateTime.now();
}

Timestamp createTimestamp(date) {
  if (date is Timestamp) {
    return date;
  } else if (date is DateTime) {
    return Timestamp.fromDate(date);
  }
  return Timestamp.now();
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