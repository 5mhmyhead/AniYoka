import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryService {
  static const _categoriesKey = 'custom_categories';
  static const _assignmentsKey = 'anime_category_assignments';

  Future<List<String>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_categoriesKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List).cast<String>();
  }

  Future<void> saveCategories(List<String> categories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_categoriesKey, jsonEncode(categories));
  }

  Future<void> addCategory(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final categories = await getCategories();
    if (categories.contains(trimmed)) return;
    categories.add(trimmed);
    await saveCategories(categories);
  }

  Future<void> renameCategory(String oldName, String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty || oldName == trimmed) return;

    final categories = await getCategories();
    final index = categories.indexOf(oldName);
    if (index == -1) return;
    categories[index] = trimmed;
    await saveCategories(categories);

    // keep existing per-anime assignments pointed at the renamed category
    final assignments = await _getAllAssignmentsRaw();
    assignments.forEach((animeId, cats) {
      if (cats.remove(oldName)) cats.add(trimmed);
    });
    await _saveAllAssignmentsRaw(assignments);
  }

  Future<void> deleteCategory(String name) async {
    final categories = await getCategories();
    categories.remove(name);
    await saveCategories(categories);

    final assignments = await _getAllAssignmentsRaw();
    for (final cats in assignments.values) {
      cats.remove(name);
    }
    await _saveAllAssignmentsRaw(assignments);
  }

  Future<Set<String>> getCategoriesForAnime(int animeId) async {
    final assignments = await _getAllAssignmentsRaw();
    return assignments[animeId] ?? {};
  }

  Future<void> setCategoriesForAnime(int animeId, Set<String> categories) async {
    final assignments = await _getAllAssignmentsRaw();
    assignments[animeId] = categories;
    await _saveAllAssignmentsRaw(assignments);
  }

  Future<Map<int, Set<String>>> getAllAssignments() => _getAllAssignmentsRaw();

  Future<Map<int, Set<String>>> _getAllAssignmentsRaw() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_assignmentsKey);
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map(
      (key, value) => MapEntry(int.parse(key), (value as List).cast<String>().toSet()),
    );
  }

  Future<void> _saveAllAssignmentsRaw(Map<int, Set<String>> assignments) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = assignments.map((key, value) => MapEntry(key.toString(), value.toList()));
    await prefs.setString(_assignmentsKey, jsonEncode(encoded));
  }
}