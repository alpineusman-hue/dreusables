import 'package:flutter/material.dart';

extension SizeExtension on num {
  SizedBox get heightBox => SizedBox(
        height: toDouble(),
      );

  SizedBox get widthBox => SizedBox(
        width: toDouble(),
      );
}

extension SliverExtension on Widget {
  Widget get sliver {
    return SliverToBoxAdapter(
      child: this,
    );
  }
}

extension PaddingExtension on Widget {
  Widget withHorizontalPadding(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: this,
    );
  }
}

extension BottomPaddingExtension on Widget {
  Widget withBottomPadding(double padding) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: this,
    );
  }
}

extension CenterExtension on Widget {
  Widget get centered {
    return Center(
      child: this,
    );
  }
}

extension LeftExtension on Widget {
  Widget get leftAligned {
    return Align(
      alignment: Alignment.topLeft,
      child: this,
    );
  }
}
