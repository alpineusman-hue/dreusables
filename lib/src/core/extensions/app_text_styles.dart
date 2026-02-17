import 'package:dirtconnect/src/const/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension CustomTextStyles on TextTheme {
  TextStyle get h1 => const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        fontFamily: 'SF Pro',
        color: AppColors.primaryDark,
        height: 1.2,
      );

  TextStyle get h2 => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        fontFamily: 'SF Pro',
        color: AppColors.primaryDark,
        height: 1.2,
      );

  TextStyle get h3 => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'SF Pro',
        color: AppColors.textPrimary,
        height: 1.3,
      );

  TextStyle get bodyLarge => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        fontFamily: 'SF Pro',
        color: AppColors.textPrimary,
        height: 1.5,
      );

  TextStyle get bodyMedium => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontFamily: 'SF Pro',
        color: AppColors.textPrimary,
        height: 1.5,
      );

  TextStyle get bodyRegular => const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        fontFamily: 'SF Pro',
        color: AppColors.primaryDark,
        height: 1.5,
      );

  TextStyle get smallBody => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontFamily: 'SF Pro',
        color: AppColors.textPrimary,
        height: 1.5,
      );

  TextStyle get text60016 => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'SF Pro',
        color: AppColors.textPrimary,
      );

  TextStyle get labelMedium => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'SF Pro',
        color: AppColors.textPrimary,
      );

  TextStyle get labelSmall => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        fontFamily: 'SF Pro',
        color: AppColors.textSecondary,
      );

  TextStyle get buttonLarge => TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w600,
        fontFamily: 'SF Pro',
        color: Colors.white,
      );

  TextStyle get buttonMedium => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'SF Pro',
        color: AppColors.textOnPrimary,
        letterSpacing: 0.5,
      );

  TextStyle get appName => TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'SF Pro',
        color: AppColors.textPrimary,
      );

  TextStyle get tagline => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontFamily: 'SF Pro',
        color: AppColors.textSecondary,
        height: 1.4,
      );
}
