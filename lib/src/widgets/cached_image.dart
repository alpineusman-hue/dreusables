import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreusables/src/const/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CachedImageWidget extends StatelessWidget {
  const CachedImageWidget({
    super.key,
    this.width,
    this.borderRadius,
    required this.url,
    this.size,
    this.fit,
  });

  final String url;
  final double? size;
  final double? width;
  final double? borderRadius;
  final BoxFit? fit;

  bool _isNetworkUrl(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🖼️ CachedImageWidget: Building with URL: $url');
    debugPrint('   isEmpty: ${url.isEmpty}');
    debugPrint('   isNetwork: ${_isNetworkUrl(url)}');

    if (url.isEmpty) {
      debugPrint('   ⚠️ URL is empty, showing placeholder');
      return _buildPlaceholder();
    }

    return Container(
      width: width ?? size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
        border: Border.all(color: AppColors.divider),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
        child: _isNetworkUrl(url) ? _buildNetworkImage() : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      cacheKey: url,
      key: Key(url),
      imageUrl: url,
      width: width ?? size,
      height: size,
      fit: fit ?? BoxFit.cover,
      imageBuilder: (context, imageProvider) =>
          Image(image: imageProvider, fit: fit ?? BoxFit.cover),
      progressIndicatorBuilder: (context, url, progress) {
        double progressSize = (size ?? width ?? 40) * 0.5;
        return Container(
          color: AppColors.backgroundGrey,
          child: Center(
            child: SizedBox(
              width: progressSize,
              height: progressSize,
              child: CircularProgressIndicator.adaptive(
                value: progress.progress,
                strokeCap: StrokeCap.round,
                strokeWidth: 2,
              ),
            ),
          ),
        );
      },
      errorWidget: (context, url, error) {
        debugPrint('❌ Error loading network image: $url - $error');
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width ?? size,
      height: size,
      color: AppColors.backgroundGrey,
      child: const Icon(Icons.image_outlined, color: AppColors.greyBlack),
    );
  }
}
