import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:aniyoka/ui/views/home/tabs/calendar/calendar_tab_view.dart';
import 'package:aniyoka/ui/views/home/tabs/discover/discover_tab_view.dart';
import 'package:aniyoka/ui/views/home/tabs/feed/feed_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {

    return Scaffold(
      body: DefaultTabController(
        length: 3, 
        child: Scaffold(
          backgroundColor: context.colors.surface,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              // top app bar that shrinks when scrolling down
              SliverAppBar(
                pinned: true,
                expandedHeight: 180.0,
                backgroundColor: context.colors.surfaceContainer,
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
                      color: context.colors.onSurface
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.notifications_none_outlined, 
                      color: context.colors.onSurface
                    ),
                    onPressed: () {},
                  ),
                  horizontalSpaceSm,
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(color: context.colors.surface),
                  titlePadding: const EdgeInsets.only(left: 25.0, bottom: 60.0),
                  expandedTitleScale: 1.5,
                  title: Text(
                    'Home',
                    style: context.textTheme.headlineLarge?.copyWith(
                      color: context.colors.onSurface,
                    )
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