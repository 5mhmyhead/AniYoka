import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:aniyoka/ui/views/home/home_view.dart';
import 'package:aniyoka/ui/views/explore/explore_view.dart';
import 'package:aniyoka/ui/views/library/library_view.dart';
import 'package:aniyoka/ui/views/forum/forum_view.dart';
import 'package:aniyoka/ui/views/profile/profile_view.dart';

import 'main_viewmodel.dart';

class MainView extends StackedView<MainViewModel> {
  const MainView({super.key});

  @override
  Widget builder(BuildContext context, MainViewModel viewModel, Widget? child) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      backgroundColor: colorScheme.surface,
      body: switch (viewModel.currentPage) {
        0 => const HomeView(),
        1 => const ExploreView(),
        2 => const LibraryView(),
        3 => const ForumView(),
        4 => const ProfileView(),
        int() => throw UnimplementedError(),
      },
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
        child: NavigationBar(
          // bottom nav bar styling
          indicatorColor: colorScheme.surfaceContainerHigh,
          backgroundColor: colorScheme.surfaceContainer,
          indicatorShape: const CustomPillIndicator(),
          // selects destination based on directory
          selectedIndex: viewModel.currentPage,
          onDestinationSelected: viewModel.setPage,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.video_library_outlined),
              selectedIcon: Icon(Icons.video_library),
              label: 'Library',
            ),
            NavigationDestination(
                icon: Icon(Icons.forum_outlined),
                selectedIcon: Icon(Icons.forum),
                label: 'Forum'),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  @override
  MainViewModel viewModelBuilder(BuildContext context) => MainViewModel();
}

// simple custom pill indicator smaller than the original
class CustomPillIndicator extends ShapeBorder {
  final double customWidth;
  const CustomPillIndicator({this.customWidth = 46.0});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final double center = rect.left + (rect.width / 2);
    final Rect customRect = Rect.fromCenter(
      center: Offset(center, rect.center.dy),
      width: customWidth,
      height: rect.height,
    );

    final path = Path();
    path.addRRect(
        RRect.fromRectAndRadius(customRect, Radius.circular(rect.height / 2)));
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
