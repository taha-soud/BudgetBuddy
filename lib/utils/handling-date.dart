import 'package:intl/intl.dart';

bool isToday(DateTime date) {
  final now = DateTime.now();
  return date.year == now.year && date.month == now.month && date.day == now.day;
}

bool isYesterday(DateTime date) {
  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));
  return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
}

String formatDate(DateTime date) {
  final now = DateTime.now();
  if (isToday(date)) {
    return 'Today';
  } else if (isYesterday(date)) {
    return 'Yesterday';
  } else {
    return DateFormat('dd MMM yyyy').format(date);
  }
}
