import 'package:dirtconnect/src/const/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EditableRefreshIndicator extends StatelessWidget {
  const EditableRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: AppColors.primary,
      color: AppColors.accentYellow,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
