import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter/material.dart';

// generated code, will refactor later since
// class could use existing SlideIndicatorOptions found in package
class CustomSlideIndicator implements SlideIndicator {
  final Color activeColor;
  final Color inactiveColor;
  final double dotHeight;
  final double dotWidth;
  final double activeDotWidth;
  final double spacing;
  final Alignment geometry;

  CustomSlideIndicator({
    required this.activeColor,
    required this.inactiveColor,
    this.dotHeight = 8.0,
    this.dotWidth = 8.0,
    this.activeDotWidth = 16.0,
    this.spacing = 6.0,
    this.geometry = Alignment.bottomCenter,
  });

  @override
  Widget build(int currentPage, double pageDelta, int itemCount) {
    if (itemCount < 2) return const SizedBox.shrink();

    return Align(
      alignment: geometry,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(itemCount, (index) {
            final isCurrent = index == currentPage;
            final isNext = index == (currentPage + 1) % itemCount;

            double width = dotWidth;
            Color color = inactiveColor;

            if (isCurrent) {
              width =
                  activeDotWidth - ((activeDotWidth - dotWidth) * pageDelta);
              color = Color.lerp(activeColor, inactiveColor, pageDelta)!;
            } else if (isNext) {
              // expands to double width during scroll
              width = dotWidth + ((activeDotWidth - dotWidth) * pageDelta);
              color = Color.lerp(inactiveColor, activeColor, pageDelta)!;
            }

            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: EdgeInsets.symmetric(horizontal: spacing / 2),
              width: width,
              height: dotHeight,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(dotHeight / 2),
              ),
            );
          }),
        ),
      ),
    );
  }
}
