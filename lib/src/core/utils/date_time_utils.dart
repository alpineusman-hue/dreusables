import 'package:intl/intl.dart';

class DateTimeUtils {
  DateTimeUtils._();

  static String formatDate(DateTime date, {String pattern = 'MMM dd, yyyy'}) {
    return DateFormat(pattern).format(date);
  }

  static String formatTime(DateTime time, {String pattern = 'hh:mm a'}) {
    return DateFormat(pattern).format(time);
  }

  static String formatDateTime(
    DateTime dateTime, {
    String pattern = 'MMM dd, yyyy hh:mm a',
  }) {
    return DateFormat(pattern).format(dateTime);
  }

  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    }
  }

  /// Formats a DateTime as a relative time string (e.g., "2 days ago", "3hrs ago", "5min ago", "Just now")
  /// Returns "Unknown" if dateTime is null
  static String formatTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown';
    
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}hr${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}min ago';
    } else {
      return 'Just now';
    }
  }

  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
  }

  static DateTime parseDate(String dateString, {String pattern = 'yyyy-MM-dd'}) {
    return DateFormat(pattern).parse(dateString);
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Formats a quantity with unit (e.g., "1,000 m³", "500 m³")
  /// Returns "N/A" if quantity is null
  /// Normalizes storage units (e.g. "m3") to display format ("m³")
  static String formatQuantity(double? quantity, String? unit) {
    if (quantity == null) return 'N/A';
    // Format number with commas
    final formattedQuantity = quantity.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    if (unit == null || unit.isEmpty) return formattedQuantity;
    // Normalize m3 -> m³ for display
    final displayUnit = unit.toLowerCase() == 'm3' ? 'm³' : unit;
    return '$formattedQuantity $displayUnit';
  }
}
