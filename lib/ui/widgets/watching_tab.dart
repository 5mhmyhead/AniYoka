import 'package:aniyoka/app/app.locator.dart';
import 'package:aniyoka/services/recent_activity_service.dart';
import 'package:aniyoka/services/watchlist_service.dart';
import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:aniyoka/ui/views/anime_info/anime_info_view.dart';
import 'package:aniyoka/ui/widgets/watchlist_entry_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WatchingTab extends StatefulWidget {
  const WatchingTab({super.key});

  @override
  State<WatchingTab> createState() => _WatchingTabState();
}

class _WatchingTabState extends State<WatchingTab> {
  final _watchlistService = locator<WatchlistService>();
  final RecentActivityService _recentActivityService = RecentActivityService();

  List<WatchlistEntry> _entries = [];
  bool _hasLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadWatching();
  }

  Future<void> _loadWatching() async {
    final all = await _watchlistService.getWatchlist();
    if (!mounted) return;
    setState(() {
      _entries = all.where((e) => e.status == 'WATCHING').toList();
      _hasLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasLoaded) return const SizedBox.shrink();

    if (_entries.isEmpty) {
      return RefreshIndicator(
        color: kcPrimaryPink,
        backgroundColor: kcSurfaceColor,
        onRefresh: _loadWatching,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Center(
                child: Text(
                  "You're not watching anything right now.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    color: kcLightGrey,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: kcPrimaryPink,
      backgroundColor: kcSurfaceColor,
      onRefresh: _loadWatching,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _entries.length,
        separatorBuilder: (_, __) =>
            const Divider(color: kcSurfaceColor, height: 1),
        itemBuilder: (context, index) {
          final entry = _entries[index];
          return WatchlistEntryTile(
            entry: entry,
            onTap: () async {
              await Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => AnimeInfoView(animeId: entry.id),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                  transitionsBuilder: (_, __, ___, child) => child,
                ),
              );
              _loadWatching();
            },
            onDecrement: () async {
              if (entry.episodesWatched <= 0) return;

              entry.episodesWatched--;
              await _watchlistService.addOrUpdate(entry);
              await _recordActivity(
                entry,
                action: 'WATCHING',
                description: _capitalizeFirst(_progressText(entry)),
              );

              if (mounted) setState(() {});
            },
            onIncrement: () async {
              final cap = entry.episodeCap;
              if (cap != null && entry.episodesWatched >= cap) return false;

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
              await _recordActivity(
                entry,
                action: justCompleted ? 'COMPLETED' : 'WATCHING',
                description: justCompleted
                    ? 'Completed'
                    : _capitalizeFirst(_progressText(entry)),
              );

              if (mounted) {
                setState(() {
                  // A completed entry drops out of the WATCHING filter.
                  if (justCompleted) _entries.remove(entry);
                });
              }
              return justCompleted;
            },
          );
        },
      ),
    );
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
