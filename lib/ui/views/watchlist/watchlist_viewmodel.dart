import 'package:aniyoka/app/app.locator.dart';
import 'package:aniyoka/services/watchlist_service.dart';
import 'package:stacked/stacked.dart';

enum WatchlistSort { title, progress, recentlyAdded, oldestAdded }

extension WatchlistSortLabel on WatchlistSort {
  String get label {
    switch (this) {
      case WatchlistSort.title: return 'Title';
      case WatchlistSort.progress: return 'Progress';
      case WatchlistSort.recentlyAdded: return 'Recently Added';
      case WatchlistSort.oldestAdded: return 'Oldest Added';
    }
  }
}

class WatchlistViewModel extends BaseViewModel {
  final _watchlistService = locator<WatchlistService>();

  List<String> get categories => const ['All Anime'];

  static const List<String> statusOptions = [
    'Watching',
    'Completed',
    'Paused',
    'Dropped',
    'Rewatching',
  ];

  List<WatchlistEntry> get allAnime => _applySearchAndSort(_entries);

  List<WatchlistEntry> _entries = [];
  bool _hasLoaded = false;
  bool get hasLoaded => _hasLoaded;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  bool get isSearching => _searchQuery.isNotEmpty;

  WatchlistSort _sort = WatchlistSort.title;
  WatchlistSort get sort => _sort;

  bool _sortAscending = true;
  bool get sortAscending => _sortAscending;

  Set<String> _selectedStatuses = {};
  Set<String> get selectedStatuses => _selectedStatuses;

  void setSearch(String query) {
    _searchQuery = query;
    rebuildUi();
  }

  void clearSearch() {
    _searchQuery = '';
    rebuildUi();
  }

  void setSort(WatchlistSort newSort, {bool ascending = true}) {
    _sort = newSort;
    _sortAscending = ascending;
    rebuildUi();
  }

  void setStatuses(Set<String> statuses) {
    _selectedStatuses = statuses;
    rebuildUi();
  }

  List<WatchlistEntry> _applySearchAndSort(List<WatchlistEntry> list) {
    var result = list;

    // apply search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((e) {
        final title = (e.animeData['title']?['english'] ??
            e.animeData['title']?['romaji'] ?? '').toLowerCase();
        return title.contains(q);
      }).toList();
    }

    // apply status filter
    if (_selectedStatuses.isNotEmpty) {
      result = result
          .where((e) => _selectedStatuses.any((s) => s.toUpperCase() == e.status))
          .toList();
    }

    // apply sort
    switch (_sort) {
      case WatchlistSort.title:
        result.sort((a, b) {
          final ta = a.animeData['title']?['english'] ?? a.animeData['title']?['romaji'] ?? '';
          final tb = b.animeData['title']?['english'] ?? b.animeData['title']?['romaji'] ?? '';
          return ta.compareTo(tb);
        });
        break;
      case WatchlistSort.progress:
        result.sort((a, b) {
          final pa = a.totalEpisodes != null && a.totalEpisodes! > 0
              ? a.episodesWatched / a.totalEpisodes!
              : 0.0;
          final pb = b.totalEpisodes != null && b.totalEpisodes! > 0
              ? b.episodesWatched / b.totalEpisodes!
              : 0.0;
          return pb.compareTo(pa);
        });
        break;
      case WatchlistSort.recentlyAdded:
        result.sort((a, b) => b.addedAt.compareTo(a.addedAt));
        break;
      case WatchlistSort.oldestAdded:
        result.sort((a, b) => a.addedAt.compareTo(b.addedAt));
        break;
    }

    // apply toggle on top of the base ordering above
    if (!_sortAscending) {
      result = result.reversed.toList();
    }

    return result;
  }

  List<WatchlistEntry> entriesForCategory(String category) {
    return allAnime;
  }

  Future<void> loadWatchlist() async {
    _entries = await _watchlistService.getWatchlist();
    _hasLoaded = true;
    rebuildUi();
  }

  Future<bool> incrementEpisode(int id) async {
    final entry = _entries.firstWhere((e) => e.id == id);
    final cap = entry.episodeCap;
    if (cap != null && entry.episodesWatched >= cap) return false;
    entry.episodesWatched++;
    bool justCompleted = false;
    if (entry.totalEpisodes != null && entry.episodesWatched >= entry.totalEpisodes!) {
      entry.status = 'COMPLETED';
      justCompleted = true;
    }
    await _watchlistService.addOrUpdate(entry);
    rebuildUi();
    return justCompleted;
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