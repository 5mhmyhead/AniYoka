import 'package:aniyoka/app/app.locator.dart';
import 'package:aniyoka/services/anilist_service.dart';
import 'package:aniyoka/utils/anime_list_helper.dart';
import 'package:stacked/stacked.dart';

class AnimeListViewModel extends BaseViewModel {
  final _anilistService = locator<AniListService>();
  final AnimeListFilter filter;

  AnimeListViewModel({required this.filter});

  List<dynamic> _animeList = [];
  List<dynamic> get animeList => _animeList;

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> loadAnimeList() async {
    setBusy(true);
    _currentPage = 1;
    _hasNextPage = true;
    try {
      final result = await _anilistService.getAnimeList(
        type: filter.type,
        page: _currentPage,
        season: filter.season,
      );
      _animeList = result;
    } catch (e) {
      setError(e.toString());
    }
    setBusy(false);
  }

  Future<void> loadMore() async {
    if (!_hasNextPage || _isLoadingMore) return;
    _isLoadingMore = true;
    rebuildUi();
    try {
      _currentPage++;
      final result = await _anilistService.getAnimeList(
        type: filter.type,
        page: _currentPage,
        season: filter.season,
      );
      _animeList = [..._animeList, ...result];
    } catch (e) {
      _currentPage--;
    }
    _isLoadingMore = false;
    rebuildUi();
  }
}
