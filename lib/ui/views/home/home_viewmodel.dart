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
}
