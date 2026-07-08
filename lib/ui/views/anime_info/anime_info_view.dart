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
      return const Scaffold(
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
                      viewModel.isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
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

  @override
  void onViewModelReady(AnimeInfoViewModel viewModel) =>
      viewModel.loadAnimeDetails(animeId);

  @override
  AnimeInfoViewModel viewModelBuilder(BuildContext context) =>
      AnimeInfoViewModel();
}
