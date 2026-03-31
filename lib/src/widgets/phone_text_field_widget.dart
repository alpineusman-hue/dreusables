import 'package:dreusables/dirconnect_package.dart';
import 'package:flutter/material.dart';
import 'package:phone_text_field/phone_text_field.dart';

class PhoneTextFieldWidget extends StatefulWidget {
  const PhoneTextFieldWidget({
    super.key,
    required this.newPhoneNumber,
    this.syncController,
    this.readOnly = false,
  });

  final String newPhoneNumber;
  final TextEditingController? syncController;
  final bool readOnly;

  @override
  State<PhoneTextFieldWidget> createState() => _PhoneTextFieldWidgetState();
}

class _PhoneTextFieldWidgetState extends State<PhoneTextFieldWidget> {
  String newPhoneNumber = '';

  @override
  void initState() {
    super.initState();
    if (widget.newPhoneNumber.isNotEmpty) {
      newPhoneNumber = widget.newPhoneNumber;
    } else if (widget.syncController != null &&
        widget.syncController!.text.trim().isNotEmpty) {
      newPhoneNumber = widget.syncController!.text.trim();
    } else {
      newPhoneNumber = '';
    }
    _syncToControllerIfNeeded();
  }

  @override
  void didUpdateWidget(covariant PhoneTextFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.newPhoneNumber != oldWidget.newPhoneNumber) {
      newPhoneNumber = widget.newPhoneNumber;
      _syncToControllerIfNeeded();
    }
  }

  void _syncToControllerIfNeeded() {
    final c = widget.syncController;
    if (c == null) return;
    final incoming = widget.newPhoneNumber;
    if (incoming.isNotEmpty && c.text != incoming) {
      c.text = incoming;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return PhoneTextField(
      key: ValueKey<String>('phone_tf_${widget.newPhoneNumber}'),
      initialCountryCode: 'AU',
      showCountryCodeAsIcon: true,
      initialValue:
          widget.newPhoneNumber.isNotEmpty ? widget.newPhoneNumber : null,
      enabled: !widget.readOnly,
      onChanged: (phoneNumber) {
        final complete = phoneNumber.completeNumber;
        setState(() {
          newPhoneNumber = complete;
        });
        widget.syncController?.text = complete;
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
