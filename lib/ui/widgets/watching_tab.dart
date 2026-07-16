import 'package:aniyoka/app/app.locator.dart';
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
        separatorBuilder: (_, __) => const Divider(color: kcSurfaceColor, height: 1),
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
              if (mounted) setState(() {});
            },
            onIncrement: () async {
              final cap = entry.episodeCap;
              if (cap != null && entry.episodesWatched >= cap) return false;
              entry.episodesWatched++;
              bool justCompleted = false;
              if (entry.totalEpisodes != null && entry.episodesWatched >= entry.totalEpisodes!) {
                entry.status = 'COMPLETED';
                justCompleted = true;
              }
              await _watchlistService.addOrUpdate(entry);
              if (mounted) {
                setState(() {
                  // a completed entry drops out of the WATCHING filter
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
}