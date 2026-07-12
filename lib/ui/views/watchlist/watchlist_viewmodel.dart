import 'package:aniyoka/app/app.locator.dart';
import 'package:aniyoka/services/watchlist_service.dart';
import 'package:stacked/stacked.dart';

class WatchlistViewModel extends BaseViewModel {
  final _watchlistService = locator<WatchlistService>();

  List<WatchlistEntry> _entries = [];
  List<WatchlistEntry> get allAnime => _entries;
  List<WatchlistEntry> get completed => _entries.where((e) => e.status == 'COMPLETED').toList();
  List<WatchlistEntry> get rewatching => _entries.where((e) => e.status == 'REWATCHING').toList();
  List<WatchlistEntry> get favourites => _entries.where((e) => e.status == 'FAVOURITE').toList();

  bool _hasLoaded = false;
  bool get hasLoaded => _hasLoaded;

  Future<void> loadWatchlist() async {
    _entries = await _watchlistService.getWatchlist();
    _hasLoaded = true;
    rebuildUi();
  }

  Future<void> incrementEpisode(int id) async {
    final entry = _entries.firstWhere((e) => e.id == id);
    if (entry.totalEpisodes != null && entry.episodesWatched >= entry.totalEpisodes!) return;
    entry.episodesWatched++;
    await _watchlistService.addOrUpdate(entry);
    rebuildUi();
  }

  Future<void> decrementEpisode(int id) async {
    final entry = _entries.firstWhere((e) => e.id == id);
    if (entry.episodesWatched <= 0) return;
    entry.episodesWatched--;
    await _watchlistService.addOrUpdate(entry);
    rebuildUi();
  }

  Future<void> removeEntry(int id) async {
    await _watchlistService.remove(id);
    _entries.removeWhere((e) => e.id == id);
    rebuildUi();
  }
}