import 'package:dreusables/src/const/theme/app_colors.dart';
import 'package:dreusables/src/core/extensions/app_text_styles.dart';
import 'package:flutter/material.dart';

extension CenterLeftExtension on Widget {
  Widget get left {
    return Align(alignment: Alignment.centerLeft, child: this);
  }
}

extension HorizontalPaddingExtension on Widget {
  Widget horizontalPadding(double value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: value),
      child: this,
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  bool get isValidEmail {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(this);
  }

  bool get isValidPhone {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(this);
  }

  bool get isValidUrl {
    return RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    ).hasMatch(this);
  }
}

extension ContextExtension on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadiusGeometry.only(
            topRight: Radius.circular(12),
            topLeft: Radius.circular(12),
          ),
          side: BorderSide(
            color: isError ? AppColors.googleRed : AppColors.googleGreen,
          ),
        ),
        content: Text(message, style: Theme.of(this).textTheme.bodyRegular),
        backgroundColor: isError
            ? AppColors.googleRed.withValues(alpha: 0.4)
            : AppColors.googleGreen.withValues(alpha: 0.4),
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }
}

extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;

  T? get lastOrNull => isEmpty ? null : last;
}
