import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:aniyoka/ui/views/anime_info/anime_info_view.dart';
import 'package:aniyoka/ui/views/home/home_viewmodel.dart';
import 'package:aniyoka/utils/genre_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GenresTab extends StatefulWidget {
  final HomeViewModel viewModel;
  const GenresTab({super.key, required this.viewModel});

  @override
  State<GenresTab> createState() => _GenresTabState();
}

class _GenresTabState extends State<GenresTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.loadGenres();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // show spinner only if nothing has loaded yet
    if (widget.viewModel.isGenresBusy && widget.viewModel.genreAnime.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: kcPrimaryPink),
      );
    }

    return RefreshIndicator(
      color: kcPrimaryPink,
      backgroundColor: kcSurfaceColor,
      onRefresh: () async {
        widget.viewModel.resetGenres();
        await widget.viewModel.loadGenres();
      },
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 16),
          _buildFilterRow(),
          // only show genres that have already loaded
          ...GenreHelper.topGenres
              .where((genre) => widget.viewModel.genreAnime.containsKey(genre))
              .map((genre) => _buildGenreSection(
                    genre,
                    widget.viewModel.genreAnime[genre] ?? [],
                  )),
          // show a small loading indicator at the bottom while more genres load
          if (widget.viewModel.isGenresBusy)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: CircularProgressIndicator(color: kcPrimaryPink),
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildGenreSection(String genre, List<dynamic> animeList) {
    return Column(
      children: [
        _buildSectionHeader(genre),
        const SizedBox(height: 12),
        _buildAnimeRow(animeList),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.nunito(
              color: kcPrimaryPink,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Icon(Icons.arrow_forward, color: kcTertiaryPink, size: 24),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: GenreFilter.values.map((filter) {
          final isSelected = widget.viewModel.genreFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => widget.viewModel.setGenreFilter(filter),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? kcPrimaryPink : kcSurfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? kcPrimaryPink : kcAccentPink,
                  ),
                ),
                child: Text(
                  filter.label,
                  style: GoogleFonts.nunito(
                    color: isSelected ? kcOffWhite : kcLightGrey,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAnimeRow(List<dynamic> animeList) {
    if (animeList.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(
          child: Text('No anime found', style: TextStyle(color: kcLightGrey)),
        ),
      );
    }

    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        itemCount: animeList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final anime = animeList[index];
          final title =
              anime['title']['english'] ?? anime['title']['romaji'] ?? '';
          final format = anime['format'] ?? '';
          final year = anime['startDate']?['year']?.toString() ?? '';

          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                    AnimeInfoView(animeId: anime['id']),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
                transitionsBuilder: (_, __, ___, child) => child,
              ),
            ),
            child: SizedBox(
              width: 135,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: anime['coverImage']['large'] ?? '',
                      width: 125,
                      height: 175,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: kcSurfaceColor),
                      errorWidget: (context, url, error) =>
                          Container(color: kcSurfaceColor),
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
                    style: GoogleFonts.inter(
                      color: kcLightGrey,
                      fontSize: 14,
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
}
