import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:aniyoka/ui/views/home/home_view.dart';
import 'package:aniyoka/ui/views/explore/explore_view.dart';
import 'package:aniyoka/ui/views/profile/profile_view.dart';
import 'package:aniyoka/ui/views/watchlist/watchlist_view.dart';
import 'package:aniyoka/ui/views/bookmarks/bookmarks_view.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'main_viewmodel.dart';

class MainView extends StackedView<MainViewModel> {
  const MainView({super.key});

  @override
  Widget builder(BuildContext context, MainViewModel viewModel, Widget? child) {
    return Scaffold(
      body: switch (viewModel.currentPage) {
        0 => const HomeView(),
        1 => const ExploreView(),
        2 => WatchlistView(
            onNavigateToExplore: () => viewModel.setPage(1),
          ),
        3 => BookmarksView(
            onNavigateToExplore: () => viewModel.setPage(1),
          ),
        4 => const ProfileView(),
        int() => throw UnimplementedError(),
      },
      bottomNavigationBar: SafeArea(
        bottom: false,
        child: NavigationBar(
          // bottom nav bar styling
          indicatorColor: kcDarkPink,
          backgroundColor: kcSurfaceColor,
          indicatorShape: const NarrowPillIndicator(),
          // bottom nav bar directory
          selectedIndex: viewModel.currentPage,
          onDestinationSelected: viewModel.setPage,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: kcPrimaryPink),
              label: 'Home',
            ),
            NavigationDestination(
              icon: const Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore, color: kcPrimaryPink),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: const Icon(Icons.tv_outlined),
              selectedIcon: Icon(Icons.connected_tv, color: kcPrimaryPink),
              label: 'Watch List',
            ),
            NavigationDestination(
              icon: const Icon(Icons.bookmark_outline),
              selectedIcon: Icon(Icons.bookmark, color: kcPrimaryPink),
              label: 'Bookmarks',
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: kcPrimaryPink),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  @override
  MainViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      MainViewModel();
}

// custom pill that is smaller than default — unchanged, no color usage
class NarrowPillIndicator extends ShapeBorder {
  final double customWidth;
  const NarrowPillIndicator({this.customWidth = 46.0});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final double center = rect.left + (rect.width / 2);
    final Rect narrowedRect = Rect.fromCenter(
      center: Offset(center, rect.center.dy),
      width: customWidth,
      height: rect.height,
    );

    return Path()
      ..addRRect(RRect.fromRectAndRadius(
          narrowedRect, Radius.circular(rect.height / 2)));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
