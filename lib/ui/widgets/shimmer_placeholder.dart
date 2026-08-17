import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:aniyoka/ui/common/ui_helpers.dart';

class ShimmerPlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;

  const ShimmerPlaceholder({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.surfaceContainer,
      highlightColor: context.colors.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}