import 'package:aniyoka/app/app.locator.dart';
import 'package:aniyoka/services/bookmark_service.dart';
import 'package:stacked/stacked.dart';

class BookmarksViewModel extends BaseViewModel {
  final _bookmarkService = locator<BookmarkService>();

  List<Map<String, dynamic>> _bookmarks = [];

  // all bookmarks sorted by alphabetical
  List<Map<String, dynamic>> get allBookmarks {
    final sorted = [..._bookmarks];
    sorted.sort((a, b) {
      final titleA = a['title']['english'] ?? a['title']['romaji'] ?? '';
      final titleB = b['title']['english'] ?? b['title']['romaji'] ?? '';
      return titleA.compareTo(titleB);
    });
    return sorted;
  }

  // all bookmarks sorted by most recently saved
  List<Map<String, dynamic>> get recentlySaved {
    final sorted = [..._bookmarks];
    sorted.sort((a, b) =>
        DateTime.parse(b['savedAt']).compareTo(DateTime.parse(a['savedAt'])));
    return sorted;
  }

  // all bookmarks sorted by oldest saved
  List<Map<String, dynamic>> get oldestSaves {
    final sorted = [..._bookmarks];
    sorted.sort((a, b) =>
        DateTime.parse(a['savedAt']).compareTo(DateTime.parse(b['savedAt'])));
    return sorted;
  }

  Future<void> loadBookmarks() async {
    setBusy(true);
    _bookmarks = await _bookmarkService.getBookmarks();
    setBusy(false);
  }

  Future<void> removeBookmark(int id) async {
    await _bookmarkService.removeBookmark(id);
    _bookmarks.removeWhere((b) => b['id'] == id);
    rebuildUi();
  }
}
