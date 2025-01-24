import 'package:intl/intl.dart';

class DateFormatUtils {
  // Get full month name (May)
  String getFullMonthName() {
    return DateFormat('MMMM').format(DateTime.now());
  }

  // Get short month name (May)
  String getShortMonthName() {
    return DateFormat('MMM').format(DateTime.now());
  }

  // Get month number as string (05)
  String getMonthNumber() {
    return DateFormat('MM').format(DateTime.now());
  }

  // Get year (2024)
  String getYear() {
    return DateFormat('yyyy').format(DateTime.now());
  }

  // Get both month and year (May 2024)
  String getMonthAndYear() {
    return DateFormat('MMMM yyyy').format(DateTime.now());
  }

  // Get both as numbers (05/2024)
  String getMonthYearNumeric() {
    return DateFormat('MM/yyyy').format(DateTime.now());
  }

  String getDayMonthYearNumeric() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }
}
