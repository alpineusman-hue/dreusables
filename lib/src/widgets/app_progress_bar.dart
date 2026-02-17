import 'package:dirtconnect/src/const/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppProgressBar extends StatelessWidget {
  final int currentStep;

  final int totalSteps;

  final double height;

  final Color? filledColor;

  final Color? unfilledColor;

  const AppProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.height = 8.0,
    this.filledColor,
    this.unfilledColor,
  })  : assert(currentStep > 0, 'Current step must be greater than 0'),
        assert(totalSteps > 0, 'Total steps must be greater than 0'),
        assert(
          currentStep <= totalSteps,
          'Current step cannot exceed total steps',
        );

  @override
  Widget build(BuildContext context) {
    final effectiveFilledColor = filledColor ?? const Color(0xFF8C7B5E);
    final effectiveUnfilledColor = unfilledColor ?? AppColors.borderLight;

    final progress = currentStep / totalSteps;

    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final filledWidth = constraints.maxWidth * progress;
            final unfilledWidth = constraints.maxWidth - filledWidth;

            return Row(
              children: [
                if (filledWidth > 0)
                  Container(width: filledWidth, color: effectiveFilledColor),
                if (unfilledWidth > 0)
                  Expanded(child: Container(color: effectiveUnfilledColor)),
              ],
            );
          },
        ),
      ),
    );
  }
}
