import 'package:aniyoka/services/anilist_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:aniyoka/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:aniyoka/app/app.locator.dart';

class HomeViewModel extends BaseViewModel {
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
    } catch (e) {
      setError(e.toString());
    }
    setBusy(false);
  }

  void onAnimeTap(int id) {
    _navigationService.navigateToAnimeInfoView(animeId: id, transition: TransitionsBuilders.fadeIn);
  }
}
