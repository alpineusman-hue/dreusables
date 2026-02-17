import 'package:dirtconnect/src/const/theme/app_colors.dart';
import 'package:dirtconnect/src/core/extensions/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ParentAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ParentAppBar({
    super.key,
    this.showLogo = false,
    this.title = '',
    this.onProfileIconTap,
  });

  final bool showLogo;
  final String title;
  final void Function()? onProfileIconTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      child: Container(
        color: AppColors.background,
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.paddingOf(context).top + 12,
          16,
          12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (showLogo)
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(8),
                child: SvgPicture.asset(
                  'assets/svgs/logo.svg',
                  width: 20,
                  height: 20,
                  fit: BoxFit.scaleDown,
                ),
              )
            else
              Expanded(
                child: Text(title, style: Theme.of(context).textTheme.appName),
              ),
            InkWell(
              onTap: onProfileIconTap,
              child: SvgPicture.asset('assets/svgs/user.svg'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 50);
}
