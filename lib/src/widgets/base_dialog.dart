import 'dart:math';
import 'package:dirtconnect/src/const/theme/app_colors.dart';
import 'package:dirtconnect/src/core/extensions/app_text_styles.dart';
import 'package:dirtconnect/src/core/extensions/widget_extension.dart';
import 'package:dirtconnect/src/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BaseDialog extends StatefulWidget {
  const BaseDialog({
    super.key,
    this.color = Colors.white,
    required this.heading,
    this.subTitle = '',
    this.onPressed,
  });

  final Color color;
  final String heading;
  final String subTitle;
  final void Function()? onPressed;

  @override
  State<BaseDialog> createState() => _BaseDialogState();

  Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(context: context, builder: (_) => this) ??
        false;
  }
}

class _BaseDialogState extends State<BaseDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Start animation when dialog appears
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 1),
                        blurRadius: 12,
                        spreadRadius: 0,
                        color: const Color(0xff000000).withValues(alpha: 0.15),
                      ),
                    ],
                  ),
                  width: min(314, MediaQuery.of(context).size.width),
                  padding: const EdgeInsets.fromLTRB(30, 8.97, 30, 22),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.heading,
                          style: theme.h1.copyWith(fontSize: 16),
                        ).leftAligned,
                        if (widget.subTitle != '') ...[
                          15.heightBox,
                          Text(
                            widget.subTitle,
                            style: theme.bodyRegular,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ).leftAligned,
                        ],
                        20.heightBox,
                        Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                height: 42,
                                onPressed: () {
                                  if (context.canPop()) {
                                    context.pop();
                                  }
                                },
                                isNegative: true,
                                text: 'Close',
                              ),
                            ),
                            16.widthBox,
                            Expanded(
                              child: AppButton(
                                height: 42,
                                onPressed: widget.onPressed,
                                text: 'Yes',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
