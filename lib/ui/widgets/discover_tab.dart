import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:aniyoka/ui/views/anime_info/anime_info_view.dart';
import 'package:aniyoka/ui/views/anime_list/anime_list_view.dart';
import 'package:aniyoka/ui/widgets/anime_card_row.dart';
import 'package:aniyoka/ui/views/home/home_viewmodel.dart';
import 'package:aniyoka/utils/anime_list_helper.dart';
import 'package:aniyoka/utils/season_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DiscoverTab extends StatefulWidget {
  final HomeViewModel viewModel;
  const DiscoverTab({super.key, required this.viewModel});

  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // only show spinner if nothing has loaded yet
    if (widget.viewModel.popularAnime.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: kcPrimaryPink),
      );
    }

    final sections = [
      (SeasonHelper.currentSeasonLabel, widget.viewModel.thisSeason,
          AnimeListFilter(type: AnimeListType.thisSeason, title: SeasonHelper.currentSeasonLabel)),
      ('Next Season', widget.viewModel.nextSeason,
          const AnimeListFilter(type: AnimeListType.nextSeason, title: 'Next Season')),
      ('Newly Added', widget.viewModel.newlyAdded,
          const AnimeListFilter(type: AnimeListType.newlyAdded, title: 'Newly Added')),
      ('Airing Soon', widget.viewModel.airingSoon,
          const AnimeListFilter(type: AnimeListType.airingSoon, title: 'Airing Soon')),
    ];

    return RefreshIndicator(
      color: kcPrimaryPink,
      backgroundColor: kcSurfaceColor,
      onRefresh: widget.viewModel.refreshData,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 12),
          _buildSectionHeader('Popular Now', const AnimeListFilter(
            type: AnimeListType.popular,
            title: 'Popular Now',
          )),
          const SizedBox(height: 10),
          _buildPopularSection(widget.viewModel.popularAnime),
          const SizedBox(height: 10),
          ...sections
            .where((section) => section.$2.isNotEmpty)
            .map((section) => _buildSection(section.$1, section.$2, section.$3)),
          // show bottom spinner while remaining sections are still loading
          if (widget.viewModel.isBusy)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: CircularProgressIndicator(color: kcPrimaryPink),
              ),
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<dynamic> animeList, AnimeListFilter filter) {
    return Column(
      children: [
        _buildSectionHeader(title, filter),
        const SizedBox(height: 12),
        AnimeCardRow(
          animeList: animeList,
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
      ],
    );
  }

  Widget _buildPopularSection(List<dynamic> animeList) {
    if (animeList.isEmpty) {
      return const SizedBox(
        height: 230,
        child: Center(
          child: Text('No anime found', style: TextStyle(color: kcLightGrey)),
        ),
      );
    }

    return SizedBox(
      height: 230,
      child: PageView.builder(
        controller: widget.viewModel.pageController,
        itemCount: animeList.length,
        itemBuilder: (context, index) {
          final anime = animeList[index];
          final title =
              anime['title']['english'] ?? anime['title']['romaji'] ?? '';
          final image =
              anime['bannerImage'] ?? anime['coverImage']['extraLarge'] ?? '';
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: image,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          Container(color: kcSurfaceColor),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black87],
                          stops: [0.2, 1.0],
                        ),
                      ),
                    ),
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, AnimeListFilter filter) {
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
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => AnimeListView(filter: filter),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
                transitionsBuilder: (_, __, ___, child) => child,
              ),
            ),
            child: const Icon(Icons.arrow_forward, color: kcTertiaryPink, size: 24),
          ),
        ],
      ),
    );
  }
}
