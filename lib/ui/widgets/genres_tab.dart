import 'package:aniyoka/app/app.locator.dart';
import 'package:aniyoka/services/anilist_service.dart';
import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:aniyoka/ui/views/anime_info/anime_info_view.dart';
import 'package:aniyoka/utils/genre_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum GenreSort { popularity, topRated }

extension GenreSortLabel on GenreSort {
  String get label {
    switch (this) {
      case GenreSort.popularity: return 'Popularity';
      case GenreSort.topRated: return 'Top Rated';
    }
  }

  String get apiValue {
    switch (this) {
      case GenreSort.popularity: return 'POPULARITY_DESC';
      case GenreSort.topRated: return 'SCORE_DESC';
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

  String _selectedGenre = GenreHelper.topGenres.first;
  GenreSort _selectedSort = GenreSort.popularity;
  int? _selectedYear;
  String? _selectedSeason;
  List<dynamic> _animeList = [];
  bool _isLoading = false;

  // temp selections inside the sheet before applying
  late String _tempGenre;
  late GenreSort _tempSort;
  int? _tempYear;
  String? _tempSeason;

  static const List<String> _seasons = ['WINTER', 'SPRING', 'SUMMER', 'FALL'];
  static const Map<String, IconData> _seasonIcons = {
    'WINTER': Icons.ac_unit,
    'SPRING': Icons.local_florist,
    'SUMMER': Icons.wb_sunny,
    'FALL': Icons.cloud,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAnime());
  }

  Future<void> _loadAnime() async {
    setState(() => _isLoading = true);
    try {
      final result = await _anilistService.getAnimeByGenreAndSort(
        genre: _selectedGenre,
        sort: _selectedSort.apiValue,
        year: _selectedYear,
        season: _selectedSeason,
      );
      setState(() => _animeList = result);
    } catch (e) {
      setState(() => _animeList = []);
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: kcPrimaryPink))
              : _buildGrid(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    // build active filter summary label
    final parts = <String>[_selectedGenre];
    if (_selectedSeason != null) {
      parts.add('${_selectedSeason![0]}${_selectedSeason!.substring(1).toLowerCase()}');
    }
    if (_selectedYear != null) parts.add('$_selectedYear');

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // genre title + sort label
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
          // filter button beside header
          GestureDetector(
            onTap: _showFilterSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: kcSurfaceColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kcAccentPink),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.filter_list, color: kcOffWhite, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Filter',
                    style: GoogleFonts.nunito(
                      color: kcOffWhite,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
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

  String _buildSubtitle() {
    final parts = <String>[_selectedSort.label];
    if (_selectedSeason != null) {
      parts.add('${_selectedSeason![0]}${_selectedSeason!.substring(1).toLowerCase()}');
    }
    if (_selectedYear != null) parts.add('$_selectedYear');
    return parts.join(' • ');
  }

  Widget _buildGrid() {
    if (_animeList.isEmpty) {
      return const Center(
        child: Text('No anime found', style: TextStyle(color: kcLightGrey)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.55,
      ),
      itemCount: _animeList.length,
      itemBuilder: (context, index) => _buildCard(_animeList[index]),
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
    // initialize temp values from current selections
    _tempGenre = _selectedGenre;
    _tempSort = _selectedSort;
    _tempYear = _selectedYear;
    _tempSeason = _selectedSeason;

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
            maxChildSize: 0.92,
            expand: false,
            builder: (context, scrollController) {
              return DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    // drag handle
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: kcLightGrey,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    // cancel + apply row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.nunito(
                                color: kcLightGrey,
                                fontSize: 15,
                              ),
                            ),
                          ),
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
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                              decoration: BoxDecoration(
                                color: kcPrimaryPink,
                                borderRadius: BorderRadius.circular(20),
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
                    ),
                    const SizedBox(height: 12),
                    // tab bar
                    TabBar(
                      isScrollable: false,
                      labelColor: kcPrimaryPink,
                      unselectedLabelColor: kcLightGrey,
                      indicatorColor: kcPrimaryPink,
                      indicatorWeight: 2,
                      dividerColor: kcLightGrey.withValues(alpha: 0.3),
                      labelStyle: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: GoogleFonts.nunito(fontSize: 15),
                      tabs: const [
                        Tab(text: 'Genre'),
                        Tab(text: 'Sort'),
                      ],
                    ),
                    // tab content
                    Expanded(
                      child: TabBarView(
                        children: [
                          // genre tab
                          ListView(
                            controller: scrollController,
                            padding: const EdgeInsets.all(20),
                            children: GenreHelper.topGenres.map((genre) {
                              final isSelected = genre == _tempGenre;
                              return GestureDetector(
                                onTap: () => setSheetState(() => _tempGenre = genre),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? kcPrimaryPink : kcBackgroundColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    genre,
                                    style: GoogleFonts.nunito(
                                      color: isSelected ? kcOffWhite : kcLightGrey,
                                      fontSize: 15,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          // sort tab
                          ListView(
                            padding: const EdgeInsets.all(20),
                            children: [
                              // sort options
                              Text('Sort by', style: GoogleFonts.nunito(color: kcOffWhite, fontSize: 16, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 12),
                              ...GenreSort.values.map((sort) {
                                final isSelected = sort == _tempSort;
                                return GestureDetector(
                                  onTap: () => setSheetState(() => _tempSort = sort),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected ? kcPrimaryPink : kcBackgroundColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      sort.label,
                                      style: GoogleFonts.nunito(
                                        color: isSelected ? kcOffWhite : kcLightGrey,
                                        fontSize: 15,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              const SizedBox(height: 20),
                              // season filter
                              Text('Season', style: GoogleFonts.nunito(color: kcOffWhite, fontSize: 16, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                        color: isSelected ? kcPrimaryPink : kcBackgroundColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        _seasonIcons[season],
                                        color: isSelected ? kcOffWhite : kcLightGrey,
                                        size: 28,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 20),
                              // year filter
                              Text('Year', style: GoogleFonts.nunito(color: kcOffWhite, fontSize: 16, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 44,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 10,
                                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                                  itemBuilder: (context, index) {
                                    final year = DateTime.now().year + 1 - index;
                                    final isSelected = _tempYear == year;
                                    return GestureDetector(
                                      onTap: () => setSheetState(() {
                                        _tempYear = isSelected ? null : year;
                                      }),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: isSelected ? kcPrimaryPink : kcBackgroundColor,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: isSelected ? kcPrimaryPink : kcLightGrey.withValues(alpha: 0.3),
                                          ),
                                        ),
                                        child: Text(
                                          '$year',
                                          style: GoogleFonts.nunito(
                                            color: isSelected ? kcOffWhite : kcLightGrey,
                                            fontSize: 14,
                                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
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
}