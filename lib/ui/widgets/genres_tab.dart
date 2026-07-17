import 'package:aniyoka/app/app.locator.dart';
import 'package:aniyoka/services/anilist_service.dart';
import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:aniyoka/ui/views/anime_info/anime_info_view.dart';
import 'package:aniyoka/ui/widgets/watchlist_sheet.dart';
import 'package:aniyoka/utils/genre_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum GenreSort { popularity, topRated, favorites, alphabetical }

extension GenreSortLabel on GenreSort {
  String get label {
    switch (this) {
      case GenreSort.popularity:
        return 'Popularity';
      case GenreSort.topRated:
        return 'Top Rated';
      case GenreSort.favorites:
        return 'Most Favorites';
      case GenreSort.alphabetical:
        return 'Alphabetical';
    }
  }

  String get apiValue {
    switch (this) {
      case GenreSort.popularity:
        return 'POPULARITY_DESC';
      case GenreSort.topRated:
        return 'SCORE_DESC';
      case GenreSort.favorites:
        return 'FAVOURITES_DESC';
      case GenreSort.alphabetical:
        return 'TITLE_ROMAJI';
    }
  }
}

class GenresTab extends StatefulWidget {
  const GenresTab({super.key});

  @override
  State<GenresTab> createState() => _GenresTabState();
}

