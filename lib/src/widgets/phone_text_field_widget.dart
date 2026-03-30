import 'package:dreusables/dirconnect_package.dart';
import 'package:flutter/material.dart';
import 'package:phone_text_field/phone_text_field.dart';

class PhoneTextFieldWidget extends StatefulWidget {
  const PhoneTextFieldWidget({
    super.key,
    required this.newPhoneNumber,
  });

  final String newPhoneNumber;

  @override
  State<PhoneTextFieldWidget> createState() => _PhoneTextFieldWidgetState();
}

class _PhoneTextFieldWidgetState extends State<PhoneTextFieldWidget> {
  String newPhoneNumber = '';

  @override
  void initState() {
    super.initState();
    newPhoneNumber = widget.newPhoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return PhoneTextField(
      initialCountryCode: 'AU',
      showCountryCodeAsIcon: true,
      onChanged: (phoneNumber) {
        setState(() {
          newPhoneNumber = phoneNumber.completeNumber;
        });
      },
      textStyle: theme.bodyMedium,
      decoration: InputDecoration(
        hintText: '0000000000',
        hintStyle: theme.bodyMedium?.copyWith(
          color: AppColors.textTertiary,
        ),
        filled: true,
        fillColor: AppColors.backgroundGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.inputPadding,
          vertical: AppSpacing.inputPadding,
        ),
      ),
      searchFieldInputDecoration: InputDecoration(
        hintText: 'Search country',
        hintStyle: theme.bodyMedium?.copyWith(
          color: AppColors.textTertiary,
        ),
        filled: true,
        fillColor: AppColors.backgroundGrey,
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.textTertiary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.inputPadding,
          vertical: AppSpacing.inputPadding,
        ),
      ),
    );
  }
}
