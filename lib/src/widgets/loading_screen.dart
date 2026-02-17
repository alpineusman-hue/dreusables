import 'package:dreusables/src/const/theme/app_colors.dart';
import 'package:dreusables/src/core/extensions/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class LoadingDialog {
  static bool _isShowing = false;

  static void show(BuildContext context) {
    if (_isShowing) return;
    _isShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.background,
      builder: (context) => PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LoadingGif(size: 80),
                const SizedBox(height: 24),
                Text(
                  'Loading...',
                  style: Theme.of(context).textTheme.bodyRegular,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void hide(BuildContext context) {
    if (!_isShowing) return;
    _isShowing = false;

    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}

class LoadingGif extends StatelessWidget {
  const LoadingGif({super.key, this.size = 40, this.width, this.height});

  final double? size;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? size,
      height: height ?? size,
      child: Gif(
        image: const AssetImage('assets/gif/loading.gif'),
        autostart: Autostart.loop,
        placeholder: (context) => const SizedBox.shrink(),
      ),
    );
  }
}
