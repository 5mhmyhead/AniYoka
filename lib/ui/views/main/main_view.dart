import 'package:aniyoka/ui/views/home/home_view.dart';
import 'package:aniyoka/ui/views/explore/explore_view.dart';
import 'package:aniyoka/ui/views/profile/profile_view.dart';
import 'package:aniyoka/ui/views/watchlist/watchlist_view.dart';
import 'package:aniyoka/ui/views/bookmarks/bookmarks_view.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'main_viewmodel.dart';

class MainView extends StackedView<MainViewModel> {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, MainViewModel viewModel, Widget? child) {
    return Scaffold(
      body: switch (viewModel.currentPage) {
        0 => const HomeView(),
        1 => const ExploreView(),
        2 => const WatchlistView(),
        3 => const BookmarksView(),
        4 => const ProfileView(),
        int() => throw UnimplementedError(),
      },
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.pinkAccent,
          unselectedItemColor: Colors.grey, 
          currentIndex: viewModel.currentPage,
          onTap: viewModel.setPage,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
            BottomNavigationBarItem(icon: Icon(Icons.tv), label: "Watchlist"),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Bookmarks"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
          ],
        ),
      ),
    );
  }

  @override
  MainViewModel viewModelBuilder(BuildContext context,) => MainViewModel();
}