class _GenresTabState extends State<GenresTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _anilistService = locator<AniListService>();

  String _selectedGenre = GenreHelper.allGenres.first;
  GenreSort _selectedSort = GenreSort.popularity;
  String? _selectedSeason;
  int? _selectedYear;
  List<dynamic> _animeList = [];
  bool _isLoading = false;

  late String _tempGenre;
  late GenreSort _tempSort;
  String? _tempSeason;
  int? _tempYear;

  static const List<String> _seasons = ['SPRING', 'SUMMER', 'FALL', 'WINTER'];
  static const Map<String, IconData> _seasonIcons = {
    'SPRING': Icons.local_florist,
    'SUMMER': Icons.wb_sunny,
    'FALL': Icons.eco,
    'WINTER': Icons.ac_unit
  };

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        _loadMore();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAnime());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadAnime({int retries = 2}) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _currentPage = 1; // ← reset page
      _hasNextPage = true; // ← reset pagination
      _animeList = []; // ← clear old results
    });

    List<dynamic> result = [];

    for (int attempt = 0; attempt <= retries; attempt++) {
      try {
        result = await _anilistService.getAnimeByGenreAndSort(
          genre: _selectedGenre,
          sort: _selectedSort.apiValue,
          year: _selectedYear,
          season: _selectedSeason,
          page: 1,
        );
        if (result.isNotEmpty) break;
        if (attempt < retries)
          await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        if (attempt < retries)
          await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    if (!mounted) return;
    setState(() {
      _animeList = result;
      _isLoading = false;
    });
  }

  Future<void> _loadMore() async {
    if (!_hasNextPage || _isLoadingMore || _isLoading) return;
    if (!mounted) return;
    setState(() => _isLoadingMore = true);

    try {
      final result = await _anilistService.getAnimeByGenreAndSort(
        genre: _selectedGenre,
        sort: _selectedSort.apiValue,
        year: _selectedYear,
        season: _selectedSeason,
        page: _currentPage + 1,
      );
      if (!mounted) return;
      setState(() {
        if (result.isEmpty) {
          _hasNextPage = false;
        } else {
          _currentPage++;
          _animeList = [..._animeList, ...result];
        }
        _isLoadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingMore = false);
    }
  }

  String _buildSubtitle() {
    final parts = <String>[_selectedSort.label];
    if (_selectedSeason != null) {
      parts.add(
          '${_selectedSeason![0]}${_selectedSeason!.substring(1).toLowerCase()}');
    }
    if (_selectedYear != null) parts.add('$_selectedYear');
    return parts.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: kcPrimaryPink));
    }

    return RefreshIndicator(
      color: kcPrimaryPink,
      backgroundColor: kcSurfaceColor,
      onRefresh: _loadAnime,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedGenre,
                        style: GoogleFonts.nunito(
                          color: kcPrimaryPink,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        _buildSubtitle(),
                        style: GoogleFonts.nunito(
                          color: kcLightGrey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _showFilterSheet,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(
                        color: kcSurfaceColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.filter_list,
                              color: kcLightGrey, size: 18),
                          const SizedBox(width: 10),
                          Text(
                            'Filter',
                            style: GoogleFonts.nunito(
                              color: kcLightGrey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _animeList.isEmpty
              ? SliverFillRemaining(
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
                            'There seems to be an error in finding your anime.',
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
                          onTap: _loadAnime,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            decoration: BoxDecoration(
                              color: kcSurfaceColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'Reload the page!',
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
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.50,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildCard(_animeList[index]),
                      childCount: _animeList.length,
                    ),
                  ),
                ),
          if (_isLoadingMore)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(color: kcPrimaryPink),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildCard(dynamic anime) {
    final title = anime['title']['english'] ?? anime['title']['romaji'] ?? '';
    final format = anime['format'] ?? '';
    final year = anime['startDate']?['year']?.toString() ?? '';

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => AnimeInfoView(animeId: anime['id']),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          transitionsBuilder: (_, __, ___, child) => child,
        ),
      ),
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

  void _showFilterSheet() {
    _tempGenre = _selectedGenre;
    _tempSort = _selectedSort;
    _tempSeason = _selectedSeason;
    _tempYear = _selectedYear;

    showModalBottomSheet(
      context: context,
      backgroundColor: kcSurfaceColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.75,
            minChildSize: 0.5,
            maxChildSize: 0.85,
            expand: false,
            builder: (context, scrollController) {
              return DefaultTabController(
                length: 2,
                child: Column(
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
                    _buildActionButtons(context, setSheetState),
                    const SizedBox(height: 12),
                    // tab bar
                    TabBar(
                      isScrollable: false,
                      labelColor: kcPrimaryPink,
                      unselectedLabelColor: kcLightGrey,
                      indicatorColor: kcPrimaryPink,
                      indicatorWeight: 2,
                      dividerColor: kcLightGrey.withValues(alpha: 0.5),
                      labelStyle: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: GoogleFonts.nunito(fontSize: 16),
                      tabs: const [
                        Tab(text: 'Genre'),
                        Tab(text: 'Sort'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          ListView(
                            controller: scrollController,
                            padding: const EdgeInsets.all(20),
                            children: [
                              GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisSpacing: 6,
                                mainAxisSpacing: 8,
                                childAspectRatio: 3.2,
                                children: GenreHelper.allGenres.map((genre) {
                                  final isSelected = genre == _tempGenre;
                                  return GestureDetector(
                                    onTap: () =>
                                        setSheetState(() => _tempGenre = genre),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? kcPrimaryPink
                                            : kcBackgroundColor,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        genre,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.nunito(
                                          color: isSelected
                                              ? kcOffWhite
                                              : kcLightGrey,
                                          fontSize: 15,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          // sort tab
                          ListView(
                            padding: const EdgeInsets.all(20),
                            children: [
                              Text(
                                'Sort by',
                                style: GoogleFonts.nunito(
                                  color: kcOffWhite,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...GenreSort.values.map((sort) {
                                final isSelected = sort == _tempSort;
                                return GestureDetector(
                                  onTap: () =>
                                      setSheetState(() => _tempSort = sort),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18, horizontal: 20),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? kcPrimaryPink
                                          : kcBackgroundColor,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Text(
                                      sort.label,
                                      style: GoogleFonts.nunito(
                                        color: isSelected
                                            ? kcOffWhite
                                            : kcLightGrey,
                                        fontSize: 15,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              const SizedBox(height: 20),
                              // season
                              Text(
                                'Season',
                                style: GoogleFonts.nunito(
                                  color: kcOffWhite,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: _seasons.map((season) {
                                  final isSelected = _tempSeason == season;
                                  return GestureDetector(
                                    onTap: () => setSheetState(() {
                                      _tempSeason = isSelected ? null : season;
                                    }),
                                    child: Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? kcPrimaryPink
                                            : kcBackgroundColor,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Icon(
                                        _seasonIcons[season],
                                        color: isSelected
                                            ? kcOffWhite
                                            : kcLightGrey,
                                        size: 28,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Year',
                                style: GoogleFonts.nunito(
                                  color: kcOffWhite,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 40,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 50,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 8),
                                  itemBuilder: (context, index) {
                                    final year =
                                        DateTime.now().year + 1 - index;
                                    final isSelected = _tempYear == year;
                                    return GestureDetector(
                                      onTap: () => setSheetState(() {
                                        _tempYear = isSelected ? null : year;
                                      }),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 10),
                                        decoration: BoxDecoration(
                                            color: isSelected
                                                ? kcPrimaryPink
                                                : kcBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Text(
                                          '$year',
                                          style: GoogleFonts.nunito(
                                            color: isSelected
                                                ? kcOffWhite
                                                : kcLightGrey,
                                            fontSize: 14,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, StateSetter setSheetState) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              setSheetState(() {
                _tempGenre = GenreHelper.allGenres.first;
                _tempSort = GenreSort.popularity;
                _tempSeason = null;
                _tempYear = null;
                _selectedGenre = GenreHelper.allGenres.first;
                _selectedSort = GenreSort.popularity;
                _selectedSeason = null;
                _selectedYear = null;
              });
              _loadAnime();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: kcBackgroundColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Reset',
                style: GoogleFonts.nunito(
                  color: kcLightGrey,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _selectedGenre = _tempGenre;
                _selectedSort = _tempSort;
                _selectedYear = _tempYear;
                _selectedSeason = _tempSeason;
              });
              _loadAnime();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: kcPrimaryPink,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Apply',
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
    );
  }
}
