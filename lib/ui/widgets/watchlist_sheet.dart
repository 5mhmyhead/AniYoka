import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:aniyoka/ui/widgets/custom_categories_sheet.dart';
import 'package:aniyoka/ui/views/anime_info/anime_info_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showWatchlistSheet(BuildContext context, AnimeInfoViewModel viewModel) {
  String selectedStatus = viewModel.watchlistEntry?.status ?? 'WATCHING';
  int episodesWatched = viewModel.watchlistEntry?.episodesWatched ?? 0;
  final totalEpisodes = viewModel.totalEpisodes;

  int score = viewModel.watchlistEntry?.score ?? 0;
  int rewatchCount = viewModel.watchlistEntry?.rewatchCount ?? 0;
  DateTime? startDate = viewModel.watchlistEntry?.startedAt;
  DateTime? finishDate = viewModel.watchlistEntry?.finishedAt;

  final statuses = [
    {'value': 'WATCHING', 'icon': Icons.play_circle_outline},
    {'value': 'COMPLETED', 'icon': Icons.check_circle_outline},
    {'value': 'PAUSED', 'icon': Icons.pause_circle_outline},
    {'value': 'DROPPED', 'icon': Icons.delete_outline},
    {'value': 'REWATCHING', 'icon': Icons.replay},
  ];

  showModalBottomSheet(
    context: context,
    backgroundColor: kcSurfaceColor,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => StatefulBuilder(
      builder: (context, setSheetState) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                // cancel and save row
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: kcBackgroundColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.nunito(
                              color: kcLightGrey,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final finalEpisodes =
                              selectedStatus == 'COMPLETED' && totalEpisodes > 0
                                  ? totalEpisodes
                                  : episodesWatched;

                          Navigator.pop(context);
                          viewModel.saveToWatchlist(
                            status: selectedStatus,
                            episodesWatched: finalEpisodes,
                            score: score,
                            rewatchCount: rewatchCount,
                            startedAt: startDate,
                            finishedAt: finishDate,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: kcPrimaryPink,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Save',
                            style: GoogleFonts.nunito(
                              color: kcOffWhite,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // status buttons row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: statuses.map((s) {
                    final isSelected = selectedStatus == s['value'];
                    return GestureDetector(
                      onTap: () => setSheetState(
                          () => selectedStatus = s['value'] as String),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeInOut,
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: isSelected ? kcPrimaryPink : kcBackgroundColor,
                          borderRadius:
                              BorderRadius.circular(isSelected ? 16 : 50),
                        ),
                        child: Icon(
                          s['icon'] as IconData,
                          color: isSelected ? kcOffWhite : kcLightGrey,
                          size: 24,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // episode counter
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: viewModel.isNotYetReleased
                      ? Row(
                          children: [
                            const Icon(Icons.play_circle_outline_rounded,
                                color: kcLightGrey, size: 24),
                            const SizedBox(width: 12),
                            Text(
                              'No episodes yet',
                              style: GoogleFonts.inter(
                                color: kcLightGrey,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            const Icon(Icons.play_circle_outline_rounded,
                                color: kcLightGrey, size: 24),
                            const SizedBox(width: 12),
                            Text(
                              viewModel.isNotYetReleased
                                  ? 'No episodes yet'
                                  : viewModel.isCurrentlyAiring &&
                                          viewModel.latestEpisode > 0
                                      ? '$episodesWatched / ${viewModel.latestEpisode} of ${totalEpisodes > 0 ? totalEpisodes : '?'} Episodes'
                                      : '$episodesWatched / ${totalEpisodes > 0 ? totalEpisodes : '?'} Episodes',
                              style: GoogleFonts.inter(
                                color: viewModel.isNotYetReleased
                                    ? kcLightGrey
                                    : kcOffWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => setSheetState(() {
                                if (episodesWatched > 0) episodesWatched--;
                              }),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: kcBackgroundColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.remove,
                                    color: kcOffWhite, size: 20),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => setSheetState(() {
                                final cap = viewModel.isCurrentlyAiring
                                    ? viewModel.latestEpisode
                                    : totalEpisodes;
                                if (cap == 0 || episodesWatched < cap) {
                                  episodesWatched++;
                                }
                              }),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: kcBackgroundColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.add,
                                    color: kcOffWhite, size: 20),
                              ),
                            ),
                          ],
                        ),
                ),
                if (totalEpisodes > 0)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: LinearProgressIndicator(
                      value: episodesWatched / totalEpisodes,
                      backgroundColor: kcBackgroundColor,
                      color: kcPrimaryPink,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                const SizedBox(height: 12),

                _buildCounterRow(
                  icon: Icons.star,
                  label: 'Score',
                  value: score,
                  onDecrement: () => setSheetState(() {
                    if (score > 0) score--;
                  }),
                  onIncrement: () => setSheetState(() {
                    if (score < 10) score++;
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0), 
                  child: LinearProgressIndicator(
                    value: score / 10,
                    backgroundColor: kcBackgroundColor,
                    color: kcPrimaryPink,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(color: kcLightGrey, height: 1),
                ),
                const SizedBox(height: 20),
                _buildDateRow(
                  icon: Icons.event_outlined,
                  label: 'Start Date',
                  value: _formatDate(startDate),
                  onEditTap: () async {
                    final picked = await _pickDate(context, startDate);
                    if (picked != null) {
                      setSheetState(() => startDate = picked);
                    }
                  },
                  onClearTap: startDate != null
                      ? () => setSheetState(() => startDate = null)
                      : null,
                ),
                const SizedBox(height: 16),

                _buildDateRow(
                  icon: Icons.event_available_outlined,
                  label: 'End Date',
                  value: _formatDate(finishDate),
                  onEditTap: () async {
                    final picked = await _pickDate(context, finishDate);
                    if (picked != null) {
                      setSheetState(() => finishDate = picked);
                    }
                  },
                  onClearTap: finishDate != null
                      ? () => setSheetState(() => finishDate = null)
                      : null,
                ),
                const SizedBox(height: 20),

                _buildCounterRow(
                  icon: Icons.history_toggle_off_rounded,
                  label: 'Rewatch Count',
                  value: rewatchCount,
                  onDecrement: () => setSheetState(() {
                    if (rewatchCount > 0) rewatchCount--;
                  }),
                  onIncrement: () => setSheetState(() {
                    rewatchCount++;
                  }),
                ),
                const SizedBox(height: 20),

                _buildCustomCategoriesSection(
                    viewModel, context, setSheetState),

                if (viewModel.isInWatchlist)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _showDeleteWatchlistDialog(context, viewModel);
                      },
                      child: Row(
                        children: [
                          SizedBox(
                              width: 28,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(Icons.delete_outline_outlined,
                                      color: kcPrimaryPink, size: 22))),
                          const SizedBox(width: 12),
                          Text(
                            'Delete from Watch List',
                            style: GoogleFonts.inter(
                              color: kcPrimaryPink,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (viewModel.isBookmarked)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _showRemoveBookmarkDialog(context, viewModel);
                      },
                      child: Row(
                        children: [
                          SizedBox(
                              width: 28,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(Icons.bookmark_remove_outlined,
                                      color: kcPrimaryPink, size: 22))),
                          const SizedBox(width: 12),
                          Text(
                            'Remove from Bookmarks',
                            style: GoogleFonts.inter(
                              color: kcPrimaryPink,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    ),
  );
}

Future<void> showWatchlistSheetForAnime(
  BuildContext context, {
  required int animeId,
}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Center(
      child: CircularProgressIndicator(color: kcPrimaryPink),
    ),
  );

  final viewModel = AnimeInfoViewModel();
  await viewModel.loadAnimeDetails(animeId);

  if (!context.mounted) return;
  Navigator.of(context, rootNavigator: true).pop();

  if (viewModel.anime == null) return;

  if (!context.mounted) return;
  showWatchlistSheet(context, viewModel);
}

Future<DateTime?> _pickDate(BuildContext context, DateTime? initial) {
  return showDatePicker(
    context: context,
    initialDate: initial ?? DateTime.now(),
    firstDate: DateTime(1980),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: kcPrimaryPink,
            onPrimary: kcOffWhite,
            surface: kcSurfaceColor,
            onSurface: kcOffWhite,
          ),
          dialogTheme: const DialogThemeData(backgroundColor: kcSurfaceColor),
        ),
        child: child!,
      );
    },
  );
}

String _formatDate(DateTime? date) {
  if (date == null) return 'Not set';
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

Widget _buildCounterRow({
  required IconData icon,
  required String label,
  required int value,
  required VoidCallback onDecrement,
  required VoidCallback onIncrement,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        SizedBox(
          width: 28,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(icon, color: kcLightGrey, size: 22),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.inter(
            color: kcOffWhite,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          '$value',
          style: GoogleFonts.inter(
            color: kcOffWhite,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onDecrement,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: kcBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.remove, color: kcOffWhite, size: 20),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onIncrement,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: kcBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: kcOffWhite, size: 20),
          ),
        ),
      ],
    ),
  );
}

Widget _buildDateRow({
  required IconData icon,
  required String label,
  required String value,
  required VoidCallback onEditTap,
  VoidCallback? onClearTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        SizedBox(
          width: 28,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(icon, color: kcLightGrey, size: 22),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.inter(
            color: kcOffWhite,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.inter(
            color: kcLightGrey,
            fontSize: 12,
          ),
        ),
        if (onClearTap != null) ...[
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onClearTap,
            child: const Icon(Icons.close, color: kcLightGrey, size: 16),
          ),
        ],
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onEditTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: kcBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.edit, color: kcLightGrey, size: 18),
          ),
        ),
      ],
    ),
  );
}

