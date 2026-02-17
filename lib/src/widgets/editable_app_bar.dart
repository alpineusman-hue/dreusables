import 'package:dirtconnect/src/const/theme/app_colors.dart';
import 'package:dirtconnect/src/core/extensions/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class EditableAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EditableAppBar({
    super.key,
    required this.data,
    this.actionWidgets = const [],
  });

  final String data;
  final List<Widget> actionWidgets;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.background,
      leading: InkWell(
        onTap: () {
          if (context.canPop()) {
            context.pop();
          } else {
            // Stack was replaced (e.g. after Firebase reCAPTCHA redirect).
            // Go to home as a safe fallback.
            context.go('/home');
          }
        },
        child: SvgPicture.asset(
          'assets/svgs/arrow-left.svg',
          fit: BoxFit.scaleDown,
        ),
      ),
      centerTitle: true,
      title: Text(
        data,
        style: Theme.of(context).textTheme.bodyRegular.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
      ),
      actions: actionWidgets,
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 50);
}
