import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerResult {
  final List<String> imagePaths;
  final String? error;

  const ImagePickerResult({
    required this.imagePaths,
    this.error,
  });

  bool get isSuccess => error == null;
}

class ImagePickerUtil {
  final ImagePicker _picker = ImagePicker();

  Future<ImagePickerResult> pickMultipleImages({
    int maxImages = 5,
    int currentImageCount = 0,
  }) async {
    try {
      final remainingSlots = maxImages - currentImageCount;
      if (remainingSlots <= 0) {
        return ImagePickerResult(
          imagePaths: const [],
          error: 'Maximum $maxImages photos allowed',
        );
      }
      final List<XFile> images = await _picker.pickMultiImage();

      if (images.isEmpty) {
        return const ImagePickerResult(
          imagePaths: [],
          error: null,
        );
      }
      final selectedImages = images.take(remainingSlots).toList();
      final imagePaths = selectedImages.map((image) => image.path).toList();

      debugPrint('✅ ImagePickerUtil: Picked ${imagePaths.length} images');

      return ImagePickerResult(imagePaths: imagePaths);
    } catch (e) {
      debugPrint('❌ ImagePickerUtil: Error picking images: $e');
      return ImagePickerResult(
        imagePaths: [],
        error: 'Error picking images: ${e.toString()}',
      );
    }
  }

  Future<String?> pickSingleImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (image == null) {
        return null;
      }

      debugPrint('✅ ImagePickerUtil: Picked single image: ${image.path}');
      return image.path;
    } catch (e) {
      debugPrint('❌ ImagePickerUtil: Error picking image: $e');
      return null;
    }
  }

  Future<String?> pickImageFromCamera() async {
    try {
      final permissionStatus = await Permission.camera.status;
      if (!permissionStatus.isGranted) {
        final requestResult = await Permission.camera.request();
        if (!requestResult.isGranted) {
          debugPrint('❌ ImagePickerUtil: Camera permission denied');
          return null;
        }
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
      );

      if (image == null) {
        return null;
      }

      debugPrint('✅ ImagePickerUtil: Picked image from camera: ${image.path}');
      return image.path;
    } catch (e) {
      debugPrint('❌ ImagePickerUtil: Error picking image from camera: $e');
      return null;
    }
  }

  Future<ImagePickerResult> pickImagesWithSource({
    int maxImages = 5,
    int currentImageCount = 0,
    bool allowCamera = false,
  }) async {
    if (allowCamera) {
      return pickMultipleImages(
        maxImages: maxImages,
        currentImageCount: currentImageCount,
      );
    }
    return pickMultipleImages(
      maxImages: maxImages,
      currentImageCount: currentImageCount,
    );
  }
}
