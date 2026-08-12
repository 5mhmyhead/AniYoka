import 'package:aniyoka/models/media_model.dart';
import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:aniyoka/ui/widgets/custom_tag.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class HeroCarousel extends StatelessWidget {
  final List<Media> listItems; 

  const HeroCarousel({super.key, required this.listItems});

  @override
  Widget build(BuildContext context) {
    if (listItems.isEmpty) return const SizedBox.shrink(); // TODO: change to no anime found 

    return FlutterCarousel.builder(
      itemCount: listItems.length,
      itemBuilder: (context, itemIndex, pageIndex) {
        final item = listItems[itemIndex];
    
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: GestureDetector(
            onTap: () {
              // TODO: add anime info view here
            },
            onLongPress: () {
              // TODO: open anime info bottom sheet here 
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: item.coverImage,
                    fit: BoxFit.cover,
                    // TODO: add proper errorWidget here
                  ),
                  // overlayed bottom gradient over cover image
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                        stops: [0.6, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            CustomTag(label: Text(item.format), opacity: 0.75),
                            horizontalSpaceSm,
                            CustomTag(
                              icon: const Icon(
                                Icons.star_rounded,
                                color: Colors.amberAccent,
                                size: 16,
                              ),
                              label: Text(item.rating.toStringAsFixed(1)),
                              opacity: 0.75,
                            ),
                          ],
                        ),
                        verticalSpaceSm,
                        Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.headlineLarge?.copyWith(
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      options: FlutterCarouselOptions(
        height: 405.0,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        // auto play options
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 6),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        // carousel uses custom indicator
        floatingIndicator: false,
        slideIndicator: CustomSlideIndicator(
          activeColor: context.colors.primary,
          inactiveColor: context.colors.surfaceContainer,
          activeDotWidth: 20.0,
        ),
      ),
    );
  }
}

// note: generated code, will refactor later since
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
