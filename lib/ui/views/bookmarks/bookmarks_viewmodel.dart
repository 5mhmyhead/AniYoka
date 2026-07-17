import 'package:aniyoka/app/app.locator.dart';
import 'package:aniyoka/services/bookmark_service.dart';
import 'package:stacked/stacked.dart';

enum BookmarkSort { title, recentlySaved, oldestSaved }

extension BookmarkSortLabel on BookmarkSort {
  String get label {
    switch (this) {
      case BookmarkSort.title:
        return 'Title';
      case BookmarkSort.recentlySaved:
        return 'Recently Saved';
      case BookmarkSort.oldestSaved:
        return 'Oldest Saved';
    }
  }
}

class BookmarksViewModel extends BaseViewModel {
  final _bookmarkService = locator<BookmarkService>();

  List<Map<String, dynamic>> _bookmarks = [];
  bool _hasLoaded = false;
  bool get hasLoaded => _hasLoaded;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  BookmarkSort _sort = BookmarkSort.title;
  BookmarkSort get sort => _sort;

  bool _sortAscending = true;
  bool get sortAscending => _sortAscending;

  List<String> get categories => const ['All Bookmarks'];

  void setSearch(String query) {
    _searchQuery = query;
    rebuildUi();
  }

  void clearSearch() {
    _searchQuery = '';
    rebuildUi();
  }

  void setSort(BookmarkSort newSort, {bool ascending = true}) {
    _sort = newSort;
    _sortAscending = ascending;
    rebuildUi();
  }

  List<Map<String, dynamic>> _applySearchAndSort(
      List<Map<String, dynamic>> list) {
    var result = list;

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((b) {
        final title = (b['title']?['english'] ?? b['title']?['romaji'] ?? '')
            .toLowerCase();
        return title.contains(q);
      }).toList();
    }

    switch (_sort) {
      case BookmarkSort.title:
        result.sort((a, b) {
          final ta = a['title']?['english'] ?? a['title']?['romaji'] ?? '';
          final tb = b['title']?['english'] ?? b['title']?['romaji'] ?? '';
          return ta.compareTo(tb);
        });
        break;
      case BookmarkSort.recentlySaved:
        result.sort((a, b) => DateTime.parse(b['savedAt'])
            .compareTo(DateTime.parse(a['savedAt'])));
        break;
      case BookmarkSort.oldestSaved:
        result.sort((a, b) => DateTime.parse(a['savedAt'])
            .compareTo(DateTime.parse(b['savedAt'])));
        break;
    }

    // apply toggle on top of the base ordering above
    if (!_sortAscending) {
      result = result.reversed.toList();
    }

    return result;
  }

  List<Map<String, dynamic>> get allBookmarks =>
      _applySearchAndSort(_bookmarks);

  List<Map<String, dynamic>> bookmarksForCategory(String category) {
    return allBookmarks;
  }

  Future<void> loadBookmarks() async {
    _bookmarks = await _bookmarkService.getBookmarks();
    _hasLoaded = true;
    rebuildUi();
  }

  Future<void> removeBookmark(int id) async {
    await _bookmarkService.removeBookmark(id);
    _bookmarks.removeWhere((b) => b['id'] == id);
    rebuildUi();
  }
}
