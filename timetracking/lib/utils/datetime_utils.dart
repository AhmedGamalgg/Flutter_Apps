import 'package:intl/intl.dart';

class DateTimeUtils {
  // Format date based on user's preferred format
  static String formatDate(DateTime date, String format) {
    String pattern;

    // Convert from display format to intl format
    switch (format) {
      case 'MM/DD/YYYY':
        pattern = 'MM/dd/yyyy';
        break;
      case 'DD/MM/YYYY':
        pattern = 'dd/MM/yyyy';
        break;
      case 'YYYY-MM-DD':
        pattern = 'yyyy-MM-dd';
        break;
      default:
        pattern = 'MM/dd/yyyy';
    }

    return DateFormat(pattern).format(date);
  }

  // Format time in 12-hour format
  static String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  // Check if two dates are the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  // Get start of month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  // Get end of month
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59);
  }

  // Format duration in hours and minutes
  static String formatDuration(double hours) {
    final totalMinutes = (hours * 60).round();
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;

    if (h == 0) {
      return '$m minute${m == 1 ? '' : 's'}';
    } else if (m == 0) {
      return '$h hour${h == 1 ? '' : 's'}';
    } else {
      return '$h hour${h == 1 ? '' : 's'}, $m minute${m == 1 ? '' : 's'}';
    }
  }
}
