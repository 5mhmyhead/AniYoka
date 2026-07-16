import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:aniyoka/ui/widgets/discover_tab.dart';
import 'package:aniyoka/ui/widgets/genres_tab.dart';
import 'package:aniyoka/ui/widgets/watching_tab.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kcSurfaceColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: kcBackgroundColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: kcSurfaceColor,
                child: _buildHeader(),
              ),
              Expanded(
                child: _buildTabContent(viewModel, context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              'Home Page',
              style: GoogleFonts.nunito(
                color: kcPrimaryPink,
                fontSize: 42,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        _buildTabBar(),
      ],
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      isScrollable: false,
      labelColor: kcPrimaryPink,
      unselectedLabelColor: kcLightGrey,
      indicatorColor: kcPrimaryPink,
      indicatorWeight: 2,
      dividerColor: kcLightGrey,
      labelStyle: GoogleFonts.nunito(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.nunito(
        fontSize: 15,
      ),
      tabs: const [
        Tab(text: 'Discover'),
        Tab(text: 'Genres'),
        Tab(text: 'Watching'),
      ],
    );
  }

  // tab content switcher
  Widget _buildTabContent(HomeViewModel viewModel, BuildContext context) {
    if (viewModel.isBusy) {
      return const Center(
        child: CircularProgressIndicator(color: kcPrimaryPink),
      );
    }

    return TabBarView(
      children: [
        DiscoverTab(viewModel: viewModel),
        const GenresTab(),
        const WatchingTab(),
      ],
    );
  }

  @override
  void onViewModelReady(HomeViewModel viewModel) => viewModel.loadHomeData();

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}