import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:stacked/stacked.dart';
import 'package:aniyoka/app/app.locator.dart';
import 'package:aniyoka/services/anilist_service.dart';
import 'package:aniyoka/services/bookmark_service.dart';
import 'package:aniyoka/services/watchlist_service.dart';

class AnimeInfoViewModel extends BaseViewModel {
  final _anilistService = locator<AniListService>();
  final _bookmarkService = locator<BookmarkService>();
  final _watchlistService = locator<WatchlistService>();

  WatchlistEntry? _watchlistEntry;
  WatchlistEntry? get watchlistEntry => _watchlistEntry;
  bool get isInWatchlist => _watchlistEntry != null;

  Map<String, dynamic>? _anime;
  Map<String, dynamic>? get anime => _anime;

  bool _isDescriptionExpanded = false;
  bool get isDescriptionExpanded => _isDescriptionExpanded;

  bool _showSpoilerTags = false;
  bool get showSpoilerTags => _showSpoilerTags;

  bool _isBookmarked = false;
  bool get isBookmarked => _isBookmarked;

  int get totalEpisodes => _anime?['episodes'] ?? 0;

  // color for gradient depending on dominant color of anime cover image
  Color _dominantColor = kcAccentSurfaceColor;
  Color get dominantColor => _dominantColor;

  void toggleDescription() {
    _isDescriptionExpanded = !_isDescriptionExpanded;
    rebuildUi();
  }

  void toggleSpoilerTags() {
    _showSpoilerTags = !_showSpoilerTags;
    rebuildUi();
  }

  Future<void> loadAnimeDetails(int id) async {
    setBusy(true);
    try {
      _anime = await _anilistService.getAnimeDetails(id);
      final coverImage = _anime?['coverImage']['extraLarge'] ?? '';
      if (coverImage.isNotEmpty) await _extractDominantColor(coverImage);
      await _checkBookmarkStatus();
      await _checkWatchlistStatus();
    } catch (e) {
      setError(e.toString());
    }
    setBusy(false);
  }

  Future<void> _checkWatchlistStatus() async {
    _watchlistEntry = await _watchlistService.getEntry(_anime!['id']);
    rebuildUi();
  }


  // bookmark functionality
  Future<void> _checkBookmarkStatus() async {
    _isBookmarked = await _bookmarkService.isBookmarked(_anime!['id']);
    rebuildUi();
  }

  Future<void> toggleBookmark() async {
    if (_anime == null) return;
    if (_isBookmarked) {
      await _bookmarkService.removeBookmark(_anime!['id']);
    } else {
      // store minimal data needed to display the card
      await _bookmarkService.addBookmark({
        'id': _anime!['id'],
        'title': _anime!['title'],
        'coverImage': {
          'large': _anime!['coverImage']['extraLarge'] ??
              _anime!['coverImage']['large'] ??
              '',
        },
        'format': _anime!['format'],
        'startDate': _anime!['startDate'],
        'savedAt': DateTime.now().toIso8601String(),
      });
    }
    _isBookmarked = !_isBookmarked;
    rebuildUi();
  }

  Future<void> saveToWatchlist({
    required String status,
    required int episodesWatched,
  }) async {
    if (_anime == null) return;
    final entry = WatchlistEntry(
      id: _anime!['id'],
      animeData: {
        'id': _anime!['id'],
        'title': _anime!['title'],
        'coverImage': {
          'large': _anime!['coverImage']['extraLarge'] ?? '',
        },
        'format': _anime!['format'],
        'startDate': _anime!['startDate'],
        'status': _anime!['status'],
      },
      status: status,
      episodesWatched: episodesWatched,
      totalEpisodes: _anime!['episodes'],
      addedAt: _watchlistEntry?.addedAt ?? DateTime.now(),
    );
    await _watchlistService.addOrUpdate(entry);
    _watchlistEntry = entry;
    rebuildUi();
  }

  Future<void> removeFromWatchlist() async {
    if (_anime == null) return;
    await _watchlistService.remove(_anime!['id']);
    _watchlistEntry = null;
    rebuildUi();
  }

