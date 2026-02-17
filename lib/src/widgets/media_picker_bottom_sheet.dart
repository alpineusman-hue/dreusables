import 'package:dirtconnect/src/const/theme/app_colors.dart';
import 'package:dirtconnect/src/core/extensions/widget_extension.dart';
import 'package:dirtconnect/src/core/utils/image_picker_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum MediaPickerMode { single, multiple }

class MediaPickerBottomSheet extends StatelessWidget {
  const MediaPickerBottomSheet({
    super.key,
    required this.mode,
    this.cameraLabel = 'Take a photo',
    this.galleryLabel = 'Choose from gallery',
    this.onImagePicked,
    this.onImagesPicked,
    this.onError,
    this.maxImages = 5,
    this.currentImageCount = 0,
  });

  final MediaPickerMode mode;
  final String cameraLabel;
  final String galleryLabel;
  final ValueChanged<String>? onImagePicked;
  final ValueChanged<List<String>>? onImagesPicked;
  final ValueChanged<String>? onError;
  final int maxImages;
  final int currentImageCount;

  static Future<void> show(
    BuildContext context, {
    required MediaPickerMode mode,
    String cameraLabel = 'Take a photo',
    String galleryLabel = 'Choose from gallery',
    ValueChanged<String>? onImagePicked,
    ValueChanged<List<String>>? onImagesPicked,
    ValueChanged<String>? onError,
    int maxImages = 5,
    int currentImageCount = 0,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (bottomSheetContext) => MediaPickerBottomSheet(
        mode: mode,
        cameraLabel: cameraLabel,
        galleryLabel: galleryLabel,
        onImagePicked: onImagePicked,
        onImagesPicked: onImagesPicked,
        onError: onError,
        maxImages: maxImages,
        currentImageCount: currentImageCount,
      ),
    );
  }

  Future<void> _handleCameraTap(BuildContext context) async {
    Navigator.pop(context);
    final imagePickerUtil = ImagePickerUtil();

    if (mode == MediaPickerMode.single) {
      final String? path = await imagePickerUtil.pickImageFromCamera();
      if (path != null) {
        onImagePicked?.call(path);
      } else {
        onError?.call('Camera permission denied or photo capture cancelled');
      }
    } else {
      final String? path = await imagePickerUtil.pickImageFromCamera();
      if (path != null) {
        if (currentImageCount < maxImages) {
          onImagesPicked?.call([path]);
        } else {
          onError?.call('Maximum $maxImages photos allowed');
        }
      } else {
        onError?.call('Camera permission denied or photo capture cancelled');
      }
    }
  }

  Future<void> _handleGalleryTap(BuildContext context) async {
    Navigator.pop(context);
    final imagePickerUtil = ImagePickerUtil();

    if (mode == MediaPickerMode.single) {
      final String? path = await imagePickerUtil.pickSingleImage();
      if (path != null) {
        onImagePicked?.call(path);
      }
      return;
    }

    final result = await imagePickerUtil.pickMultipleImages(
      maxImages: maxImages,
      currentImageCount: currentImageCount,
    );

    if (result.isSuccess && result.imagePaths.isNotEmpty) {
      onImagesPicked?.call(result.imagePaths);
    } else if (result.error != null) {
      onError?.call(result.error!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.bottomSheetBar,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          16.heightBox,
          SvgPicture.asset('assets/svgs/logo.svg').centered,
          20.heightBox,
          ListTile(
            leading: const Icon(Icons.camera_alt_rounded),
            title: Text(cameraLabel),
            onTap: () => _handleCameraTap(context),
          ),
          ListTile(
            leading: const Icon(Icons.add_photo_alternate_rounded),
            title: Text(galleryLabel),
            onTap: () => _handleGalleryTap(context),
          ),
        ],
      ),
    );
  }
}
