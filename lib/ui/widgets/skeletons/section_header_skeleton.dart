import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SectionHeaderSkeleton extends StatelessWidget {
  const SectionHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.surfaceContainer,
      highlightColor: context.colors.surface,
      child: Padding(
        padding: kHorizontalPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 200.0,
              height: 48.0,
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 5.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}