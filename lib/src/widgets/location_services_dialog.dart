import 'package:dirtconnect/src/const/theme/app_colors.dart';
import 'package:dirtconnect/src/core/extensions/app_text_styles.dart';
import 'package:dirtconnect/src/core/extensions/widget_extension.dart';
import 'package:dirtconnect/src/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class LocationServicesDialog extends StatefulWidget {
  const LocationServicesDialog({super.key});

  @override
  State<LocationServicesDialog> createState() => _LocationServicesDialogState();

  static Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => const LocationServicesDialog(),
        ) ??
        false;
  }
}

class _LocationServicesDialogState extends State<LocationServicesDialog>
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

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _openLocationSettings() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      bool opened = false;
      if (!serviceEnabled) {
        opened = await Geolocator.openLocationSettings();
      } else {
        opened = await ph.openAppSettings();
      }

      if (opened && mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      try {
        final opened = await ph.openAppSettings();
        if (opened && mounted) {
          Navigator.of(context).pop(true);
        }
      } catch (_) {
        if (mounted) {
          Navigator.of(context).pop(false);
        }
      }
    }
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
                  width: 314,
                  padding: const EdgeInsets.fromLTRB(18, 24, 18, 22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_off,
                          size: 32,
                          color: AppColors.error,
                        ),
                      ),
                      20.heightBox,
                      Text(
                        'Location Services Disabled',
                        style: theme.h1.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      12.heightBox,
                      Text(
                        'Please enable location services to see markers near your location. You can enable it from your device settings.',
                        style: theme.bodyRegular.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      24.heightBox,
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              height: 42,
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              isNegative: true,
                              text: 'Cancel',
                            ),
                          ),
                          16.widthBox,
                          Expanded(
                            child: AppButton(
                              height: 42,
                              onPressed: _openLocationSettings,
                              text: 'Enable Location',
                            ),
                          ),
                        ],
                      ),
                    ],
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
