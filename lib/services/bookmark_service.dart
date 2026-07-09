import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  static const String _key = 'bookmarks';

  // each bookmark stored as a map with enough to display the card
  Future<List<Map<String, dynamic>>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((e) => Map<String, dynamic>.from(jsonDecode(e))).toList();
  }

  Future<void> addBookmark(Map<String, dynamic> anime) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();
    final exists = bookmarks.any((b) => b['id'] == anime['id']);
    if (exists) return;
    bookmarks.add(anime);
    await prefs.setStringList(
        _key, bookmarks.map((b) => jsonEncode(b)).toList());
  }

  Future<void> removeBookmark(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();
    bookmarks.removeWhere((b) => b['id'] == id);
    await prefs.setStringList(
        _key, bookmarks.map((b) => jsonEncode(b)).toList());
  }

  Future<bool> isBookmarked(int id) async {
    final bookmarks = await getBookmarks();
    return bookmarks.any((b) => b['id'] == id);
  }
}
