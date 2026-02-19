import 'package:dreusables/src/const/theme/app_colors.dart';
import 'package:dreusables/src/core/extensions/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    this.isNegative = false,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.prefix,
    this.height = 56,
    this.fontSize = 17,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final bool isNegative;
  final Widget? prefix;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return TextButton(
      onPressed: isLoading ? null : (onPressed ?? () {}),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        maximumSize: Size(double.infinity, height),
        minimumSize: Size(double.infinity, height),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: isNegative ? Colors.white : AppColors.secondaryDark,
        foregroundColor: textColor ?? AppColors.textOnPrimary,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isNegative ? const Color(0xffE5E5E5) : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (prefix != null) ...[prefix!, const SizedBox(width: 8)],
          Text(
            text,
            style: theme.buttonLarge.copyWith(
              fontSize: fontSize,
              color: isNegative ? AppColors.secondaryDark : AppColors.textWhite,
            ),
          ),
        ],
      ),
    );
  }
}