Widget _buildCustomCategoriesSection(
  AnimeInfoViewModel viewModel,
  BuildContext context,
  void Function(void Function()) setSheetState,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 28,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.bookmarks_outlined,
                    color: kcLightGrey, size: 22),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Custom Lists',
              style: GoogleFonts.inter(
                color: kcOffWhite,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () async {
                final newlyAdded = await showCustomCategoriesSheet(context);
                await viewModel.refreshAvailableCategories();
                await viewModel.autoSelectNewCategories(newlyAdded);
                setSheetState(() {});
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: kcBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, color: kcLightGrey, size: 18),
              ),
            ),
          ],
        ),
        if (viewModel.availableCategories.isEmpty) ...[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'No categories yet, tap the edit button to add one.',
              style: GoogleFonts.nunito(color: kcLightGrey, fontSize: 12),
            ),
          ),
        ] else ...[
          const SizedBox(height: 10),
          ...viewModel.availableCategories.map((category) {
            final isSelected = viewModel.selectedCategories.contains(category);
            return GestureDetector(
              onTap: () => setSheetState(() {
                viewModel.toggleCategory(category);
              }),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          isSelected
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: isSelected ? kcPrimaryPink : kcLightGrey,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      category,
                      style: GoogleFonts.nunito(
                        color: isSelected ? kcOffWhite : kcLightGrey,
                        fontSize: 16,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ],
    ),
  );
}

void _showDeleteWatchlistDialog(
    BuildContext context, AnimeInfoViewModel viewModel) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: kcSurfaceColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.delete_outline,
              color: kcTertiaryPink,
              size: 54,
            ),
            const SizedBox(height: 4),
            Text(
              'Remove from Watch List?',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                color: kcTertiaryPink,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Are you sure you want to delete this entry from your watch list?',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                color: kcLightGrey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: kcTertiaryPink,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        'No, keep it.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          color: kcSurfaceColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      viewModel.removeFromWatchlist();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: kcPrimaryPink,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        'Yes, delete!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          color: kcOffWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

void _showRemoveBookmarkDialog(
    BuildContext context, AnimeInfoViewModel viewModel) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: kcSurfaceColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_remove_outlined,
              color: kcTertiaryPink,
              size: 54,
            ),
            const SizedBox(height: 4),
            Text(
              'Remove Bookmark?',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                color: kcTertiaryPink,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Are you sure you want to delete this entry from your bookmarks?',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                color: kcLightGrey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: kcTertiaryPink,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        'No, keep it.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          color: kcSurfaceColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      // isBookmarked is true here, so this removes it
                      viewModel.toggleBookmark();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: kcPrimaryPink,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        'Yes, delete!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          color: kcOffWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}