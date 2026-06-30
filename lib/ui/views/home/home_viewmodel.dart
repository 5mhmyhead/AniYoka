import 'package:stacked/stacked.dart';
import 'package:aniyoka/app/app.locator.dart';
import 'package:aniyoka/services/anilist_service.dart';

class HomeViewModel extends BaseViewModel {
  final _anilistService = locator<AniListService>();

  List<dynamic> _trendingAnime = [];
  List<dynamic> get popularAnime => _trendingAnime;

  Future<void> loadTrendingAnime() async {
    setBusy(true);
    try {
      _trendingAnime = await _anilistService.getTrendingAnime();
      print('Loaded ${_trendingAnime.length} anime');
    } catch (e) {
      print('Error: $e');
      setError(e.toString());
    }
    setBusy(false);
  }
}
