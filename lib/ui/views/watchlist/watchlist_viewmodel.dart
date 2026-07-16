import 'package:aniyoka/app/app.locator.dart';
import 'package:aniyoka/services/recent_activity_service.dart';
import 'package:aniyoka/services/watchlist_service.dart';
import 'package:stacked/stacked.dart';

enum WatchlistSort { title, progress, recentlyAdded, oldestAdded }

extension WatchlistSortLabel on WatchlistSort {
  String get label {
    switch (this) {
      case WatchlistSort.title:
        return 'Title';
      case WatchlistSort.progress:
        return 'Progress';
      case WatchlistSort.recentlyAdded:
        return 'Recently Added';
      case WatchlistSort.oldestAdded:
        return 'Oldest Added';
    }
  }
}

class WatchlistViewModel extends BaseViewModel {
  final WatchlistService _watchlistService = locator<WatchlistService>();
  final RecentActivityService _recentActivityService = RecentActivityService();

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
    var result = List<WatchlistEntry>.from(list);

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((entry) {
        return _titleFor(entry).toLowerCase().contains(query);
      }).toList();
    }

    if (_selectedStatuses.isNotEmpty) {
      result = result.where((entry) {
        return _selectedStatuses.any(
          (status) => _normalizeStatus(status) == entry.status,
        );
      }).toList();
    }

    switch (_sort) {
      case WatchlistSort.title:
        result.sort(
          (a, b) => _titleFor(a).toLowerCase().compareTo(
                _titleFor(b).toLowerCase(),
              ),
        );
        break;
      case WatchlistSort.progress:
        result.sort((a, b) {
          final progressA = a.totalEpisodes != null && a.totalEpisodes! > 0
              ? a.episodesWatched / a.totalEpisodes!
              : 0.0;
          final progressB = b.totalEpisodes != null && b.totalEpisodes! > 0
              ? b.episodesWatched / b.totalEpisodes!
              : 0.0;
          return progressB.compareTo(progressA);
        });
        break;
      case WatchlistSort.recentlyAdded:
        result.sort((a, b) => b.addedAt.compareTo(a.addedAt));
        break;
      case WatchlistSort.oldestAdded:
        result.sort((a, b) => a.addedAt.compareTo(b.addedAt));
        break;
    }

    if (!_sortAscending) {
      result = result.reversed.toList();
    }

    return result;
  }

  List<WatchlistEntry> entriesForCategory(String category) => allAnime;

  Future<void> loadWatchlist() async {
    _entries = await _watchlistService.getWatchlist();
    _hasLoaded = true;
    rebuildUi();
  }

  Future<bool> incrementEpisode(int id) async {
    final entry = _entryFor(id);
    final episodeCap = entry.episodeCap;

    if (episodeCap != null && entry.episodesWatched >= episodeCap) {
      return false;
    }

    entry.episodesWatched++;

    var justCompleted = false;
    if (entry.totalEpisodes != null &&
        entry.totalEpisodes! > 0 &&
        entry.episodesWatched >= entry.totalEpisodes!) {
      entry.episodesWatched = entry.totalEpisodes!;
      entry.status = 'COMPLETED';
      justCompleted = true;
    }

    await _watchlistService.addOrUpdate(entry);

    if (justCompleted) {
      await _recordActivity(
        entry,
        action: 'COMPLETED',
        description: 'Completed',
      );
    } else if (_normalizeStatus(entry.status) == 'WATCHING') {
      await _recordActivity(
        entry,
        action: 'WATCHING',
        description: _capitalizeFirst(_progressText(entry)),
      );
    }

    rebuildUi();
    return justCompleted;
  }

  Future<void> decrementEpisode(int id) async {
    final entry = _entryFor(id);

    if (entry.episodesWatched <= 0) {
      return;
    }

    entry.episodesWatched--;
    await _watchlistService.addOrUpdate(entry);

    if (_normalizeStatus(entry.status) == 'WATCHING') {
      await _recordActivity(
        entry,
        action: 'WATCHING',
        description: _capitalizeFirst(_progressText(entry)),
      );
    }

    rebuildUi();
  }

  Future<void> removeEntry(int id) async {
    final entry = _entryFor(id);

    await _watchlistService.remove(id);
    _entries.removeWhere((item) => item.id == id);

    await _recordActivity(
      entry,
      action: 'REMOVED',
      description: 'Removed from Watch List',
    );

    rebuildUi();
  }

  WatchlistEntry _entryFor(int id) {
    return _entries.firstWhere((entry) => entry.id == id);
  }

  String _titleFor(WatchlistEntry entry) {
    final title = entry.animeData['title'];

    if (title is Map) {
      return (title['english'] ??
              title['romaji'] ??
              title['native'] ??
              'Unknown anime')
          .toString();
    }

    return 'Unknown anime';
  }

  String? _coverFor(WatchlistEntry entry) {
    final coverImage = entry.animeData['coverImage'];

    if (coverImage is Map) {
      final imageUrl = coverImage['large'] ?? coverImage['medium'];
      final value = imageUrl?.toString() ?? '';
      return value.isEmpty ? null : value;
    }

    return null;
  }

  String _progressText(WatchlistEntry entry) {
    final total = entry.totalEpisodes;

    if (total == null || total <= 0) {
      return 'episode ${entry.episodesWatched}';
    }

    return 'episode ${entry.episodesWatched} of $total';
  }

  String _normalizeStatus(String status) {
    return status.trim().replaceAll('_', '').replaceAll(' ', '').toUpperCase();
  }

  String _capitalizeFirst(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  Future<void> _recordActivity(
    WatchlistEntry entry, {
    required String action,
    required String description,
  }) {
    return _recentActivityService.addActivity(
      animeId: entry.id,
      title: _titleFor(entry),
      action: action,
      description: description,
      coverImageUrl: _coverFor(entry),
    );
  }
}
