import 'package:dreusables/src/const/theme/app_colors.dart';
import 'package:dreusables/src/core/extensions/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppOtpField extends StatefulWidget {
  const AppOtpField({
    super.key,
    this.length = 6,
    this.onCompleted,
    this.onChanged,
    this.controller,
    this.validator,
  });

  final int length;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  State<AppOtpField> createState() => _AppOtpFieldState();
}

class _AppOtpFieldState extends State<AppOtpField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late String _otpCode;
  final List<String> _previousValues = [];

  @override
  void initState() {
    super.initState();
    _otpCode = widget.controller?.text ?? '';
    _controllers = List.generate(widget.length, (index) {
      final controller = TextEditingController();
      _previousValues.add('');
      // Don't add listener here - it updates _previousValues too early
      // We update it manually in _onFieldChanged after checking the previous value
      return controller;
    });
    _focusNodes = List.generate(widget.length, (index) => FocusNode());

    if (widget.controller != null) {
      _syncFromExternalController();
      widget.controller!.addListener(_syncFromExternalController);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    if (widget.controller != null) {
      widget.controller!.removeListener(_syncFromExternalController);
    }
    super.dispose();
  }

  void _syncFromExternalController() {
    if (widget.controller == null) return;
    final text = widget.controller!.text;
    final newCode =
        text.length <= widget.length ? text : text.substring(0, widget.length);

    final currentCode = _controllers.map((c) => c.text).join();
    if (newCode != currentCode) {
      for (int i = 0; i < widget.length; i++) {
        if (i < newCode.length) {
          _controllers[i].text = newCode[i];
        } else {
          _controllers[i].clear();
        }
      }
      _otpCode = newCode;
      setState(() {});

      widget.onChanged?.call(newCode);

      if (newCode.length == widget.length) {
        widget.onCompleted?.call(newCode);
      }
    }
  }

  void _updateOtpCode() {
    final newCode = _controllers.map((c) => c.text).join();
    if (newCode != _otpCode) {
      _otpCode = newCode;

      if (widget.controller != null && widget.controller!.text != _otpCode) {
        widget.controller!.text = _otpCode;
      }

      widget.onChanged?.call(_otpCode);

      if (_otpCode.length == widget.length) {
        // Haptic feedback on OTP completion
        HapticFeedback.mediumImpact();
        widget.onCompleted?.call(_otpCode);
      }

      setState(() {});
    }
  }

  void _onFieldChanged(int index, String value) {
    final previousValue = _previousValues[index];

    // Handle auto-fill: if multiple digits pasted, distribute them
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'\D'), ''); // Extract only digits

      // Distribute digits across fields
      for (int i = 0; i < digits.length && (index + i) < widget.length; i++) {
        _controllers[index + i].text = digits[i];
        _previousValues[index + i] = digits[i];
      }

      // Update OTP code and focus
      _updateOtpCode();

      // Move focus to the next empty field or last field
      final nextIndex = (index + digits.length).clamp(0, widget.length - 1);
      if (nextIndex < widget.length) {
        _focusNodes[nextIndex].requestFocus();
      }

      return;
    }

    if (value.isNotEmpty) {
      // Haptic feedback on digit entry
      HapticFeedback.selectionClick();
      _updateOtpCode();
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      }
    } else {
      // Field became empty (backspace was pressed)
      _updateOtpCode();

      // Mobile-friendly backspace: when you delete a digit, move to previous field
      // This is common UX in mobile OTP fields - more fluid than desktop behavior
      if (previousValue.isNotEmpty && index > 0) {
        // Move to previous field after deleting current digit
        _focusNodes[index - 1].requestFocus();
      }
    }

    _previousValues[index] = value;
  }

  void _onFieldSubmitted(int index) {
    if (index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else {
      _focusNodes[index].unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.length, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: _buildOtpField(index),
          ),
        );
      }),
    );
  }

  Widget _buildOtpField(int index) {
    final theme = Theme.of(context).textTheme;

    InputBorder border(Color? color) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color ?? const Color(0xffE5E5E5)),
      );
    }

    return SizedBox(
      height: 52,
      child: TextFormField(
        validator: widget.validator,
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        // Only restrict maxLength on non-first fields
        // First field needs to receive full OTP for autofill
        maxLength: index == 0 ? null : 1,
        style: theme.h3,
        // Only add autofill hint to the first field to enable proper OTP autofill
        autofillHints: index == 0 ? const [AutofillHints.oneTimeCode] : null,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          // Only add length limiter to non-first fields
          if (index > 0) LengthLimitingTextInputFormatter(1),
        ],
        onChanged: (value) => _onFieldChanged(index, value),
        onFieldSubmitted: (_) => _onFieldSubmitted(index),
        onTap: () {
          _controllers[index].selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controllers[index].text.length,
          );
        },
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: const Color(0xffF3F3F5),
          border: border(const Color(0xffE5E5E5)),
          enabledBorder: border(const Color(0xffE5E5E5)),
          focusedBorder: border(AppColors.primaryDark),
        ),
      ),
    );
  }
}
