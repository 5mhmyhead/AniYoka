import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:aniyoka/app/app.locator.dart';
import 'package:aniyoka/services/anilist_service.dart';

class ExploreViewModel extends BaseViewModel {
  final _anilistService = locator<AniListService>();

  final TextEditingController searchController = TextEditingController();

  Timer? _debounce;
  int _searchRequestId = 0;

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

  String? get _apiStatus {
    if (_selectedStatusLabel == null) return null;
    return _statusOptions[_selectedStatusLabel];
  }

  String? get _apiGenre {
    if (_selectedGenreLabel == null) return null;
    return _genreOptions[_selectedGenreLabel];
  }

  String? get _apiFormat {
    if (_selectedFormatLabel == null) return null;
    return _formatOptions[_selectedFormatLabel];
  }

  String get _apiSort {
    return _sortOptions[_selectedSortLabel ?? 'Default'] ?? 'SEARCH_MATCH';
  }

  ExploreViewModel() {
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final input = searchController.text.trim();

    _searchText = input;
    _debounce?.cancel();

    if (input.isEmpty) {
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

    _debounce = Timer(
      const Duration(milliseconds: 400),
      () {
        searchAnime(input);
      },
    );
  }

  Future<void> searchAnime(String input) async {
    final currentInput = input.trim();
    final int requestId = ++_searchRequestId;

    if (currentInput.isEmpty) {
      return;
    }

    try {
      clearErrors();

      final results = await _anilistService.searchAnime(
        currentInput,
        status: _apiStatus,
        genre: _apiGenre,
        format: _apiFormat,
        sort: _apiSort,
      );

      if (requestId != _searchRequestId || currentInput != _searchText) {
        return;
      }

      final groupedResults = _groupSearchResults(
        _removeDuplicateAnime(results),
        currentInput,
      );

      _searchResults = groupedResults['startsWith']!;
      _relatedResults = groupedResults['contains']!;
      _hasSearched = true;
    } catch (e) {
      if (requestId == _searchRequestId && currentInput == _searchText) {
        _searchResults = [];
        _relatedResults = [];
        _hasSearched = true;
        setError(e.toString());
      }
    }

    if (requestId == _searchRequestId && currentInput == _searchText) {
      setBusy(false);
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

    // This is currently visual only. Connect this later to your own
    // watchlist/bookmark storage or AniList user list.
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

  void _rerunSearchWithCurrentFilters() {
    _debounce?.cancel();

    if (_searchText.trim().isEmpty) {
      notifyListeners();
      return;
    }

    setBusy(true);
    searchAnime(_searchText);
  }

  Map<String, List<dynamic>> _groupSearchResults(
    List<dynamic> results,
    String input,
  ) {
    final startsWithResults = <dynamic>[];
    final containsResults = <dynamic>[];

    for (final anime in results) {
      final displayedTitle = _getDisplayedTitle(anime);

      if (_titleStartsWithSearch(displayedTitle, input)) {
        startsWithResults.add(anime);
      } else if (_titleContainsSearch(displayedTitle, input)) {
        containsResults.add(anime);
      }
    }

    startsWithResults.sort((a, b) {
      final titleA = _cleanText(_getDisplayedTitle(a));
      final titleB = _cleanText(_getDisplayedTitle(b));

      return titleA.length.compareTo(titleB.length);
    });

    return {
      'startsWith': startsWithResults,
      'contains': containsResults,
    };
  }

  List<dynamic> _removeDuplicateAnime(List<dynamic> animeList) {
    final uniqueAnime = <dynamic>[];
    final seenIds = <String>{};

    for (final anime in animeList) {
      final id = anime['id']?.toString();

      if (id == null) continue;

      if (seenIds.add(id)) {
        uniqueAnime.add(anime);
      }
    }

    return uniqueAnime;
  }

  String _getDisplayedTitle(dynamic anime) {
    return anime['title']?['english'] ??
        anime['title']?['romaji'] ??
        anime['title']?['native'] ??
        'No title';
  }

  bool _titleStartsWithSearch(String title, String input) {
    final cleanedTitle = _cleanText(title);
    final cleanedInput = _cleanText(input);

    return cleanedTitle.startsWith(cleanedInput);
  }

  bool _titleContainsSearch(String title, String input) {
    final cleanedTitle = _cleanText(title);
    final cleanedInput = _cleanText(input);

    return cleanedTitle.contains(cleanedInput);
  }

  String _cleanText(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  void clearSearch() {
    searchController.clear();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }
}
