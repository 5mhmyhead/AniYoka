import 'package:aniyoka/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:aniyoka/models/media_model.dart';
import 'package:aniyoka/services/anilist_service.dart';

class DiscoverTabViewModel extends BaseViewModel {
  final _aniListService = locator<AniListService>();

  List<Media> _trendingAnime = [];
  List<Media> get trendingAnime => _trendingAnime;

  List<Media> _thisSeasonAnime = [];
  List<Media> get thisSeasonAnime => _thisSeasonAnime;

  List<Media> _nextSeasonAnime = [];
  List<Media> get nextSeasonAnime => _nextSeasonAnime;

  Future<void> initialise() async {
    setBusy(true);

    try {
      await Future.wait([
        _fetchTrendingAnime(),
        _fetchThisSeasonAnime(),
        _fetchNextSeasonAnime(),
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

  Future<void> _fetchThisSeasonAnime() async {
    _thisSeasonAnime = await _aniListService.fetchThisSeasonAnime();
  }

  Future<void> _fetchNextSeasonAnime() async {
    _nextSeasonAnime = await _aniListService.fetchNextSeasonAnime();
  }
}
