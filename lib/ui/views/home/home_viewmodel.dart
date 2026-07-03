import 'package:aniyoka/services/anilist_service.dart';
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
      // run all query fetches
      final results = await Future.wait([
        _anilistService.getPopularAnime(),
        _anilistService.getNewlyAddedAnime(),
        _anilistService.getNextSeasonAnime(),
        _anilistService.getThisSeasonAnime(),
        _anilistService.getAiringSoonAnime(),
      ]);

      _popularAnime = results[0];
      _newlyAdded = results[1];
      _nextSeason = results[2];
      _thisSeason = results[3];
      _airingSoon = results[4];
      // start autoscroll behaviour of popular anime
      startAutoScroll();
    } catch (e) {
      setError(e.toString());
    }
    setBusy(false);
  }

  void onAnimeTap(int id) {
    _navigationService.navigateToAnimeInfoView(animeId: id, transition: TransitionsBuilders.fadeIn);
  }

  void startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!pageController.hasClients) return;
      final nextPage = (pageController.page!.round() + 1) % _popularAnime.length;
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
    stopAutoScroll();
    pageController.dispose();
    super.dispose();
  }

  Future<void> refreshData() async {
    stopAutoScroll();
    await loadHomeData();
  }
}
