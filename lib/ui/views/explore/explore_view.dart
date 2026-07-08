import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:aniyoka/ui/common/app_colors.dart';
import 'explore_viewmodel.dart';

class ExploreView extends StackedView<ExploreViewModel> {
  const ExploreView({super.key});

  @override
  Widget builder(
      BuildContext context, ExploreViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            viewModel.isSearching
                ? _buildActiveSearchHeader(context, viewModel)
                : _buildStaticSearchHeader(viewModel),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: viewModel.isSearching
                    ? _buildSearchBody(viewModel)
                    : _buildDiscoverGrid(viewModel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaticSearchHeader(ExploreViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: InkWell(
        onTap: viewModel.startSearchMode,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: kcSurfaceColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: kcPrimaryPink, size: 24),
              const SizedBox(width: 12),
              Text(
                'Search for an anime...',
                style: GoogleFonts.inter(
                  color: kcLightGrey.withValues(alpha: 0.75),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveSearchHeader(
      BuildContext context, ExploreViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: kcSurfaceColor, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: kcOffWhite),
                  onPressed: viewModel.exitSearchMode,
                ),
                Expanded(
                  child: TextField(
                    controller: viewModel.searchController,
                    focusNode: viewModel.searchFocusNode,
                    cursorColor: kcPrimaryPink,
                    style: GoogleFonts.inter(color: kcOffWhite, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Search for an anime...',
                      hintStyle: GoogleFonts.inter(
                          color: kcLightGrey.withValues(alpha: 0.75)),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                if (viewModel.searchText.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.close, color: kcLightGrey),
                    onPressed: viewModel.clearSearch,
                  ),
              ],
            ),
          ),
          _buildFilterBar(context, viewModel),
        ],
      ),
    );
  }

  // Horizontal Scrolling dynamic filter chips bar (Image 1 & 3)
  Widget _buildFilterBar(BuildContext context, ExploreViewModel viewModel) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        children: [
          _buildFilterChip(
            label: 'All',
            icon: Icons.check,
            selected: !viewModel.hasActiveFilters,
            onTap: viewModel.clearFilters,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'On My List',
            icon: Icons.bookmark,
            selected: viewModel.onMyListOnly,
            onTap: viewModel.toggleOnMyListFilter,
          ),
          const SizedBox(width: 8),
          _buildPopupFilterButton(
            context: context,
            label: viewModel.sortFilterLabel,
            title: 'Sort By',
            options: viewModel.sortOptionLabels,
            selectedValue: viewModel.selectedSortLabel ?? 'Default',
            onSelected: viewModel.setSortFilterByLabel,
            icon: Icons.tune,
            selected: viewModel.selectedSortLabel != null,
          ),
          const SizedBox(width: 8),
          _buildPopupFilterButton(
            context: context,
            label: viewModel.statusFilterLabel,
            title: 'Status',
            options: viewModel.statusOptionLabels,
            selectedValue: viewModel.selectedStatusLabel ?? 'Any Status',
            onSelected: viewModel.setStatusFilterByLabel,
            selected: viewModel.selectedStatusLabel != null,
          ),
          const SizedBox(width: 8),
          _buildPopupFilterButton(
            context: context,
            label: viewModel.genreFilterLabel,
            title: 'Genre',
            options: viewModel.genreOptionLabels,
            selectedValue: viewModel.selectedGenreLabel ?? 'Any Genre',
            onSelected: viewModel.setGenreFilterByLabel,
            selected: viewModel.selectedGenreLabel != null,
          ),
          const SizedBox(width: 8),
          _buildPopupFilterButton(
            context: context,
            label: viewModel.formatFilterLabel,
            title: 'Format',
            options: viewModel.formatOptionLabels,
            selectedValue: viewModel.selectedFormatLabel ?? 'Any Format',
            onSelected: viewModel.setFormatFilterByLabel,
            selected: viewModel.selectedFormatLabel != null,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onTap,
    IconData? icon,
    bool selected = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? kcPrimaryPink : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? kcPrimaryPink : kcSurfaceColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: selected ? kcOffWhite : kcLightGrey),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.nunito(
                color: selected ? kcOffWhite : kcLightGrey,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopupFilterButton({
    required BuildContext context,
    required String label,
    required String title,
    required List<String> options,
    required String selectedValue,
    required ValueChanged<String> onSelected,
    IconData? icon,
    bool selected = false,
  }) {
    return _buildFilterChip(
      label: label,
      icon: icon,
      selected: selected,
      onTap: () async {
        final value = await _showFilterDialog(
          context: context,
          title: title,
          options: options,
          selectedValue: selectedValue,
        );
        if (value != null) onSelected(value);
      },
    );
  }

  Future<String?> _showFilterDialog({
    required BuildContext context,
    required String title,
    required List<String> options,
    required String selectedValue,
  }) {
    return showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: kcSurfaceColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320, maxHeight: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      title,
                      style: GoogleFonts.nunito(
                        color: kcOffWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options[index];
                        final isChosen = option == selectedValue;
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 24),
                          title: Text(
                            option,
                            style: GoogleFonts.inter(
                              color: isChosen ? kcPrimaryPink : kcLightGrey,
                              fontSize: 15,
                              fontWeight:
                                  isChosen ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                          trailing: isChosen
                              ? const Icon(Icons.check_circle,
                                  color: kcPrimaryPink, size: 20)
                              : null,
                          onTap: () => Navigator.of(dialogContext).pop(option),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDiscoverGrid(ExploreViewModel viewModel) {
    final categories = [
      {'label': 'Top 100', 'icon': Icons.star_border},
      {'label': 'Top Popular', 'icon': Icons.trending_up},
      {'label': 'Upcoming', 'icon': Icons.access_time},
      {'label': 'Airing Now', 'icon': Icons.rss_feed},
      {'label': 'Spring', 'icon': Icons.local_florist},
      {'label': 'Summer', 'icon': Icons.wb_sunny},
      {'label': 'Fall', 'icon': Icons.eco},
      {'label': 'Winter', 'icon': Icons.ac_unit},
    ];

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 12),
        Text(
          'Categories',
          style: GoogleFonts.nunito(
            color: kcPrimaryPink,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 10,
            childAspectRatio: 3,
          ),
          itemBuilder: (context, index) {
            final item = categories[index];
            return Container(
              decoration: BorderRadius.circular(50)
                  .asBoxDecoration(color: kcSurfaceColor),
              child: InkWell(
                onTap: () {
                  viewModel.startSearchMode();
                  // TODO: WORK ON CATEGORIES SEARCH
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Row(
                    children: [
                      Icon(item['icon'] as IconData,
                          color: kcPrimaryPink, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item['label'] as String,
                          style: GoogleFonts.nunito(
                            color: kcLightGrey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchBody(ExploreViewModel viewModel) {
    if (viewModel.searchText.isEmpty &&
        !viewModel.hasActiveFilters &&
        !viewModel.hasSearched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Type on the search bar to find some anime!',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: kcLightGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (viewModel.isBusy) {
      return const Center(
          child: CircularProgressIndicator(color: kcPrimaryPink));
    }

    if (viewModel.hasError) {
      return Center(
        child: Text(
          viewModel.modelError.toString(),
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            color: kcLightGrey,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    if (viewModel.hasSearched &&
        viewModel.searchResults.isEmpty &&
        viewModel.relatedResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'bruh',
              style: GoogleFonts.nunito(
                color: kcSecondaryPink,
                fontSize: 42,
                fontWeight: FontWeight.w700,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Nothing but crickets! No matches found.',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: kcLightGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );
    }

    String? headerTitle;
    if (viewModel.searchText.isNotEmpty || viewModel.hasMultipleActiveFilters) {
      headerTitle = 'Search Results';
    } else if (viewModel.searchText.isEmpty && viewModel.activeFilterResultsTitle != null) {
      headerTitle = viewModel.activeFilterResultsTitle;
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      children: [
        if (headerTitle != null) ...[
          Text(
            headerTitle,
            style: GoogleFonts.nunito(
              color: kcPrimaryPink, 
              fontSize: 28, 
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
        ],
        ...viewModel.searchResults.map((anime) => _buildAnimeCardListTile(anime, onTap: () {
          viewModel.onAnimeTap(anime['id']); 
        })),
        if (viewModel.relatedResults.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            'Related Results',
            style: GoogleFonts.nunito(
              color: kcPrimaryPink, 
              fontSize: 28, 
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          ...viewModel.relatedResults.map((anime) => _buildAnimeCardListTile(anime, onTap: () {
            viewModel.onAnimeTap(anime['id']);
          })),
        ],
      ],
    );
  }

  Widget _buildAnimeCardListTile(dynamic anime, {required VoidCallback onTap}) {
    final title = anime['title']?['english'] ??
        anime['title']?['romaji'] ??
        anime['title']?['native'] ??
        'No title';

    final coverImage = anime['coverImage']?['large'];
    final format = anime['format'] ?? 'TV';
    final score = anime['averageScore'] != null ? '${anime['averageScore']}%' : 'N/A';
    final year = anime['startDate']?['year']?.toString() ?? '';

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: coverImage != null
                  ? CachedNetworkImage(
                      imageUrl: coverImage.toString(),
                      width: 120,
                      height: 165,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: kcSurfaceColor),
                      errorWidget: (context, url, error) => Container(
                        width: 120,
                        height: 165,
                        color: kcSurfaceColor,
                        child: const Icon(Icons.broken_image, color: kcLightGrey),
                      ),
                    )
                  : Container(
                      width: 120,
                      height: 165,
                      color: kcSurfaceColor,
                      child: const Icon(Icons.image_not_supported, color: kcLightGrey),
                    ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
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
                  Text(
                    year.isNotEmpty ? '$format • $year' : format,
                    style: GoogleFonts.nunito(
                      color: kcLightGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.star, color: kcLightGrey, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        score,
                        style: GoogleFonts.nunito(
                          color: kcLightGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  ExploreViewModel viewModelBuilder(BuildContext context) => ExploreViewModel();
}

extension BoxExtension on BorderRadius {
  BoxDecoration asBoxDecoration({required Color color}) =>
      BoxDecoration(color: color, borderRadius: this);
}
