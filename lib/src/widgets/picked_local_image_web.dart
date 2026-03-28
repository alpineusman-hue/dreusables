import 'package:flutter/material.dart';

class PickedLocalImage extends StatelessWidget {
  const PickedLocalImage({
    super.key,
    required this.path,
    required this.boxFit,
  });

  final String path;
  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      path,
      fit: boxFit,
      errorBuilder: (context, error, stackTrace) =>
          const Center(child: Icon(Icons.broken_image_outlined)),
    );
  }
}
