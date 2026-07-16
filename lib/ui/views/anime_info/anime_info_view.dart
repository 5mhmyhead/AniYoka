import 'package:aniyoka/ui/widgets/anime_card_row.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'anime_info_viewmodel.dart';

class AnimeInfoView extends StackedView<AnimeInfoViewModel> {
  final int animeId;
  const AnimeInfoView({super.key, required this.animeId});

  @override
  Widget builder(
      BuildContext context, AnimeInfoViewModel viewModel, Widget? child) {
    if (viewModel.isBusy) {
      return Scaffold(
        backgroundColor: kcBackgroundColor,
        body: Center(child: CircularProgressIndicator(color: kcPrimaryPink)),
      );
    }

    final anime = viewModel.anime;
    if (anime == null) return const SizedBox();

    final title = anime['title']['english'] ?? anime['title']['romaji'] ?? '';
    final format = anime['format'] ?? '';

    final seasonYear = anime['seasonYear']?.toString() ?? '';
    final season = anime['season'] != null
        ? '${anime['season'][0]}${anime['season'].substring(1).toLowerCase()}'
        : '';

    final status = viewModel.formatEnum(anime['status']);

    final subtitle = '$format • $season $seasonYear • $status';

    final meanScore = anime['meanScore'];
    final episodes = anime['episodes'];
    final description = viewModel.cleanDescription(anime['description'] ?? '');
    final genres = anime['genres'] as List? ?? [];
    final coverImage = anime['coverImage']['extraLarge'] ?? '';

    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // top gradient area with back + bookmark
          SliverToBoxAdapter(
            child: _buildTopSection(
                context, viewModel, coverImage, title, subtitle),
          ),
          // stats row
          SliverToBoxAdapter(
            child: _buildStatsRow(viewModel, meanScore, viewModel.ranked,
                viewModel.popularity, episodes),
          ),
          // synopsis
          SliverToBoxAdapter(
            child: _buildSynopsis(viewModel, description, context),
          ),
          SliverToBoxAdapter(
            child: _buildSectionHeader('Genres and Tags'),
          ),
          SliverToBoxAdapter(
            child: _buildGenres(genres),
          ),
          SliverToBoxAdapter(
            child: _buildTags(viewModel),
          ),
          SliverToBoxAdapter(
            child: _buildSectionHeader('Information'),
          ),
          SliverToBoxAdapter(
            child: _buildInfoSection(viewModel),
          ),
          if (viewModel.relatedAnime.isNotEmpty) ...[
            SliverToBoxAdapter(child: _buildSectionHeader('Related')),
            SliverToBoxAdapter(
              child: AnimeCardRow(
                animeList: viewModel.relatedAnime,
                onAnimeTap: (id) => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => AnimeInfoView(animeId: id),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                    transitionsBuilder: (_, __, ___, child) => child,
                  ),
                ),
              ),
            ),
          ],
          if (viewModel.recommendations.isNotEmpty) ...[
            SliverToBoxAdapter(child: _buildSectionHeader('Recommendations')),
            SliverToBoxAdapter(
              child: AnimeCardRow(
                animeList: viewModel.recommendations,
                onAnimeTap: (id) => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => AnimeInfoView(animeId: id),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                    transitionsBuilder: (_, __, ___, child) => child,
                  ),
                ),
              ),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showWatchlistSheet(context, viewModel),
        backgroundColor: kcPrimaryPink,
        icon: Icon(
          viewModel.isInWatchlist ? Icons.edit : Icons.add,
          color: kcOffWhite,
          size: 28,
        ),
        label: Text(
          viewModel.isInWatchlist ? 'Edit' : 'Add',
          style: GoogleFonts.nunito(
            color: kcOffWhite,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context, AnimeInfoViewModel viewModel,
      String coverImage, String title, String subtitle) {
    final Color gradientColor = viewModel.adjustedDominantColor;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [gradientColor, kcBackgroundColor],
          stops: const [0.0, 0.6],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // back and bookmark row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: kcOffWhite, size: 32),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(
                    icon: Icon(
                      viewModel.isBookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_outline,
                      color: kcPrimaryPink,
                      size: 32,
                    ),
                    onPressed: viewModel.toggleBookmark,
                  ),
                ],
              ),
            ),
            // cover image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                coverImage,
                width: 180,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 180,
                  height: 250,
                  color: kcSurfaceColor,
                ),
              ),
            ),
            const SizedBox(height: 15),
            // anime title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: kcPrimaryPink,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // subtitle
            Text(
              subtitle,
              style: GoogleFonts.nunito(
                color: kcLightGrey,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(AnimeInfoViewModel viewModel, int? meanScore,
      int? ranked, int? popularity, int? episodes) {
    final pills = [
      if (viewModel.airingIn != null) (viewModel.airingIn!, 'airing'),
      if (ranked != null) ('#$ranked', 'ranked'),
      ('${meanScore ?? '?'}%', 'mean score'),
      (viewModel.formatPopularity(popularity), 'popularity'),
      ('${episodes ?? '?'}', 'episodes'),
      (viewModel.formatPopularity(viewModel.anime?['favourites']), 'favorites'),
    ];

    return SizedBox(
      height: 70,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: pills.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return _buildStatPill(pills[index].$1, pills[index].$2);
        },
      ),
    );
  }

  Widget _buildStatPill(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: kcDarkPink,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: GoogleFonts.nunito(
              color: kcPrimaryPink,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.nunito(
              color: kcLightGrey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSynopsis(
      AnimeInfoViewModel viewModel, String description, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Synopsis'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Text(
            description,
            textAlign: TextAlign.justify,
            maxLines: viewModel.isDescriptionExpanded ? null : 5,
            overflow:
                viewModel.isDescriptionExpanded ? null : TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: kcOffWhite,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Row(
            children: [
              const Expanded(
                child: SizedBox.shrink(),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: viewModel.toggleDescription,
                  child: Icon(
                    viewModel.isDescriptionExpanded
                        ? Icons.arrow_circle_up_outlined
                        : Icons.arrow_circle_down_outlined,
                    color: kcTertiaryPink,
                    size: 24,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: viewModel.copyDescription,
                    child: const Icon(
                      Icons.copy,
                      color: kcTertiaryPink,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildGenres(List<dynamic> genres) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: genres.map((genre) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: kcDarkPink,
              border: Border.all(color: kcPrimaryPink),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              genre,
              style: GoogleFonts.nunito(
                color: kcPrimaryPink,
                fontSize: 13,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTags(AnimeInfoViewModel viewModel) {
    final hasSpoilers = viewModel.spoilerTags.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: viewModel.visibleTags.map((tag) {
              final isSpoiler = tag['isMediaSpoiler'] as bool;
              final rank = tag['rank'] as int;

              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSpoiler
                      ? kcPrimaryPink.withValues(alpha: 0.15)
                      : kcSurfaceColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSpoiler) ...[
                      const Icon(Icons.warning_amber_rounded,
                          color: kcPrimaryPink, size: 12),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      tag['name'],
                      style: GoogleFonts.nunito(
                        color: isSpoiler ? kcPrimaryPink : kcTertiaryPink,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$rank%',
                      style: GoogleFonts.nunito(
                        color: kcLightGrey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          if (hasSpoilers) SizedBox(height: 24),
          // header with spoiler toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (hasSpoilers)
                GestureDetector(
                  onTap: viewModel.toggleSpoilerTags,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: viewModel.showSpoilerTags
                          ? kcPrimaryPink
                          : kcSurfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: kcPrimaryPink),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          viewModel.showSpoilerTags
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: viewModel.showSpoilerTags
                              ? kcOffWhite
                              : kcPrimaryPink,
                          size: 15,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          viewModel.showSpoilerTags
                              ? 'Hide spoilers'
                              : 'Show spoilers',
                          style: GoogleFonts.nunito(
                            color: viewModel.showSpoilerTags
                                ? kcOffWhite
                                : kcPrimaryPink,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // spoiler count hint when hidden
              if (!viewModel.showSpoilerTags &&
                  viewModel.spoilerTags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${viewModel.spoilerTags.length} spoiler tag${viewModel.spoilerTags.length > 1 ? 's' : ''} hidden',
                    style: GoogleFonts.nunito(
                      color: kcLightGrey,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        title,
        style: GoogleFonts.nunito(
          color: kcPrimaryPink,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildInfoSection(AnimeInfoViewModel viewModel) {
    final anime = viewModel.anime!;
    final duration =
        anime['duration'] != null ? '${anime['duration']} min' : 'Unknown';

    final startDate = viewModel.formatDate(anime['startDate']);
    final endDate = viewModel.formatDate(anime['endDate']);

    final season = anime['season'] != null && anime['seasonYear'] != null
        ? '${anime['season'][0]}${anime['season'].substring(1).toLowerCase()} ${anime['seasonYear']}'
        : 'Unknown';
    final source = anime['source'] != null
        ? '${anime['source'][0]}${anime['source'].substring(1).toLowerCase().replaceAll('_', ' ')}'
        : 'Unknown';

    final romaji = anime['title']['romaji'] ?? 'Unknown';
    final english = anime['title']['english'] ?? 'Unknown';

    final rows = [
      ('Duration', duration),
      ('Start date', startDate),
      ('End date', endDate),
      ('Season', season),
      ('Source', source),
      ('Romaji', romaji),
      ('English', english),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...rows.map((row) => _buildInfoRow(row.$1, row.$2)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 151,
            child: Text(
              label,
              style: GoogleFonts.nunito(
                color: kcLightGrey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.nunito(
                color: kcOffWhite,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Generic +/- counter row used by both Score and Rewatch Count below.
  // UI-only for now — the value lives in the sheet's local state and is
  // not part of `saveToWatchlist` yet.
  Widget _buildCounterRow({
    required IconData icon,
    required String label,
    required int value,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(icon, color: kcLightGrey, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              color: kcOffWhite,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            '$value',
            style: GoogleFonts.inter(
              color: kcOffWhite,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onDecrement,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: kcBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.remove, color: kcOffWhite, size: 20),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onIncrement,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: kcBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: kcOffWhite, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // WatchlistEntry. TODO: hook up a date picker  persist once supported.
  Widget _buildDateRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onEditTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(icon, color: kcLightGrey, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              color: kcOffWhite,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.inter(
              color: kcLightGrey,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onEditTap,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: kcBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, color: kcLightGrey, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  // Custom Categories row
  // TODO: open a category picker
  Widget _buildCustomCategoriesRow(VoidCallback onEditTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const SizedBox(
            width: 28,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.bookmarks_outlined, color: kcLightGrey, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Custom Categories',
            style: GoogleFonts.inter(
              color: kcOffWhite,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onEditTap,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: kcBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, color: kcLightGrey, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  void _showWatchlistSheet(BuildContext context, AnimeInfoViewModel viewModel) {
    String selectedStatus = viewModel.watchlistEntry?.status ?? 'WATCHING';
    int episodesWatched = viewModel.watchlistEntry?.episodesWatched ?? 0;
    final totalEpisodes = viewModel.totalEpisodes;

    // UI-only state for now — not part of WatchlistEntry yet, so nothing
    // here is passed to saveToWatchlist(). See _buildCounterRow /
    // _buildDateRow / _buildCustomCategoriesRow TODOs.
    int score = 0;
    int rewatchCount = 0;

    final statuses = [
      {'value': 'WATCHING', 'icon': Icons.play_circle_outline},
      {'value': 'COMPLETED', 'icon': Icons.check_circle_outline},
      {'value': 'PAUSED', 'icon': Icons.pause_circle_outline},
      {'value': 'DROPPED', 'icon': Icons.delete_outline},
      {'value': 'REWATCHING', 'icon': Icons.replay},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: kcSurfaceColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: kcLightGrey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // cancel and save row
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: kcBackgroundColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.nunito(
                              color: kcLightGrey,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // auto-fill episodes to max only when saving as completed
                          final finalEpisodes =
                              selectedStatus == 'COMPLETED' && totalEpisodes > 0
                                  ? totalEpisodes
                                  : episodesWatched;

                          Navigator.pop(context);
                          viewModel.saveToWatchlist(
                            status: selectedStatus,
                            episodesWatched: finalEpisodes,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: kcPrimaryPink,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Save',
                            style: GoogleFonts.nunito(
                              color: kcOffWhite,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // status buttons row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: statuses.map((s) {
                    final isSelected = selectedStatus == s['value'];
                    return GestureDetector(
                      onTap: () => setSheetState(
                          () => selectedStatus = s['value'] as String),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeInOut,
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: isSelected ? kcPrimaryPink : kcBackgroundColor,
                          borderRadius:
                              BorderRadius.circular(isSelected ? 16 : 50),
                        ),
                        child: Icon(
                          s['icon'] as IconData,
                          color: isSelected ? kcOffWhite : kcLightGrey,
                          size: 24,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // episode counter
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: viewModel.isNotYetReleased
                      ? Row(
                          children: [
                            const SizedBox(
                              width: 28,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(Icons.play_circle_outline_rounded, color: kcLightGrey, size: 22),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'No episodes yet',
                              style: GoogleFonts.inter(
                                color: kcLightGrey,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            const SizedBox(
                              width: 28,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(Icons.play_circle_outline_rounded, color: kcLightGrey, size: 22),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              viewModel.isNotYetReleased
                                  ? 'No episodes yet'
                                  : viewModel.isCurrentlyAiring && viewModel.latestEpisode > 0
                                      ? '$episodesWatched / ${viewModel.latestEpisode} of ${totalEpisodes > 0 ? totalEpisodes : '?'} Episodes'
                                      : '$episodesWatched / ${totalEpisodes > 0 ? totalEpisodes : '?'} Episodes',
                              style: GoogleFonts.inter(
                                color: viewModel.isNotYetReleased ? kcLightGrey : kcOffWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            // minus button
                            GestureDetector(
                              onTap: () => setSheetState(() {
                                if (episodesWatched > 0) episodesWatched--;
                              }),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: kcBackgroundColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.remove,
                                    color: kcOffWhite, size: 20),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // plus button
                            GestureDetector(
                              onTap: () => setSheetState(() {
                                final cap = viewModel.isCurrentlyAiring
                                    ? viewModel.latestEpisode
                                    : totalEpisodes;
                                if (cap == 0 || episodesWatched < cap) {
                                  episodesWatched++;
                                }
                              }),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: kcBackgroundColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.add,
                                    color: kcOffWhite, size: 20),
                              ),
                            ),
                          ],
                        ),
                ),
                if (totalEpisodes > 0)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: LinearProgressIndicator(
                      value: episodesWatched / totalEpisodes,
                      backgroundColor: kcBackgroundColor,
                      color: kcPrimaryPink,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                const SizedBox(height: 20),
                // score
                _buildCounterRow(
                  icon: Icons.star,
                  label: 'Score',
                  value: score,
                  onDecrement: () => setSheetState(() {
                    if (score > 0) score--;
                  }),
                  onIncrement: () => setSheetState(() {
                    if (score < 10) score++;
                  }),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Divider(color: kcLightGrey, height: 1),
                ),
                const SizedBox(height: 24),
                // start date
                _buildDateRow(
                  icon: Icons.event_outlined,
                  label: 'Start Date',
                  value: 'Not set',
                  onEditTap: () {
                    // TODO: open a date picker once start date is tracked
                  },
                ),
                const SizedBox(height: 16),

                // end date
                _buildDateRow(
                  icon: Icons.event_available_outlined,
                  label: 'End Date',
                  value: 'Not set',
                  onEditTap: () {
                    // TODO: open a date picker once end date is tracked
                  },
                ),
                const SizedBox(height: 20),

                // rewatch count
                _buildCounterRow(
                  icon: Icons.history_toggle_off_rounded,
                  label: 'Rewatch Count',
                  value: rewatchCount,
                  onDecrement: () => setSheetState(() {
                    if (rewatchCount > 0) rewatchCount--;
                  }),
                  onIncrement: () => setSheetState(() {
                    rewatchCount++;
                  }),
                ),
                const SizedBox(height: 20),

                // custom categories
                _buildCustomCategoriesRow(() {
                  // TODO: open category picker once per-anime categories exist
                }),

                // remove from watchlist button
                if (viewModel.isInWatchlist)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _showDeleteWatchlistDialog(context, viewModel);
                      },
                      child: Row(
                        children: [
                          const SizedBox(
                              width: 28,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(Icons.delete_outline_outlined, color: kcPrimaryPink, size: 22)
                              ),
                            ),
                          const SizedBox(width: 12),
                          Text(
                            'Delete from Watch List',
                            style: GoogleFonts.inter(
                              color: kcPrimaryPink,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteWatchlistDialog(
      BuildContext context, AnimeInfoViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: kcSurfaceColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.delete_outline,
                color: kcTertiaryPink,
                size: 54,
              ),
              const SizedBox(height: 4),
              Text(
                'Remove from Watch List?',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: kcTertiaryPink,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Are you sure you want to delete this entry from your watch list?',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: kcLightGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: kcTertiaryPink,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          'No, keep it.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            color: kcSurfaceColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        viewModel.removeFromWatchlist();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: kcPrimaryPink,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          'Yes, delete!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            color: kcOffWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onViewModelReady(AnimeInfoViewModel viewModel) =>
      viewModel.loadAnimeDetails(animeId);

  @override
  AnimeInfoViewModel viewModelBuilder(BuildContext context) =>
      AnimeInfoViewModel();
}