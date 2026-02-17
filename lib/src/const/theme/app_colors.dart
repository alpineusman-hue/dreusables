import 'package:flutter/material.dart';

/// App color palette extracted from Figma designs
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary =
      Color(0xFF1A1A1A); // Dark grey/black for buttons and text
  static const Color primaryLight = Color(0xFF2A2A2A);
  static const Color primaryDark = Color(0xFF000000);
  static const Color tabBarGrey = Color(0xFF767680);
  static const Color tabBarGreyBorder = Color(0xFF3C3C43);
  static const Color secondaryDark = Color(0xFF292826);
  static const Color textWhite = Color(0xffFAFAFA);
  static const Color divider = Color(0xFFE5E5E5);
  static const Color bottomSheetBar = Color(0xFFCECECE);
  static const Color greyBlack = Color(0xFF474747);
  static const Color overlayBlack = Color(0xFF292826);
  static const Color greyBottom = Color(0xff848484);
  static const Color blackBottom = Color(0xff0A0A0A);
  static const Color brown = Color(0xFF9A8664);

  // Background Colors
  static const Color background = Color(0xFFFFFFFF); // White background
  static const Color backgroundGrey =
      Color(0xFFF5F5F5); // Light grey for input fields

  // Accent Colors
  static const Color accentYellow = Color(0xFFFFD700); // Golden yellow for logo
  static const Color accentYellowDark = Color(0xFFFFC107);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A); // Dark grey/black
  static const Color textSecondary = Color(0xFF666666); // Medium grey
  static const Color textTertiary = Color(0xFF999999); // Light grey
  static const Color textOnPrimary =
      Color(0xFFFFFFFF); // White text on dark buttons

  // Border Colors
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderMedium = Color(0xFFCCCCCC);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Google Colors
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color googleRed = Color(0xFFEA4335);
  static const Color googleYellow = Color(0xFFFBBC05);
  static const Color googleGreen = Color(0xFF34A853);
}
