import 'package:aniyoka/app/app.locator.dart';
import 'package:aniyoka/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:aniyoka/models/media_model.dart';
import 'package:aniyoka/services/anilist_service.dart';
import 'package:stacked_services/stacked_services.dart';

class DiscoverTabViewModel extends BaseViewModel {
  final _aniListService = locator<AniListService>();
  final _navigationService = locator<NavigationService>();

  List<Media> _trendingAnime = [];
  List<Media> get trendingAnime => _trendingAnime;

  List<Media> _trendingManga = [];
  List<Media> get trendingManga => _trendingManga;

  List<Media> _thisSeasonAnime = [];
  List<Media> get thisSeasonAnime => _thisSeasonAnime;

  List<Media> _nextSeasonAnime = [];
  List<Media> get nextSeasonAnime => _nextSeasonAnime;

  List<Media> _highestRatedManga = [];
  List<Media> get highestRatedManga => _highestRatedManga;

  Future<void> initialise() async {
    setBusy(true);

    try {
      await Future.wait([
        _fetchTrendingAnime(),
        _fetchTrendingManga(),
        _fetchThisSeasonAnime(),
        _fetchNextSeasonAnime(),
        _fetchHighestRatedManga(),
      ]);
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
    }
  }

  Future<void> _fetchTrendingAnime() async {
    _trendingAnime = await _aniListService.fetchTrendingAnime();
  }

  Future<void> _fetchTrendingManga() async {
    _trendingManga = await _aniListService.fetchTrendingManga();
  }

  Future<void> _fetchThisSeasonAnime() async {
    _thisSeasonAnime = await _aniListService.fetchThisSeasonAnime();
  }

  Future<void> _fetchNextSeasonAnime() async {
    _nextSeasonAnime = await _aniListService.fetchNextSeasonAnime();
  }

  Future<void> _fetchHighestRatedManga() async {
    _highestRatedManga = await _aniListService.fetchHighestRatedManga();
  }

  void onMediaTap(int id) {
    _navigationService.navigateToMediaInfoView(mediaId: id);
  }

  void onMediaLongPress(int id) {
    // TODO: change this to have another long press functionality
    _navigationService.navigateToMediaInfoView(mediaId: id);
  }
}
