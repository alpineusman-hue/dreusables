import 'package:dreusables/dirconnect_package.dart';
import 'package:flutter/material.dart';

class InputDecorationUtils {
  InputDecorationUtils._();

  static const double _iconSize = 20;

  static InputDecoration filled({
    required BuildContext context,
    String? hintText,
    TextStyle? hintStyle,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Color? fillColor,
  }) {
    final theme = Theme.of(context).textTheme;
    return InputDecoration(
      hintText: hintText,
      hintStyle: hintStyle ??
          theme.bodyMedium?.copyWith(color: AppColors.textTertiary),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.backgroundGrey,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
        borderSide: const BorderSide(color: Color(0xffE5E5E5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
        borderSide: const BorderSide(color: Color(0xffE5E5E5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      disabledBorder: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.inputPadding,
        vertical: AppSpacing.inputPadding,
      ),
    );
  }

  static double get iconSize => _iconSize;
}
