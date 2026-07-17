import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WatchlistEntry {
  final int id;
  final Map<String, dynamic> animeData;
  String status;
  int episodesWatched;
  final int? totalEpisodes;
  final DateTime addedAt;
  final String? animeStatus;
  final int? nextAiringEpisode;
  int score;
  int rewatchCount;
  DateTime? startedAt;
  DateTime? finishedAt;

  WatchlistEntry({
    required this.id,
    required this.animeData,
    required this.status,
    required this.episodesWatched,
    required this.addedAt,
    this.totalEpisodes,
    this.animeStatus,
    this.nextAiringEpisode,
    this.score = 0,
    this.rewatchCount = 0,
    this.startedAt,
    this.finishedAt,
  });

  int? get latestAiredEpisode {
    if (animeStatus != 'RELEASING') return null;
    if (nextAiringEpisode == null) return null;
    return nextAiringEpisode! - 1;
  }

  bool get isNotYetReleased => animeStatus == 'NOT_YET_RELEASED';
  bool get isReleasing => animeStatus == 'RELEASING';

  int? get episodeCap {
    if (isReleasing) return latestAiredEpisode;
    return totalEpisodes;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'animeData': animeData,
        'status': status,
        'episodesWatched': episodesWatched,
        'totalEpisodes': totalEpisodes,
        'addedAt': addedAt.toIso8601String(),
        'animeStatus': animeStatus,
        'nextAiringEpisode': nextAiringEpisode,
        'score': score,
        'rewatchCount': rewatchCount,
        'startedAt': startedAt?.toIso8601String(),
        'finishedAt': finishedAt?.toIso8601String(),
      };

  factory WatchlistEntry.fromJson(Map<String, dynamic> json) => WatchlistEntry(
        id: json['id'],
        animeData: Map<String, dynamic>.from(json['animeData']),
        status: json['status'],
        episodesWatched: json['episodesWatched'] ?? 0,
        totalEpisodes: json['totalEpisodes'],
        addedAt: DateTime.parse(json['addedAt']),
        animeStatus: json['animeStatus'],
        nextAiringEpisode: json['nextAiringEpisode'],
        score: json['score'] ?? 0,
        rewatchCount: json['rewatchCount'] ?? 0,
        startedAt: json['startedAt'] != null
            ? DateTime.parse(json['startedAt'])
            : null,
        finishedAt: json['finishedAt'] != null
            ? DateTime.parse(json['finishedAt'])
            : null,
      );
}

class WatchlistService {
  static const String _key = 'watchlist';

  Future<List<WatchlistEntry>> getWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((e) => WatchlistEntry.fromJson(jsonDecode(e))).toList();
  }

  Future<WatchlistEntry?> getEntry(int id) async {
    final list = await getWatchlist();
    try {
      return list.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<bool> isInWatchlist(int id) async {
    final entry = await getEntry(id);
    return entry != null;
  }

  Future<void> addOrUpdate(WatchlistEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getWatchlist();
    final index = list.indexWhere((e) => e.id == entry.id);
    if (index >= 0) {
      list[index] = entry;
    } else {
      list.add(entry);
    }
    await prefs.setStringList(
        _key, list.map((e) => jsonEncode(e.toJson())).toList());
  }

  Future<void> remove(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getWatchlist();
    list.removeWhere((e) => e.id == id);
    await prefs.setStringList(
        _key, list.map((e) => jsonEncode(e.toJson())).toList());
  }
}
