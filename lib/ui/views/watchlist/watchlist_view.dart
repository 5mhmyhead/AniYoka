import 'package:aniyoka/services/watchlist_service.dart';
import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:aniyoka/ui/views/anime_info/anime_info_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'watchlist_viewmodel.dart';

class WatchlistView extends StackedView<WatchlistViewModel> {
  const WatchlistView({super.key, this.onNavigateToExplore});
  final VoidCallback? onNavigateToExplore;

  @override
  void onViewModelReady(WatchlistViewModel viewModel) => viewModel.loadWatchlist();

  @override
  Widget builder(BuildContext context, WatchlistViewModel viewModel, Widget? child) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kcSurfaceColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: DefaultTabController(
        length: 4,
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
              'Watch List',
              style: GoogleFonts.nunito(
                color: kcPrimaryPink,
                fontSize: 42,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: kcPrimaryPink,
          unselectedLabelColor: kcLightGrey,
          indicatorColor: kcPrimaryPink,
          indicatorWeight: 2,
          dividerColor: kcLightGrey,
          labelStyle: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.nunito(fontSize: 15),
          tabs: const [
            Tab(text: 'All Anime'),
            Tab(text: 'Completed'),
            Tab(text: 'Rewatching'),
            Tab(text: 'Favourite'),
          ],
        ),
      ],
    );
  }

  Widget _buildTabContent(WatchlistViewModel viewModel, BuildContext context) {
    return TabBarView(
      children: [
        _buildList(viewModel.allAnime, viewModel, context),
        _buildList(viewModel.completed, viewModel, context),
        _buildList(viewModel.rewatching, viewModel, context),
        _buildList(viewModel.favourites, viewModel, context),
      ],
    );
  }

  Widget _buildList(
    List<WatchlistEntry> entries,
    WatchlistViewModel viewModel,
    BuildContext context,
  ) {
    if (!viewModel.hasLoaded) return const SizedBox.shrink();

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
                        'Hmmm, you don’t seem to have anything on your watchlist.',
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
        separatorBuilder: (_, __) => const Divider(color: kcSurfaceColor, height: 1),
        itemBuilder: (context, index) => _buildEntry(entries[index], viewModel, context),
      ),
    );
  }

  Widget _buildEntry(
    WatchlistEntry entry,
    WatchlistViewModel viewModel,
    BuildContext context,
  ) {
    final title = entry.animeData['title']?['english'] ??
        entry.animeData['title']?['romaji'] ?? '';
    final imageUrl = entry.animeData['coverImage']?['large'] ?? '';
    final total = entry.totalEpisodes;
    final progress = total != null && total > 0
        ? entry.episodesWatched / total
        : 0.0;
    final statusLabel = entry.status[0] + entry.status.substring(1).toLowerCase();

    return GestureDetector(
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
        viewModel.loadWatchlist(); // reload after returning
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // cover image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 80,
                height: 110,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(width: 80, height: 110, color: kcSurfaceColor),
                errorWidget: (_, __, ___) => Container(width: 80, height: 110, color: kcSurfaceColor),
              ),
            ),
            const SizedBox(width: 16),
            // info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: kcOffWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Status: $statusLabel',
                    style: GoogleFonts.nunito(
                      color: kcLightGrey,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // episode counter row
                  Row(
                    children: [
                      // minus
                      GestureDetector(
                        onTap: () => viewModel.decrementEpisode(entry.id),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: kcPrimaryPink,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(Icons.remove, color: kcOffWhite, size: 18),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Ep ${entry.episodesWatched}${total != null ? ' / $total' : ''}',
                        style: GoogleFonts.nunito(
                          color: kcOffWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // plus
                      GestureDetector(
                        onTap: () => viewModel.incrementEpisode(entry.id),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: kcPrimaryPink,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(Icons.add, color: kcOffWhite, size: 18),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  // progress bar
                  if (total != null && total > 0) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: kcBackgroundColor,
                        color: kcPrimaryPink,
                        minHeight: 4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  WatchlistViewModel viewModelBuilder(BuildContext context) => WatchlistViewModel();
}