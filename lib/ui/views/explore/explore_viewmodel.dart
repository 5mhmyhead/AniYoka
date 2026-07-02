import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:aniyoka/app/app.locator.dart';
import 'package:aniyoka/services/anilist_service.dart';

class ExploreViewModel extends BaseViewModel {
  final _anilistService = locator<AniListService>();

  final TextEditingController searchController = TextEditingController();

  Timer? _debounce;

  String _searchText = '';
  String get searchText => _searchText;

  List<dynamic> _searchResults = [];
  List<dynamic> get searchResults => _searchResults;

  List<dynamic> _relatedResults = [];
  List<dynamic> get relatedResults => _relatedResults;

  bool _hasSearched = false;
  bool get hasSearched => _hasSearched;

  ExploreViewModel() {
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final input = searchController.text.trim();

    _searchText = input;
    _debounce?.cancel();

    if (input.isEmpty) {
      _searchResults = [];
      _relatedResults = [];
      _hasSearched = false;
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

    try {
      clearErrors();

      final normalSearchResults =
          await _anilistService.searchAnime(currentInput);

      final popularAnimeResults =
          await _anilistService.getPopularAnimeForSearchSuggestions();

      if (currentInput != _searchText) {
        return;
      }

      final firstCombinedResults = _removeDuplicateAnime([
        ...normalSearchResults,
        ...popularAnimeResults,
      ]);

      final bestPrefixTitle = _findBestPrefixTitle(
        firstCombinedResults,
        currentInput,
      );

      List<dynamic> expandedSearchResults = [];

      if (bestPrefixTitle != null &&
          _cleanText(bestPrefixTitle) != _cleanText(currentInput)) {
        expandedSearchResults =
            await _anilistService.searchAnime(bestPrefixTitle);
      }

      if (currentInput != _searchText) {
        return;
      }

      final combinedResults = _removeDuplicateAnime([
        ...expandedSearchResults,
        ...normalSearchResults,
        ...popularAnimeResults,
      ]);

      final groupedResults = _groupSearchResults(
        combinedResults,
        currentInput,
      );

      _searchResults = groupedResults['startsWith']!;
      _relatedResults = groupedResults['contains']!;
      _hasSearched = true;
    } catch (e) {
      if (currentInput == _searchText) {
        setError(e.toString());
      }
    }

    if (currentInput == _searchText) {
      setBusy(false);
    }
  }

  String? _findBestPrefixTitle(
    List<dynamic> results,
    String input,
  ) {
    final matchingTitles = <String>[];

    for (final anime in results) {
      final displayedTitle = _getDisplayedTitle(anime);

      if (_titleStartsWithSearch(displayedTitle, input)) {
        matchingTitles.add(displayedTitle);
      }
    }

    if (matchingTitles.isEmpty) {
      return null;
    }

    matchingTitles.sort((a, b) {
      final titleA = _cleanText(a);
      final titleB = _cleanText(b);

      return titleA.length.compareTo(titleB.length);
    });

    return matchingTitles.first;
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
