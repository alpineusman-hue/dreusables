import 'package:dreusables/dirconnect_package.dart';
import 'package:flutter/material.dart';

import 'picked_local_image.dart'
    if (dart.library.html) 'picked_local_image_web.dart';

class SelectedImageBox extends StatelessWidget {
  const SelectedImageBox({
    super.key,
    required this.imagePath,
    this.onTap,
    this.isNetworkUrl = false,
  });

  final String imagePath;
  final void Function()? onTap;
  final bool isNetworkUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xffE5E5E5)),
          ),
          child: isNetworkUrl
              ? CachedImageWidget(url: imagePath)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: PickedLocalImage(
                    path: imagePath,
                    boxFit: BoxFit.cover,
                  ),
                ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
