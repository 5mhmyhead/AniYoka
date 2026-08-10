import 'package:aniyoka/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:aniyoka/models/anime_model.dart';
import 'package:aniyoka/services/anilist_service.dart';

class DiscoverTabViewModel extends BaseViewModel {
  final _aniListService = locator<AniListService>();

  List<Anime> _trendingAnime = [];
  List<Anime> get trendingAnime => _trendingAnime;

  Future<void> initialise() async {
    await runBusyFuture(
      _fetchTrendingAnime(),
      throwException: false,
    );
  }

  Future<void> _fetchTrendingAnime() async {
    _trendingAnime = await _aniListService.fetchTrendingAnime();
  }
}