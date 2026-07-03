import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:aniyoka/ui/common/app_colors.dart';

import 'explore_viewmodel.dart';

class ExploreView extends StackedView<ExploreViewModel> {
  const ExploreView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ExploreViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildSearchAndFilters(context, viewModel),
              const SizedBox(height: 20),
              Expanded(
                child: _buildSearchBody(viewModel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters(
    BuildContext context,
    ExploreViewModel viewModel,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: viewModel.searchController,
            cursorColor: kcPrimaryPink,
            style: const TextStyle(
              color: kcPrimaryPink,
            ),
            decoration: InputDecoration(
              hintText: 'Search anime...',
              hintStyle: TextStyle(
                color: kcPrimaryPink.withValues(alpha: 0.6),
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: kcPrimaryPink,
              ),
              suffixIcon: viewModel.searchText.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: kcPrimaryPink,
                      ),
                      onPressed: viewModel.clearSearch,
                    )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: kcPrimaryPink,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: kcPrimaryPink,
                  width: 2.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildFilterBar(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildFilterBar(
    BuildContext context,
    ExploreViewModel viewModel,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildFilterChip(
          label: 'All',
          icon: Icons.check,
          selected: !viewModel.hasActiveFilters,
          onTap: viewModel.clearFilters,
        ),
        _buildFilterChip(
          label: 'On My List',
          icon: Icons.bookmark,
          selected: viewModel.onMyListOnly,
          onTap: viewModel.toggleOnMyListFilter,
        ),
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
        _buildPopupFilterButton(
          context: context,
          label: viewModel.statusFilterLabel,
          title: 'Status',
          options: viewModel.statusOptionLabels,
          selectedValue: viewModel.selectedStatusLabel ?? 'Any Status',
          onSelected: viewModel.setStatusFilterByLabel,
          selected: viewModel.selectedStatusLabel != null,
        ),
        _buildPopupFilterButton(
          context: context,
          label: viewModel.genreFilterLabel,
          title: 'Genre',
          options: viewModel.genreOptionLabels,
          selectedValue: viewModel.selectedGenreLabel ?? 'Any Genre',
          onSelected: viewModel.setGenreFilterByLabel,
          selected: viewModel.selectedGenreLabel != null,
        ),
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
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onTap,
    IconData? icon,
    bool selected = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? kcPrimaryPink : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: kcPrimaryPink,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: selected ? Colors.white : kcPrimaryPink,
                ),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : kcPrimaryPink,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final value = await _showFilterDialog(
            context: context,
            title: title,
            options: options,
            selectedValue: selectedValue,
          );

          if (value != null) {
            onSelected(value);
          }
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? kcPrimaryPink : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: kcPrimaryPink,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: selected ? Colors.white : kcPrimaryPink,
                ),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : kcPrimaryPink,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
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
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 46,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: Colors.black54,
              width: 1,
            ),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 320,
              maxHeight: 500,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options[index];

                        return RadioListTile<String>(
                          value: option,
                          groupValue: selectedValue,
                          activeColor: kcPrimaryPink,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          visualDensity: const VisualDensity(
                            horizontal: -2,
                            vertical: -1,
                          ),
                          title: Text(
                            option,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onChanged: (value) {
                            if (value != null) {
                              Navigator.of(dialogContext).pop(value);
                            }
                          },
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

  Widget _buildSearchBody(ExploreViewModel viewModel) {
    if (viewModel.searchText.isEmpty) {
      return const Center(
        child: Text(
          'Search for anime.',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    if (viewModel.isBusy) {
      return const Center(
        child: CircularProgressIndicator(
          color: kcPrimaryPink,
        ),
      );
    }

    if (viewModel.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            viewModel.modelError.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    if (viewModel.hasSearched &&
        viewModel.searchResults.isEmpty &&
        viewModel.relatedResults.isEmpty) {
      return const Center(
        child: Text(
          'No anime found.',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 30),
      children: [
        ...viewModel.searchResults.map((anime) {
          return _buildAnimeListTile(anime);
        }),
        if (viewModel.relatedResults.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            'Related Anime containing "${viewModel.searchText}"',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          ...viewModel.relatedResults.map((anime) {
            return _buildAnimeListTile(anime);
          }),
        ],
      ],
    );
  }

  Widget _buildAnimeListTile(dynamic anime) {
    final title = anime['title']?['english'] ??
        anime['title']?['romaji'] ??
        anime['title']?['native'] ??
        'No title';

    final coverImage = anime['coverImage']?['large'];
    final status = anime['status'] ?? 'Unknown';
    final format = anime['format'] ?? 'Unknown';
    final episodes = anime['episodes'] ?? '?';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 6),
      leading: coverImage != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                coverImage.toString(),
                width: 50,
                height: 70,
                fit: BoxFit.cover,
              ),
            )
          : const Icon(
              Icons.image_not_supported,
              color: Colors.white70,
            ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '$status • $format • $episodes eps',
        style: const TextStyle(color: Colors.white60),
      ),
    );
  }

  @override
  ExploreViewModel viewModelBuilder(BuildContext context) => ExploreViewModel();
}
