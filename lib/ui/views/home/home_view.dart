import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:aniyoka/ui/views/home/tabs/calendar_tab.dart';
import 'package:aniyoka/ui/views/home/tabs/discover_tab.dart';
import 'package:aniyoka/ui/views/home/tabs/feed_tab.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: DefaultTabController(
        length: 3, 
        child: Scaffold(
          backgroundColor: colorScheme.surface,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              // top app bar that shrinks when scrolling down
              SliverAppBar(
                pinned: true,
                expandedHeight: 180.0,
                backgroundColor: colorScheme.surfaceContainer,
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.0)),
                ),
                elevation: 0,
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.search, 
                      color: colorScheme.onSurface
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.notifications_none_outlined, 
                      color: colorScheme.onSurface
                    ),
                    onPressed: () {},
                  ),
                  horizontalSpaceSmall,
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(color: colorScheme.surface),
                  titlePadding: const EdgeInsets.only(left: 25.0, bottom: 60.0),
                  expandedTitleScale: 2,
                  title: Text(
                    'Home',
                    style: GoogleFonts.nunito(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48.0),
                  child: const TabBar(
                    isScrollable: false,
                    tabs: [
                      Tab(text: 'Discover'),
                      Tab(text: 'Calendar'),
                      Tab(text: 'Your Feed'),
                    ],
                  ),
                ),
              ),
            ], 
            body: TabBarView(
              children: [
                DiscoverTab(),
                CalendarTab(),
                FeedTab(),
              ]
            ),
          ),
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}