import 'package:aniyoka/services/watchlist_service.dart';
import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:aniyoka/ui/views/anime_info/anime_info_view.dart';
import 'package:aniyoka/ui/widgets/search_filter_header.dart';
import 'package:aniyoka/ui/widgets/watchlist_entry_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'watchlist_viewmodel.dart';

class WatchlistView extends StackedView<WatchlistViewModel> {
  const WatchlistView({super.key, this.onNavigateToExplore});
  final VoidCallback? onNavigateToExplore;

  @override
  void onViewModelReady(WatchlistViewModel viewModel) =>
      viewModel.loadWatchlist();

  @override
  Widget builder(
      BuildContext context, WatchlistViewModel viewModel, Widget? child) {
    final categories = viewModel.categories;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kcSurfaceColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: DefaultTabController(
        length: categories.length,
        child: Scaffold(
          backgroundColor: kcBackgroundColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchFilterHeader(
                title: 'Watch List',
                sortOptions: WatchlistSort.values.map((s) => s.label).toList(),
                selectedSort: viewModel.sort.label,
                selectedSortAscending: viewModel.sortAscending,
                onSortSelected: (label, ascending) {
                  final sort =
                      WatchlistSort.values.firstWhere((s) => s.label == label);
                  viewModel.setSort(sort, ascending: ascending);
                },
                onSearchChanged: viewModel.setSearch,
                onSearchCleared: viewModel.clearSearch,
                statusOptions: WatchlistViewModel.statusOptions,
                selectedStatuses: viewModel.selectedStatuses,
                onStatusesChanged: viewModel.setStatuses,
              ),
              _buildTabBar(categories),
              Expanded(child: _buildTabContent(categories, viewModel, context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(List<String> categories) {
    return Container(
      color: kcSurfaceColor,
      child: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: kcPrimaryPink,
        unselectedLabelColor: kcLightGrey,
        indicatorColor: kcPrimaryPink,
        indicatorWeight: 2,
        dividerColor: kcLightGrey,
        labelStyle:
            GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.nunito(fontSize: 15),
        tabs: categories.map((c) => Tab(text: c)).toList(),
      ),
    );
  }

  Widget _buildTabContent(List<String> categories, WatchlistViewModel viewModel,
      BuildContext context) {
    return TabBarView(
      children: categories
          .map((c) =>
              _buildList(viewModel.entriesForCategory(c), viewModel, context))
          .toList(),
    );
  }

  Widget _buildList(
    List<WatchlistEntry> entries,
    WatchlistViewModel viewModel,
    BuildContext context,
  ) {
    if (!viewModel.hasLoaded) {
      return Center(
        child: CircularProgressIndicator(color: kcPrimaryPink),
      );
    }

    if (entries.isEmpty) {
      return RefreshIndicator(
        color: kcPrimaryPink,
        backgroundColor: kcSurfaceColor,
        onRefresh: viewModel.loadWatchlist,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '(╥﹏╥)',
                      style: GoogleFonts.nunito(
                        color: kcSecondaryPink,
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Hmmm, there seems to be nothing here.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          color: kcLightGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: onNavigateToExplore,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        decoration: BoxDecoration(
                          color: kcSurfaceColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Search for an anime to watch!',
                          style: GoogleFonts.nunito(
                            color: kcLightGrey,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: kcPrimaryPink,
      backgroundColor: kcSurfaceColor,
      onRefresh: viewModel.loadWatchlist,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: entries.length,
        separatorBuilder: (_, __) =>
            const Divider(color: kcSurfaceColor, height: 1),
        itemBuilder: (context, index) {
          final entry = entries[index];
          return WatchlistEntryTile(
            entry: entry,
            onTap: () async {
              await Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => AnimeInfoView(animeId: entry.id),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                  transitionsBuilder: (_, __, ___, child) => child,
                ),
              );
              viewModel.loadWatchlist();
            },
            onDecrement: () => viewModel.decrementEpisode(entry.id),
            onIncrement: () => viewModel.incrementEpisode(entry.id),
          );
        },
      ),
    );
  }

  @override
  WatchlistViewModel viewModelBuilder(BuildContext context) =>
      WatchlistViewModel();
}
