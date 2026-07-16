import 'package:aniyoka/services/watchlist_service.dart';
import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WatchlistEntryTile extends StatelessWidget {
  final WatchlistEntry entry;
  final VoidCallback onTap;
  final VoidCallback onDecrement;
  final Future<bool> Function() onIncrement;

  const WatchlistEntryTile({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final title = entry.animeData['title']?['english'] ??
        entry.animeData['title']?['romaji'] ??
        '';
    final imageUrl = entry.animeData['coverImage']?['large'] ?? '';
    final format = entry.animeData['format'] ?? '';
    final year = entry.animeData['startDate']?['year']?.toString() ?? '';
    final total = entry.totalEpisodes;
    final progress = total != null && total > 0
        ? (entry.episodesWatched / total).clamp(0.0, 1.0).toDouble()
        : 0.0;
    final statusLabel = entry.status[0] +
        entry.status.substring(1).toLowerCase().replaceAll('_', ' ');

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 120,
                height: 165,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  width: 120,
                  height: 165,
                  color: kcSurfaceColor,
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 120,
                  height: 165,
                  color: kcSurfaceColor,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: SizedBox(
                height: 165,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: kcOffWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              year.isNotEmpty ? '$format • $year' : format,
                              style: GoogleFonts.nunito(
                                color: kcLightGrey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              statusLabel,
                              style: GoogleFonts.nunito(
                                color: kcAccentPink,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // episode counter
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (entry.isNotYetReleased)
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'No episodes yet',
                                    style: GoogleFonts.nunito(
                                      color: kcLightGrey,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                            else ...[
                              if (entry.status != 'COMPLETED' &&
                                  entry.status != 'DROPPED')
                                IconButton(
                                  onPressed: onDecrement,
                                  style: IconButton.styleFrom(
                                    backgroundColor: kcPrimaryPink,
                                    foregroundColor: kcOffWhite,
                                    minimumSize: const Size(60, 40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                  icon: const Icon(Icons.remove, size: 24),
                                ),
                              Expanded(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(
                                      entry.isReleasing &&
                                              (entry.latestAiredEpisode ?? 0) >
                                                  0
                                          ? 'Ep ${entry.episodesWatched} / ${entry.latestAiredEpisode} of ${entry.totalEpisodes ?? '?'}'
                                          : 'Ep ${entry.episodesWatched}${entry.totalEpisodes != null ? ' / ${entry.totalEpisodes}' : ''}',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.nunito(
                                        color: kcLightGrey,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (entry.status != 'COMPLETED' &&
                                  entry.status != 'DROPPED')
                                IconButton(
                                  onPressed: () async {
                                    final justCompleted = await onIncrement();
                                    if (justCompleted && context.mounted) {
                                      showWatchlistCompletionSheet(
                                          context, entry);
                                    }
                                  },
                                  style: IconButton.styleFrom(
                                    backgroundColor: kcPrimaryPink,
                                    foregroundColor: kcOffWhite,
                                    minimumSize: const Size(60, 40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                  icon: const Icon(Icons.add, size: 24),
                                ),
                            ],
                          ],
                        ),
                        // progress bar
                        ...[
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: kcSurfaceColor,
                            color: kcPrimaryPink,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showWatchlistCompletionSheet(BuildContext context, WatchlistEntry entry) {
  final title = entry.animeData['title']?['english'] ??
      entry.animeData['title']?['romaji'] ??
      '';
  final imageUrl = entry.animeData['coverImage']?['large'] ?? '';

  showModalBottomSheet(
    context: context,
    backgroundColor: kcSurfaceColor,
    isDismissible: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: kcLightGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // anime cover
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 120,
              height: 165,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Container(width: 80, height: 110, color: kcBackgroundColor),
              errorWidget: (_, __, ___) =>
                  Container(width: 80, height: 110, color: kcBackgroundColor),
            ),
          ),
          const SizedBox(height: 20),
          // congratulations text
          Text(
            'Congratulations!',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              color: kcPrimaryPink,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'You finished $title!',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: kcOffWhite,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 32),
          // lets go button
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: kcPrimaryPink,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "Let's Go!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    color: kcOffWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
