import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:aniyoka/ui/views/anime_info/anime_info_view.dart';
import 'package:aniyoka/ui/widgets/search_filter_header.dart';
import 'package:aniyoka/ui/widgets/watchlist_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'bookmarks_viewmodel.dart';

class BookmarksView extends StackedView<BookmarksViewModel> {
  const BookmarksView({super.key, this.onNavigateToExplore});
  final VoidCallback? onNavigateToExplore;

  @override
  Widget builder(
      BuildContext context, BookmarksViewModel viewModel, Widget? child) {
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
                title: 'Bookmarks',
                sortOptions: BookmarkSort.values.map((s) => s.label).toList(),
                selectedSort: viewModel.sort.label,
                selectedSortAscending: viewModel.sortAscending,
                onSortSelected: (label, ascending) {
                  final sort =
                      BookmarkSort.values.firstWhere((s) => s.label == label);
                  viewModel.setSort(sort, ascending: ascending);
                },
                onSearchChanged: viewModel.setSearch,
                onSearchCleared: viewModel.clearSearch,
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
        tabs: categories
            .map((c) => Tab(
                  child: FittedBox(fit: BoxFit.scaleDown, child: Text(c)),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildTabContent(List<String> categories, BookmarksViewModel viewModel,
      BuildContext context) {
    return TabBarView(
      children: categories
          .map((c) =>
              _buildGrid(viewModel.bookmarksForCategory(c), viewModel, context))
          .toList(),
    );
  }

  Widget _buildGrid(List<Map<String, dynamic>> list,
      BookmarksViewModel viewModel, BuildContext context) {
    if (!viewModel.hasLoaded) {
      return Center(
        child: CircularProgressIndicator(color: kcPrimaryPink),
      );
    }

    if (list.isEmpty) {
      return RefreshIndicator(
        color: kcPrimaryPink,
        backgroundColor: kcSurfaceColor,
        onRefresh: viewModel.loadBookmarks,
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
                      'bruh',
                      style: GoogleFonts.nunito(
                        color: kcSecondaryPink,
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Hmmm, you don’t seem to have any bookmarks.',
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
                          'Search for an anime to save!',
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
      onRefresh: viewModel.loadBookmarks,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.50,
        ),
        itemCount: list.length,
        itemBuilder: (context, index) =>
            _buildCard(list[index], viewModel, context),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> anime, BookmarksViewModel viewModel,
      BuildContext context) {
    final title = anime['title']['english'] ?? anime['title']['romaji'] ?? '';
    final format = anime['format'] ?? '';
    final year = anime['startDate']?['year']?.toString() ?? '';

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => AnimeInfoView(animeId: anime['id']),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            transitionsBuilder: (_, __, ___, child) => child,
          ),
        );
        // reload bookmarks when user comes back
        viewModel.loadBookmarks();
      },
      onLongPress: () =>
          showWatchlistSheetForAnime(context, animeId: anime['id']),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 250,
            width: 180,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: anime['coverImage']['large'] ?? '',
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: kcSurfaceColor),
                errorWidget: (_, __, ___) => Container(color: kcSurfaceColor),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: kcOffWhite,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            year.isNotEmpty ? '$format • $year' : format,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: kcLightGrey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onViewModelReady(BookmarksViewModel viewModel) =>
      viewModel.loadBookmarks();

  @override
  BookmarksViewModel viewModelBuilder(BuildContext context) =>
      BookmarksViewModel();
}
