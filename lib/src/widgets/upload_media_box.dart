import 'package:dirtconnect/src/const/theme/app_colors.dart';
import 'package:flutter/material.dart';

class UploadMediaBox extends StatelessWidget {
  const UploadMediaBox({super.key, this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(30),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              spreadRadius: 1,
              offset: const Offset(0, 0),
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.blackBottom,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.add, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }
}
