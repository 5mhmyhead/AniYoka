import 'dart:ui';
import 'package:aniyoka/models/media_model.dart';
import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:aniyoka/ui/widgets/shimmer_placeholder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MediaHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Media media;
  final Widget tabBar;
  final double topPadding;
  final double screenWidth;
  final VoidCallback onFavoritePressed;
  final VoidCallback onSharePressed;
  final TextTheme textTheme;

  const MediaHeaderDelegate({
    required this.media,
    required this.tabBar,
    required this.topPadding,
    required this.screenWidth,
    required this.onFavoritePressed,
    required this.onSharePressed,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double collapseRatio = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final bool isCollapsed = collapseRatio >= 0.95;

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: context.colors.surfaceContainer,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppRadius.xlSize),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: ClipRRect(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(AppRadius.xlSize),
            ),
            child: Opacity(
              opacity: (1.0 - collapseRatio).clamp(0.0, 1.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: media.coverImage,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const ShimmerPlaceholder(),
                    errorWidget: (context, url, error) => const ShimmerPlaceholder(),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      color: context.colors.surfaceContainer.withValues(alpha: 0.25),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          context.colors.surfaceContainer.withValues(alpha: 0.5),
                          context.colors.surfaceContainer,
                        ],
                        stops: const [0.3, 0.5, 0.7],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: maxExtent,
                    child: Transform.translate(
                      offset: Offset(0, -shrinkOffset),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(25.0, topPadding + 80.0, 25.0, 48.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 175,
                              height: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppRadius.lgSize),
                                boxShadow: [
                                  BoxShadow(
                                    color: context.colors.surface.withValues(alpha: 0.4),
                                    blurRadius: 10.0,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(AppRadius.lgSize),
                                child: CachedNetworkImage(
                                  imageUrl: media.coverImage,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const ShimmerPlaceholder(),
                                  errorWidget: (context, url, error) => const ShimmerPlaceholder(),
                                ),
                              ),
                            ),
                            verticalSpaceLg,
                            Text(
                              media.title,
                              style: context.textTheme.displayMedium?.copyWith(
                                height: 1.0,
                              ),
                            ),
                            verticalSpaceSm,
                            Text(
                              media.format,
                              style: context.textTheme.headlineSmall?.copyWith(
                                color: context.colors.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: topPadding,
          left: 0,
          right: 0,
          height: kToolbarHeight,
          child: Row(
            children: [
              horizontalSpaceSm,
              _buildCircleIconButton(
                context,
                icon: Icons.arrow_back,
                onPressed: () => Navigator.of(context).pop(),
              ),
              horizontalSpaceSm,
              Expanded(
                child: AnimatedOpacity(
                  opacity: isCollapsed ? 1.0 : 0.0, 
                  duration: const Duration(milliseconds: 150),
                  child: Text(
                    media.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.headlineLarge,
                  ),
                ),
              ),
              horizontalSpaceSm,
              _buildCircleIconButton(
                context,
                icon: Icons.favorite_border,
                onPressed: onFavoritePressed,
              ),
              horizontalSpaceSm,
              _buildCircleIconButton(
                context, 
                icon: Icons.share_outlined,
                onPressed: onSharePressed,
              ),
              horizontalSpaceSm,
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: context.colors.surfaceContainer.withValues(alpha: collapseRatio),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppRadius.xlSize),
              ),
            ),
            child: tabBar,
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent {
    const double fixedHeight = 450.0;
    // subtract 50 from screenWidth for horizontal padding
    final double textWidth = screenWidth - 50.0;

    final TextPainter titlePainter = TextPainter(
      text: TextSpan(
        text: media.title,
        style: textTheme.displayMedium?.copyWith(height: 1.0),
      ),
      textDirection: TextDirection.ltr,
    );

    titlePainter.layout(maxWidth: textWidth);
    // calculate the total extent for the layout boundary
    return topPadding + fixedHeight + titlePainter.height;
  }

  @override
  double get minExtent => topPadding + kToolbarHeight + 48.0;

  @override
  bool shouldRebuild(covariant MediaHeaderDelegate oldDelegate) {
    return oldDelegate.media != media;
  }
}

Widget _buildCircleIconButton(
  BuildContext context, {
  required IconData icon,
  required VoidCallback onPressed,
}) {
  return Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: context.colors.surfaceContainer.withValues(alpha: 0.5),
      shape: BoxShape.circle,
    ),
    child: IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        icon,
        color: context.colors.onSurface,
        size: 20,
      ),
      onPressed: onPressed,
    ),
  );
}
