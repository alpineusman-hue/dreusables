import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key, this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          onTap ??
          () {
            if (context.canPop()) {
              context.pop();
            }
          },
      child: SvgPicture.asset('assets/svgs/arrow-left.svg'),
    );
  }
}
