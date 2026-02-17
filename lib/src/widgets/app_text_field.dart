import 'package:dirtconnect/src/const/theme/app_colors.dart';
import 'package:dirtconnect/src/const/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.hint,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.textEditingController,
    this.controller,
    this.suffixIcon,
    this.readOnly,
    this.prefix,
    this.obscureText,
    this.onCountryTap,
    this.onTap,
    this.textFieldUpperText,
    this.onSaved,
    this.onFieldSubmitted,
    this.autofillHints,
    this.initialValue,
    this.maxLines,
    this.maxLength,
    this.counterText,
    this.onChanged,
    this.inputFormatters,
    this.enablePasswordToggle,
    this.textInputAction = TextInputAction.done,
    this.suffixText,
  });

  final String? hint;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefix;
  final bool? readOnly;
  final bool? obscureText;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final FormFieldValidator<String>? validator;
  final TextEditingController? textEditingController;
  final TextEditingController? controller;
  final VoidCallback? onCountryTap;
  final String? textFieldUpperText;
  final FormFieldSetter<String>? onSaved;
  final Function(String)? onFieldSubmitted;
  final String? initialValue;
  final int? maxLines;
  final int? maxLength;
  final String? counterText;
  final bool? enablePasswordToggle;
  final TextInputAction textInputAction;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final String? suffixText;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    if (widget.enablePasswordToggle == true) {
      _obscureText = true;
    } else {
      _obscureText = widget.obscureText ?? false;
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final effectiveHint = widget.hintText ?? widget.hint;
    final effectiveController =
        widget.controller ?? widget.textEditingController;

    final shouldObscureText = widget.enablePasswordToggle == true
        ? _obscureText
        : (widget.obscureText ?? false);

    Widget? effectiveSuffixIcon;
    if (widget.enablePasswordToggle == true) {
      effectiveSuffixIcon = IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textSecondary,
        ),
        onPressed: _togglePasswordVisibility,
      );
    } else {
      effectiveSuffixIcon = widget.suffixIcon;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff1018280d).withValues(alpha: 0.05),
            blurRadius: 2,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextFormField(
        readOnly: widget.readOnly ?? false,
        initialValue: effectiveController == null ? widget.initialValue : null,
        onTap: widget.onTap,
        inputFormatters: widget.inputFormatters,
        autofillHints: widget.autofillHints,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        textInputAction: widget.textInputAction,
        obscureText: shouldObscureText,
        keyboardType: widget.enablePasswordToggle == true
            ? (widget.keyboardType ?? TextInputType.visiblePassword)
            : widget.keyboardType,
        validator: widget.validator,
        controller: effectiveController,
        onSaved: widget.onSaved,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        style: theme.bodyMedium,
        decoration: InputDecoration(
          hintText: effectiveHint,
          hintStyle: theme.bodyMedium?.copyWith(color: AppColors.textTertiary),
          prefixIcon: widget.prefix,
          suffixIcon: effectiveSuffixIcon,
          suffixText: widget.suffixText,
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.inputPadding,
            vertical: AppSpacing.inputPadding,
          ),
        ),
        cursorColor: AppColors.primary,
      ),
    );
  }
}
