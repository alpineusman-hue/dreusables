import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MarkerIconUtils {
  /// Creates a BitmapDescriptor from an SVG asset
  ///
  /// [assetPath] - Path to the SVG asset (e.g., 'assets/svgs/marker.svg')
  /// [size] - Desired size of the marker (default: 48x48)
  static Future<BitmapDescriptor> createCustomMarkerFromSvg({
    required String assetPath,
    Size size = const Size(48, 48),
  }) async {
    try {
      final String svgString = await rootBundle.loadString(assetPath);
      final pictureInfo = await vg.loadPicture(SvgStringLoader(svgString), null);

      // Get device pixel ratio for sharp rendering
      final double devicePixelRatio =
          ui.PlatformDispatcher.instance.views.first.devicePixelRatio;

      // Render at native SVG size first for best quality
      final ui.Size nativeSize = pictureInfo.size;
      final ui.Image nativeImage = await pictureInfo.picture.toImage(
        nativeSize.width.toInt(),
        nativeSize.height.toInt(),
      );

      // Calculate aspect ratio from native SVG size
      final double aspectRatio = nativeSize.width / nativeSize.height;

      // Calculate final size maintaining aspect ratio
      double finalWidth;
      double finalHeight;

      if (aspectRatio > 1) {
        // Wider than tall - constrain by width
        finalWidth = size.width * devicePixelRatio;
        finalHeight = finalWidth / aspectRatio;
      } else {
        // Taller than wide - constrain by height
        finalHeight = size.height * devicePixelRatio;
        finalWidth = finalHeight * aspectRatio;
      }

      // Scale down from native size using high-quality filtering
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);

      final Rect srcRect = Rect.fromLTRB(
        0.0,
        0.0,
        nativeImage.width.toDouble(),
        nativeImage.height.toDouble(),
      );
      final Rect dstRect = Rect.fromLTRB(
        0.0,
        0.0,
        finalWidth,
        finalHeight,
      );

      // Use maximum quality filtering
      final paint = Paint()
        ..filterQuality = FilterQuality.high
        ..isAntiAlias = true;

      canvas.drawImageRect(nativeImage, srcRect, dstRect, paint);

      final ui.Image finalImage = await recorder
          .endRecording()
          .toImage(finalWidth.toInt(), finalHeight.toInt());

      final bytes = await finalImage.toByteData(format: ui.ImageByteFormat.png);

      // Clean up
      nativeImage.dispose();
      finalImage.dispose();
      pictureInfo.picture.dispose();

      if (bytes == null) {
        throw Exception('Failed to convert image to bytes');
      }

      // Calculate display size maintaining aspect ratio (reuse aspectRatio from above)
      double displayWidth;
      double displayHeight;

      if (aspectRatio > 1) {
        displayWidth = size.width;
        displayHeight = size.width / aspectRatio;
      } else {
        displayHeight = size.height;
        displayWidth = size.height * aspectRatio;
      }

      // Specify width and height for proper rendering
      return BitmapDescriptor.bytes(
        bytes.buffer.asUint8List(),
        width: displayWidth,
        height: displayHeight,
      );
    } catch (e) {
      debugPrint('Error creating custom marker from SVG: $e');
      return BitmapDescriptor.defaultMarker;
    }
  }

  /// Creates a BitmapDescriptor from an SVG string
  ///
  /// [svgString] - The SVG content as a string
  /// [size] - Desired size of the marker (default: 48x48)
  static Future<BitmapDescriptor> createCustomMarkerFromSvgString({
    required String svgString,
    Size size = const Size(48, 48),
  }) async {
    try {
      final pictureInfo = await vg.loadPicture(SvgStringLoader(svgString), null);

      final double devicePixelRatio =
          ui.PlatformDispatcher.instance.views.first.devicePixelRatio;
      final int width = (size.width * devicePixelRatio).toInt();
      final int height = (size.height * devicePixelRatio).toInt();

      final double scaleFactor = math.min(
        width / pictureInfo.size.width,
        height / pictureInfo.size.height,
      );

      final recorder = ui.PictureRecorder();

      ui.Canvas(recorder)
        ..scale(scaleFactor)
        ..drawPicture(pictureInfo.picture);

      final rasterPicture = recorder.endRecording();

      final image = await rasterPicture.toImage(width, height);
      final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;

      image.dispose();
      pictureInfo.picture.dispose();

      return BitmapDescriptor.bytes(bytes.buffer.asUint8List());
    } catch (e) {
      debugPrint('Error creating custom marker from SVG string: $e');
      return BitmapDescriptor.defaultMarker;
    }
  }

  /// Creates a BitmapDescriptor from an SVG URL
  ///
  /// [url] - URL to the SVG file
  /// [size] - Desired size of the marker (default: 48x48)
  static Future<BitmapDescriptor> createCustomMarkerFromSvgUrl({
    required String url,
    Size size = const Size(48, 48),
  }) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to load SVG from network: ${response.statusCode}');
      }

      return await createCustomMarkerFromSvgString(
        svgString: response.body,
        size: size,
      );
    } catch (e) {
      debugPrint('Error creating custom marker from SVG URL: $e');
      return BitmapDescriptor.defaultMarker;
    }
  }

  // Legacy method for PNG assets (if needed)
  static Future<BitmapDescriptor> createCustomMarkerFromAsset({
    required String assetPath,
    double width = 100,
    double height = 100,
  }) async {
    try {
      // Load the image from assets
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      // Decode the image to get its original dimensions
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image originalImage = frameInfo.image;

      // Get device pixel ratio for high quality rendering
      final double devicePixelRatio =
          ui.PlatformDispatcher.instance.views.first.devicePixelRatio;

      // Calculate aspect ratio from original image
      final double aspectRatio = originalImage.width / originalImage.height;

      // Calculate target dimensions maintaining aspect ratio
      double targetWidth;
      double targetHeight;

      // Use the smaller dimension as the constraint
      if (aspectRatio > 1) {
        // Image is wider than tall - constrain by width
        targetWidth = width;
        targetHeight = width / aspectRatio;
      } else {
        // Image is taller than wide - constrain by height
        targetHeight = height;
        targetWidth = height * aspectRatio;
      }

      // Multiply by device pixel ratio for crisp rendering
      final int scaledWidth = (targetWidth * devicePixelRatio).round();
      final int scaledHeight = (targetHeight * devicePixelRatio).round();

      // Create resized codec with proper aspect ratio and high resolution
      final ui.Codec resizedCodec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: scaledWidth,
        targetHeight: scaledHeight,
      );

      final ui.FrameInfo resizedFrameInfo = await resizedCodec.getNextFrame();
      final ui.Image resizedImage = resizedFrameInfo.image;

      // Convert to PNG bytes
      final ByteData? pngBytes = await resizedImage.toByteData(
        format: ui.ImageByteFormat.png,
      );

      // Clean up
      originalImage.dispose();
      resizedImage.dispose();

      if (pngBytes == null) {
        throw Exception('Failed to convert image to bytes');
      }

      return BitmapDescriptor.bytes(
        pngBytes.buffer.asUint8List(),
      );
    } catch (e) {
      debugPrint('Error creating custom marker from asset: $e');
      return BitmapDescriptor.defaultMarker;
    }
  }
}
