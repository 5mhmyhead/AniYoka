import 'dart:async';
import 'package:aniyoka/app/app.router.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:aniyoka/app/app.locator.dart';
import 'package:aniyoka/services/anilist_service.dart';
import 'package:stacked_services/stacked_services.dart';

class ExploreViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _anilistService = locator<AniListService>();

  static const int _minimumSearchLength = 3;
  static const Duration _searchDebounceDuration = Duration(milliseconds: 900);

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  final TextEditingController searchController = TextEditingController();

  Timer? _debounce;
  int _searchRequestId = 0;

  final FocusNode searchFocusNode = FocusNode();

  ExploreViewModel() {
    searchController.addListener(_onSearchChanged);
  }

  void onAnimeTap(int id) {
    _navigationService.navigateToAnimeInfoView(
        animeId: id, transition: TransitionsBuilders.fadeIn);
  }

  void startSearchMode() {
    _isSearching = true;
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchFocusNode.requestFocus();
    });
  }

  void exitSearchMode() {
    _isSearching = false;
    clearSearch();
    clearFilters();
    searchFocusNode.unfocus();
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    _searchText = '';
    _searchResults = [];
    _relatedResults = [];
    _hasSearched = false;
    clearErrors();
    notifyListeners();
  }

  bool get hasMultipleActiveFilters {
    int activeCount = 0;
    if (selectedSortLabel != null) activeCount++;
    if (selectedStatusLabel != null) activeCount++;
    if (selectedGenreLabel != null) activeCount++;
    if (selectedFormatLabel != null) activeCount++;
    if (onMyListOnly) activeCount++;

    return activeCount > 1;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  // Options Configurations Maps
  final Map<String, String?> _statusOptions = {
    'Any Status': null,
    'Airing': 'RELEASING',
    'Finished': 'FINISHED',
    'Not Yet Released': 'NOT_YET_RELEASED',
    'Cancelled': 'CANCELLED',
    'Hiatus': 'HIATUS',
  };

  final Map<String, String?> _genreOptions = {
    'Any Genre': null,
    'Action': 'Action',
    'Adventure': 'Adventure',
    'Comedy': 'Comedy',
    'Drama': 'Drama',
    'Fantasy': 'Fantasy',
    'Horror': 'Horror',
    'Mahou Shoujo': 'Mahou Shoujo',
    'Mecha': 'Mecha',
    'Music': 'Music',
    'Mystery': 'Mystery',
    'Psychological': 'Psychological',
    'Romance': 'Romance',
    'Sci-Fi': 'Sci-Fi',
    'Slice of Life': 'Slice of Life',
    'Sports': 'Sports',
    'Supernatural': 'Supernatural',
    'Thriller': 'Thriller',
  };

  final Map<String, String?> _formatOptions = {
    'Any Format': null,
    'TV': 'TV',
    'TV Short': 'TV_SHORT',
    'Movie': 'MOVIE',
    'Special': 'SPECIAL',
    'OVA': 'OVA',
    'ONA': 'ONA',
    'Music': 'MUSIC',
  };

  final Map<String, String> _sortOptions = {
    'Default': 'SEARCH_MATCH',
    'Popular': 'POPULARITY_DESC',
    'Trending': 'TRENDING_DESC',
    'Highest Rated': 'SCORE_DESC',
    'Newest': 'START_DATE_DESC',
    'Oldest': 'START_DATE',
    'Title A-Z': 'TITLE_ROMAJI',
  };

  String _searchText = '';
  String get searchText => _searchText;

  List<dynamic> _searchResults = [];
  List<dynamic> get searchResults => _searchResults;

  List<dynamic> _relatedResults = [];
  List<dynamic> get relatedResults => _relatedResults;

  bool _hasSearched = false;
  bool get hasSearched => _hasSearched;

  bool _onMyListOnly = false;
  bool get onMyListOnly => _onMyListOnly;

  String? _selectedStatusLabel;
  String? get selectedStatusLabel => _selectedStatusLabel;

  String? _selectedGenreLabel;
  String? get selectedGenreLabel => _selectedGenreLabel;

  String? _selectedFormatLabel;
  String? get selectedFormatLabel => _selectedFormatLabel;

  String? _selectedSortLabel;
  String? get selectedSortLabel => _selectedSortLabel;

  List<String> get statusOptionLabels => _statusOptions.keys.toList();
  List<String> get genreOptionLabels => _genreOptions.keys.toList();
  List<String> get formatOptionLabels => _formatOptions.keys.toList();
  List<String> get sortOptionLabels => _sortOptions.keys.toList();

  String get statusFilterLabel => _selectedStatusLabel ?? 'Status';
  String get genreFilterLabel => _selectedGenreLabel ?? 'Genre';
  String get formatFilterLabel => _selectedFormatLabel ?? 'Format';
  String get sortFilterLabel => _selectedSortLabel ?? 'Default';

  bool get hasActiveFilters {
    return _onMyListOnly ||
        _selectedStatusLabel != null ||
        _selectedGenreLabel != null ||
        _selectedFormatLabel != null ||
        _selectedSortLabel != null;
  }

  String? get _apiStatus => _selectedStatusLabel == null
      ? null
      : _statusOptions[_selectedStatusLabel];
  String? get _apiGenre =>
      _selectedGenreLabel == null ? null : _genreOptions[_selectedGenreLabel];
  String? get _apiFormat => _selectedFormatLabel == null
      ? null
      : _formatOptions[_selectedFormatLabel];
  String get _apiSort =>
      _sortOptions[_selectedSortLabel ?? 'Default'] ?? 'SEARCH_MATCH';

  void _onSearchChanged() {
    final input = searchController.text.trim();
    _searchText = input;
    _debounce?.cancel();

    if (input.isEmpty || input.length < _minimumSearchLength) {
      _searchRequestId++;
      _searchResults = [];
      _relatedResults = [];
      _hasSearched = false;
      clearErrors();
      setBusy(false);
      notifyListeners();
      return;
    }

    setBusy(true);
    _debounce = Timer(_searchDebounceDuration, () => searchAnime(input));
  }

  Future<void> loadAnimeByActiveFilters() async {
    final int requestId = ++_searchRequestId;

    try {
      clearErrors();
      setBusy(true);

      final results = await _anilistService.getAnimeByFilters(
        status: _apiStatus,
        genre: _apiGenre,
        format: _apiFormat,
        sort: _apiSort,
        perPage: 30,
      );

      if (requestId != _searchRequestId) return;

      _searchResults = _removeDuplicateAnime(results);
      _relatedResults = [];
      _hasSearched = true;
    } catch (e) {
      if (requestId == _searchRequestId) {
        _searchResults = [];
        _relatedResults = [];
        _hasSearched = true;
        _handleError(e);
      }
    } finally {
      if (requestId == _searchRequestId) {
        setBusy(false);
      }
    }
  }

  Future<void> searchAnime(String input) async {
    final currentInput = input.trim();
    final int requestId = ++_searchRequestId;

    if (currentInput.isEmpty) return;

    try {
      clearErrors();

      final directResults = await _anilistService.searchAnime(
        currentInput,
        status: _apiStatus,
        genre: _apiGenre,
        format: _apiFormat,
        sort: _apiSort,
      );

      final suggestionResults =
          await _anilistService.getPopularAnimeForSearchSuggestions(
        status: _apiStatus,
        genre: _apiGenre,
        format: _apiFormat,
        sort: _apiSort,
        maxPages: 3,
      );

      if (requestId != _searchRequestId || currentInput != _searchText) return;

      final matchingSuggestions = suggestionResults.where((anime) {
        return _anyTitleContainsSearch(anime, currentInput);
      }).toList();

      final combinedResults = _removeDuplicateAnime([
        ...directResults,
        ...matchingSuggestions,
      ]);

      final groupedResults = _groupSearchResults(combinedResults, currentInput);

      _searchResults = groupedResults['startsWith']!;
      _relatedResults = groupedResults['contains']!;
      _hasSearched = true;
    } catch (e) {
      if (requestId == _searchRequestId && currentInput == _searchText) {
        _searchResults = [];
        _relatedResults = [];
        _hasSearched = true;
        _handleError(e);
      }
    } finally {
      if (requestId == _searchRequestId && currentInput == _searchText) {
        setBusy(false);
      }
    }
  }

  void _handleError(dynamic error) {
    final errorText = error.toString();
    if (errorText.contains('Too Many Requests') || errorText.contains('429')) {
      setError('Too many searches. Please wait a moment, then try again.');
    } else if (errorText.contains('TimeoutException')) {
      setError(
          'Search took too long. Please check your internet and try again.');
    } else {
      setError('Something went wrong while loading anime.');
    }
  }

  void clearFilters() {
    _onMyListOnly = false;
    _selectedStatusLabel = null;
    _selectedGenreLabel = null;
    _selectedFormatLabel = null;
    _selectedSortLabel = null;
    _rerunSearchWithCurrentFilters();
  }

  void toggleOnMyListFilter() {
    _onMyListOnly = !_onMyListOnly;
    notifyListeners();
  }

  void setStatusFilterByLabel(String value) {
    _selectedStatusLabel = _statusOptions[value] == null ? null : value;
    _rerunSearchWithCurrentFilters();
  }

  void setGenreFilterByLabel(String value) {
    _selectedGenreLabel = _genreOptions[value] == null ? null : value;
    _rerunSearchWithCurrentFilters();
  }

  void setFormatFilterByLabel(String value) {
    _selectedFormatLabel = _formatOptions[value] == null ? null : value;
    _rerunSearchWithCurrentFilters();
  }

  void setSortFilterByLabel(String value) {
    _selectedSortLabel = value == 'Default' ? null : value;
    _rerunSearchWithCurrentFilters();
  }

  String? get activeFilterResultsTitle {
    if (_selectedGenreLabel != null) return '$_selectedGenreLabel Anime';
    if (_selectedStatusLabel != null) return '$_selectedStatusLabel Anime';
    if (_selectedFormatLabel != null) return '$_selectedFormatLabel Anime';
    if (_selectedSortLabel != null && _selectedSortLabel != 'Default')
      return '$_selectedSortLabel Anime';
    if (_onMyListOnly) return 'Anime On My List';
    return null;
  }

  void _rerunSearchWithCurrentFilters() {
    _debounce?.cancel();
    final input = _searchText.trim();

    if (input.isEmpty || input.length < _minimumSearchLength) {
      if (hasActiveFilters) {
        loadAnimeByActiveFilters();
      } else {
        _searchRequestId++;
        _searchResults = [];
        _relatedResults = [];
        _hasSearched = false;
        clearErrors();
        setBusy(false);
        notifyListeners();
      }
      return;
    }

    setBusy(true);
    searchAnime(input);
  }

  Map<String, List<dynamic>> _groupSearchResults(
      List<dynamic> results, String input) {
    final startsWithResults = <dynamic>[];
    final containsResults = <dynamic>[];

    for (final anime in results) {
      if (_anyTitleStartsWithSearch(anime, input)) {
        startsWithResults.add(anime);
      } else if (_anyTitleContainsSearch(anime, input)) {
        containsResults.add(anime);
      } else {
        startsWithResults.add(anime);
      }
    }

    startsWithResults.sort((a, b) =>
        _getDisplayedTitle(a).length.compareTo(_getDisplayedTitle(b).length));
    containsResults.sort((a, b) => _cleanText(_getDisplayedTitle(a))
        .compareTo(_cleanText(_getDisplayedTitle(b))));

    return {'startsWith': startsWithResults, 'contains': containsResults};
  }

  List<String> _getAllTitles(dynamic anime) {
    final title = anime['title'];
    return [
      if (title?['english'] != null) title['english'].toString(),
      if (title?['romaji'] != null) title['romaji'].toString(),
      if (title?['native'] != null) title['native'].toString(),
    ].where((t) => t.trim().isNotEmpty).toSet().toList();
  }

  String _getDisplayedTitle(dynamic anime) {
    final titles = _getAllTitles(anime);
    return titles.isEmpty ? 'No title' : titles.first;
  }

  bool _anyTitleStartsWithSearch(dynamic anime, String input) {
    final cleanedInput = _cleanText(input);
    if (cleanedInput.isEmpty) return false;
    return _getAllTitles(anime)
        .any((title) => _cleanText(title).startsWith(cleanedInput));
  }

  bool _anyTitleContainsSearch(dynamic anime, String input) {
    final cleanedInput = _cleanText(input);
    if (cleanedInput.isEmpty) return false;
    return _getAllTitles(anime)
        .any((title) => _cleanText(title).contains(cleanedInput));
  }

  String _cleanText(String value) =>
      value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

  List<dynamic> _removeDuplicateAnime(List<dynamic> animeList) {
    final uniqueAnime = <dynamic>[];
    final seenIds = <String>{};

    for (final anime in animeList) {
      final id = anime['id']?.toString();
      if (id != null && seenIds.add(id)) {
        uniqueAnime.add(anime);
      }
    }
    return uniqueAnime;
  }
}
