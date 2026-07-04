import 'package:aniyoka/services/anilist_service.dart';
import 'package:aniyoka/utils/genre_helper.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:aniyoka/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:aniyoka/app/app.locator.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomeViewModel extends BaseViewModel {
  // scroll behaviour of popular now in home page
  PageController pageController = PageController(viewportFraction: 1);
  Timer? _autoScrollTimer;

  final _anilistService = locator<AniListService>();
  final _navigationService = locator<NavigationService>();

  List<dynamic> _popularAnime = [];
  List<dynamic> get popularAnime => _popularAnime;

  List<dynamic> _newlyAdded = [];
  List<dynamic> get newlyAdded => _newlyAdded;

  List<dynamic> _nextSeason = [];
  List<dynamic> get nextSeason => _nextSeason;

  List<dynamic> _thisSeason = [];
  List<dynamic> get thisSeason => _thisSeason;

  List<dynamic> _airingSoon = [];
  List<dynamic> get airingSoon => _airingSoon;

  Map<String, List<dynamic>> _genreAnime = {};
  Map<String, List<dynamic>> get genreAnime => _genreAnime;

  GenreFilter _genreFilter = GenreFilter.popularity;
  GenreFilter get genreFilter => _genreFilter;

  bool _genresLoaded = false;
  bool get genresLoaded => _genresLoaded;

  bool _isGenresBusy = false;
  bool get isGenresBusy => _isGenresBusy;

  Future<void> loadHomeData() async {
    setBusy(true);
    try {
      _popularAnime = await _anilistService.getPopularAnime();
      rebuildUi();

      _thisSeason = await _anilistService.getThisSeasonAnime();
      rebuildUi();

      _nextSeason = await _anilistService.getNextSeasonAnime();
      rebuildUi();

      _newlyAdded = await _anilistService.getNewlyAddedAnime();
      rebuildUi();

      _airingSoon = await _anilistService.getAiringSoonAnime();
      rebuildUi();
    } catch (e) {
      setError(e.toString());
    }
    setBusy(false);
  }

  Future<void> setGenreFilter(GenreFilter filter) async {
    if (_genreFilter == filter) return;
    _genreFilter = filter;
    resetGenres();
    await loadGenres();
  }

  Future<void> loadGenres() async {
    if (_genresLoaded) return;
    _isGenresBusy = true;

    try {
      for (final genre in GenreHelper.topGenres) {
        await Future.delayed(const Duration(milliseconds: 300));
        final result =
            await _anilistService.getAnimeByGenre(genre, _genreFilter);
        _genreAnime[genre] = result;
        rebuildUi();
      }
    } catch (e) {
      setError(e.toString());
    }

    _genresLoaded = true;
    _isGenresBusy = false;
    rebuildUi();
  }

  void onAnimeTap(int id) {
    _navigationService.navigateToAnimeInfoView(
        animeId: id, transition: TransitionsBuilders.fadeIn);
  }

  void startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 7), (_) {
      if (!pageController.hasClients) return;
      final nextPage =
          (pageController.page!.round() + 1) % _popularAnime.length;
      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void stopAutoScroll() {
    _autoScrollTimer?.cancel();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  Future<void> refreshData() async {
    _popularAnime = [];
    _thisSeason = [];
    _nextSeason = [];
    _newlyAdded = [];
    _airingSoon = [];
    stopAutoScroll();
    await loadHomeData();
  }

  void resetGenres() {
    _genresLoaded = false;
    _genreAnime = {};
    rebuildUi();
  }
}
