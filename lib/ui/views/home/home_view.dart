import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:aniyoka/utils/season_helper.dart';
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
              body: SafeArea(
                child: viewModel.isBusy
                    ? const Center(child: CircularProgressIndicator(color: kcPrimaryPink))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: kcSurfaceColor,
                            child: _buildHeader(),
                          ),
                          Expanded(
                            child: _buildTabContent(viewModel),
                          ),
                        ],
                      ),
              ),
            ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Text(
            'Home Page',
            style: GoogleFonts.nunito(
              color: kcTertiaryPink,
              fontSize: 42,
              fontWeight: FontWeight.w700,
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
      // label styling
      labelColor: kcPrimaryPink,
      unselectedLabelColor: kcLightGrey,
      // indicator styling
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
        Tab(text: 'Activity'),
      ],
    );
  }

  // tab content switcher
  Widget _buildTabContent(HomeViewModel viewModel) {
    return TabBarView(
      children: [
        _buildDiscoverTab(viewModel),
        const Center(
          child: Text(
            'Genres',
            style: TextStyle(color: kcOffWhite),
          ),
        ),
        const Center(
          child: Text(
            'Activity',
            style: TextStyle(color: kcOffWhite),
          ),
        ),
      ],
    );
  }

  Widget _buildDiscoverTab(HomeViewModel viewModel) {
    final sections = [
      (SeasonHelper.currentSeasonLabel, viewModel.thisSeason),
      ('Next Season', viewModel.nextSeason),
      ('Newly Added', viewModel.newlyAdded),
      ('Airing Soon', viewModel.airingSoon),
    ];

    return ListView(
      children: [
        const SizedBox(height: 20),
        _buildSectionHeader('Popular Now'),
        const SizedBox(height: 10),
        _buildPopularSection(viewModel.popularAnime),
        const SizedBox(height: 10),
        ...sections.map((section) => _buildSection(section.$1, section.$2)),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSection(String title, List<dynamic> animeList) {
    return Column(
      children: [
        _buildSectionHeader(title),
        const SizedBox(height: 12),
        _buildAnimeRow(animeList),
      ],
    );
  }

  Widget _buildPopularSection(List<dynamic> animeList) {
  if (animeList.isEmpty) {
    return const SizedBox(
      height: 220,
      child: Center(
        child: Text('No anime found', style: TextStyle(color: kcLightGrey)),
      ),
    );
  }

  final PageController controller = PageController(viewportFraction: 0.88);

  return SizedBox(
    height: 220,
    child: PageView.builder(
      controller: controller,
      itemCount: animeList.length,
      itemBuilder: (context, index) {
        final anime = animeList[index];
        final title = anime['title']['english'] ?? anime['title']['romaji'] ?? '';
        final format = anime['format'] ?? '';
        final year = anime['startDate']?['year']?.toString() ?? '';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // background cover image
                Image.network(
                  anime['coverImage']['large'] ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(color: kcSurfaceColor),
                ),
                // gradient overlay so text is readable
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black87,
                      ],
                      stops: [0.2, 1.0],
                    ),
                  ),
                ),
                // title and subtitle
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          color: kcOffWhite,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        year.isNotEmpty ? '$format • $year' : format,
                        style: GoogleFonts.nunito(
                          color: kcSecondaryPink,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

  // section header with arrow
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.nunito(
              color: kcTertiaryPink,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Icon(
            Icons.arrow_forward, 
            color: kcTertiaryPink, 
            size: 24
          ),
        ],
      ),
    );
  }

  // horizontal anime card row
  Widget _buildAnimeRow(List<dynamic> animeList) {
    if (animeList.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(
          child: Text(
            'No anime found',
            style: TextStyle(color: kcLightGrey),
          ),
        ),
      );
    }

    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: animeList.length,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final anime = animeList[index];
          final title = anime['title']['english'] ?? anime['title']['romaji'] ?? '';
          final format = anime['format'] ?? anime['status'] ?? '';
          final year = anime['startDate']?['year']?.toString() ?? '';

          return SizedBox(
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    anime['coverImage']['large'] ?? '',
                    width: 125,
                    height: 175,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 125,
                      height: 175,
                      decoration: BoxDecoration(
                        color: kcSurfaceColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: kcOffWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  year.isNotEmpty ? '$format • $year' : format,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: kcLightGrey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void onViewModelReady(HomeViewModel viewModel) => viewModel.loadHomeData();

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}
