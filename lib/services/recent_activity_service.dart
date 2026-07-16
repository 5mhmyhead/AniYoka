import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RecentActivityEntry {
  const RecentActivityEntry({
    required this.id,
    required this.animeId,
    required this.title,
    required this.action,
    required this.description,
    required this.createdAt,
    this.coverImageUrl,
  });

  final String id;
  final int animeId;
  final String title;
  final String action;
  final String description;
  final DateTime createdAt;
  final String? coverImageUrl;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'animeId': animeId,
      'title': title,
      'action': action,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'coverImageUrl': coverImageUrl,
    };
  }

  factory RecentActivityEntry.fromJson(Map<String, dynamic> json) {
    return RecentActivityEntry(
      id: json['id'] as String? ?? '',
      animeId: (json['animeId'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? 'Unknown anime',
      action: json['action'] as String? ?? 'PROGRESS',
      description: json['description'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      coverImageUrl: json['coverImageUrl'] as String?,
    );
  }
}

class RecentActivityService {
  static const String _storageKey = 'aniyoka_recent_activities_v1';
  static const int _maximumSavedActivities = 100;

  Future<List<RecentActivityEntry>> getActivities() async {
    final preferences = await SharedPreferences.getInstance();
    final storedValue = preferences.getString(_storageKey);

    if (storedValue == null || storedValue.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(storedValue);
      if (decoded is! List) {
        throw const FormatException('Recent activity data is not a list.');
      }

      final activities = decoded
          .whereType<Map>()
          .map(
            (item) => RecentActivityEntry.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();

      activities.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return activities;
    } catch (_) {
      // Clear malformed local data instead of crashing the Profile screen.
      await preferences.remove(_storageKey);
      return [];
    }
  }

  Future<void> addActivity({
    required int animeId,
    required String title,
    required String action,
    required String description,
    String? coverImageUrl,
  }) async {
    final activities = await getActivities();
    final now = DateTime.now();

    activities.insert(
      0,
      RecentActivityEntry(
        id: '${now.microsecondsSinceEpoch}_$animeId',
        animeId: animeId,
        title: title,
        action: action,
        description: description,
        createdAt: now,
        coverImageUrl: coverImageUrl,
      ),
    );

    if (activities.length > _maximumSavedActivities) {
      activities.removeRange(_maximumSavedActivities, activities.length);
    }

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _storageKey,
      jsonEncode(activities.map((activity) => activity.toJson()).toList()),
    );
  }

  Future<void> clearActivities() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_storageKey);
  }
}
