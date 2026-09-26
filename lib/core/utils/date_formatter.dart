import 'package:intl/intl.dart';

/// Formats DateTimes into human-friendly relative and absolute formats.
class DateFormatter {
  DateFormatter._();

  /// Converts a DateTime into a friendly relative format for note cards.
  static String formatRelative(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final mins = difference.inMinutes;
      return '$mins ${mins == 1 ? 'min' : 'mins'} ago';
    } else if (difference.inHours < 24 && dateTime.day == now.day) {
      return 'Today, ${DateFormat('h:mm a').format(dateTime)}';
    } else {
      final yesterday = now.subtract(const Duration(days: 1));
      if (dateTime.day == yesterday.day &&
          dateTime.month == yesterday.month &&
          dateTime.year == yesterday.year) {
        return 'Yesterday, ${DateFormat('h:mm a').format(dateTime)}';
      } else if (dateTime.year == now.year) {
        return DateFormat('MMM d, h:mm a').format(dateTime);
      } else {
        return DateFormat('MMM d, yyyy').format(dateTime);
      }
    }
  }

  /// Detailed timestamp for editor header / info sheets.
  static String formatDetailed(DateTime dateTime) {
    return DateFormat('EEEE, MMMM d, yyyy • h:mm a').format(dateTime);
  }
}