  // helpers to extract rank and popularity from rankings list
  int? get ranked => _anime?['rankings'] == null
      ? null
      : (_anime!['rankings'] as List?)?.firstWhere(
          (r) => r['type'] == 'RATED' && r['allTime'] == true,
          orElse: () => null,
        )?['rank'];

  int? get popularity => _anime?['popularity'];

  String? get airingIn {
    final next = _anime?['nextAiringEpisode'];
    if (next == null) return null;

    final seconds = next['timeUntilAiring'] as int;
    final episode = next['episode'];

    final duration = Duration(seconds: seconds);
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    String timeStr;
    if (days > 0) {
      timeStr = '${days}d ${hours}h';
    } else if (hours > 0) {
      timeStr = '${hours}h ${minutes}m';
    } else {
      timeStr = '${minutes}m';
    }

    return 'Ep $episode in $timeStr';
  }

  List<dynamic> get tags {
    final allTags = _anime?['tags'] as List? ?? [];
    // sort by rank descending, take top 10
    final sorted = [...allTags]
      ..sort((a, b) => (b['rank'] as int).compareTo(a['rank'] as int));
    return sorted.take(10).toList();
  }

  List<dynamic> get visibleTags {
    if (_showSpoilerTags) return tags;
    return tags.where((tag) => tag['isMediaSpoiler'] == false).toList();
  }

  List<dynamic> get spoilerTags {
    return tags.where((tag) => tag['isMediaSpoiler'] == true).toList();
  }

  List<dynamic> get relatedAnime {
    final edges = _anime?['relations']?['edges'] as List? ?? [];
    return edges
        .where((edge) => edge['node']['type'] == 'ANIME')
        .map((edge) => edge['node'])
        .toList();
  }

  List<dynamic> get recommendations {
    final nodes = _anime?['recommendations']?['nodes'] as List? ?? [];
    return nodes
        .map((n) => n['mediaRecommendation'])
        .where((m) => m != null)
        .toList();
  }

  Future<void> _extractDominantColor(String imageUrl) async {
    try {
      final paletteGenerator = await PaletteGenerator.fromImageProvider(
        NetworkImage(imageUrl),
        size: const Size(200, 300),
        maximumColorCount: 5,
      );
      _dominantColor =
          paletteGenerator.dominantColor?.color ?? kcAccentSurfaceColor;
      rebuildUi();
    } catch (e) {
      // keep fallback color if extraction fails
    }
  }

  Color get adjustedDominantColor {
    final hsl = HSLColor.fromColor(_dominantColor);
    return hsl
        .withLightness(0.2)
        .withSaturation((hsl.saturation * 0.8).clamp(0.0, 1.0))
        .toColor();
  }

  String cleanDescription(String description) {
    return description
        .replaceAll(RegExp(r'<[^>]*>'), '') // removes all html tags
        .replaceAll('&nbsp;', ' ') // replaces html spaces
        .replaceAll('&amp;', '&') // replaces &amp; with &
        .replaceAll('&lt;', '<') // replaces &lt; with
        .replaceAll('&gt;', '>') // replaces &gt; with >
        .trim();
  }

  void copyDescription() {
    final description = _anime?['description'] ?? '';
    Clipboard.setData(ClipboardData(text: description));
  }

  String formatEnum(String? value) {
    if (value == null) return 'Unknown';
    return value
        .split('_')
        .map((word) => '${word[0]}${word.substring(1).toLowerCase()}')
        .join(' ');
  }

  String formatDate(Map? date) {
    if (date == null) return 'Unknown';
    final year = date['year'];
    final month = date['month'];
    final day = date['day'];
    if (year == null) return 'Unknown';

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
      ''
    ];

    if (month == null) return '$year';
    if (day == null) return '${months[month]} $year';
    return '${months[month]} $day, $year';
  }

  String formatPopularity(int? value) {
    if (value == null) return '?';
    return value.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
  }
}
