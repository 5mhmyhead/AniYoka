import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:shimmer/shimmer.dart';

class HeroCarouselSkeleton extends StatelessWidget {
  const HeroCarouselSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.surfaceContainer,
      highlightColor: context.colors.surface,
      child: Column(
        children: [
          FlutterCarousel.builder(
            itemCount: 3,
            itemBuilder: (context, itemIndex, pageIndex) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.xlSize),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        color: context.colors.surface,
                      ),
                    ],
                  ),
                ),
              );
            },
            options: FlutterCarouselOptions(
              height: 373.0,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 1,
              enableInfiniteScroll: false,
              autoPlay: false,
              floatingIndicator: false,
              showIndicator: false,
            ),
          ),
          verticalSpaceMd,
          Container(
            width: 145.0,
            height: 8.0,
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          verticalSpaceSm,
        ],
      ),
    );
  }
}