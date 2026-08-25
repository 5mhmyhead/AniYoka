import 'dart:ui';
import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:aniyoka/ui/widgets/custom_slide_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tilt/flutter_tilt.dart';

class ImageViewerView extends StatefulWidget {
  final String coverImage;
  final String? bannerImage;

  const ImageViewerView({
    super.key,
    required this.coverImage,
    this.bannerImage,
  });

  static Future<void> show(
    BuildContext context, {
    required String coverImage,
    String? bannerImage,
  }) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 100),
        reverseTransitionDuration: const Duration(milliseconds: 100),
        pageBuilder: (_, __, ___) => ImageViewerView(
          coverImage: coverImage,
          bannerImage: bannerImage,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
              reverseCurve: Curves.easeIn,
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  State<ImageViewerView> createState() => _ImageViewerViewState();
}

class _ImageViewerViewState extends State<ImageViewerView> {
  late final PageController _pageController;

  int _currentIndex = 0;
  double _pageDelta = 0.0;

  List<String> get _images => [
        widget.coverImage,
        if (widget.bannerImage != null) widget.bannerImage!,
      ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      final page = _pageController.page ?? 0;
      setState(() {
        _currentIndex = page.floor();
        _pageDelta = page - page.floor();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = _images;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.4),
                ),
              ),
            ),
          ),
          PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Padding(
                    padding: kHorizontalPadding,
                    child: Tilt(
                      tiltConfig: const TiltConfig(angle: 15),
                      child: TiltBaseContainer(
                        lightConfig: const LightConfig(disable: true),
                        shadowConfig: const ShadowBaseConfig(disable: true),
                        borderRadius: BorderRadius.circular(AppRadius.lgSize),
                        child: ClipRRect(
                          child: CachedNetworkImage(
                            imageUrl: images[index],
                            fit: BoxFit.contain,
                            placeholder: (_, __) =>
                                const CircularProgressIndicator(),
                            errorWidget: (_, __, ___) =>
                                const CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            height: kToolbarHeight,
            child: Row(
              children: [
                horizontalSpaceSm,
                _buildIconButton(
                  context,
                  icon: Icons.arrow_back,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Spacer(),
                _buildIconButton(
                  context,
                  icon: Icons.file_download_outlined,
                  onPressed: () => showUnimplementedSnackBar(context), // TODO: add download
                ),
                horizontalSpaceSm,
                _buildIconButton(
                  context,
                  icon: Icons.share_outlined,
                  onPressed: () => showUnimplementedSnackBar(context), // TODO: add share
                ),
                horizontalSpaceSm,
              ],
            ),
          ),
          if (images.length > 1)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 16.0,
              left: 0,
              right: 0,
              child: CustomSlideIndicator(
                activeColor: context.colors.primary,
                inactiveColor: context.colors.surfaceContainer,
                activeDotWidth: 20.0,
              ).build(_currentIndex, _pageDelta, images.length),
            ),
        ],
      ),
    );
  }
}

Widget _buildIconButton(
  BuildContext context, {
  required IconData icon,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: 40,
    height: 40,
    child: IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        icon,
        color: context.colors.onSurface,
        size: 22,
      ),
      onPressed: onPressed,
    ),
  );
}
