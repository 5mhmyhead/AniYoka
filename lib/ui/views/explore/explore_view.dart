import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:aniyoka/ui/common/app_colors.dart';

import 'explore_viewmodel.dart';

class ExploreView extends StackedView<ExploreViewModel> {
  const ExploreView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context, ExploreViewModel viewModel, Widget? child) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextField(
                controller: viewModel.searchController,
                cursorColor: kcPrimaryPink, // cursor color
                style: const TextStyle(
                  color: kcPrimaryPink, // typed text color
                ),
                decoration: InputDecoration(
                  hintText: 'Search anime...',
                  hintStyle: TextStyle(
                    color: kcPrimaryPink.withOpacity(0.6),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: kcPrimaryPink, // search icon color
                  ),
                  suffixIcon: viewModel.searchText.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: kcPrimaryPink, // close icon color
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
              SizedBox(height: 20),
              Expanded(
                child: _buildSearchBody(viewModel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBody(ExploreViewModel viewModel) {
    if (viewModel.searchText.isEmpty) {
      return const Center(
        child: Text('Search for anime.'),
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
        child: Text(
          viewModel.modelError.toString(),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (viewModel.hasSearched &&
        viewModel.searchResults.isEmpty &&
        viewModel.relatedResults.isEmpty) {
      return const Center(
        child: Text('No anime found.'),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 30),
      children: [
        ...viewModel.searchResults.map((anime) {
          return _buildAnimeListTile(anime);
        }).toList(),
        if (viewModel.relatedResults.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            'Related titles containing "${viewModel.searchText}"',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          ...viewModel.relatedResults.map((anime) {
            return _buildAnimeListTile(anime);
          }).toList(),
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
          : const Icon(Icons.image_not_supported),
      title: Text(title),
      subtitle: Text(
        '${anime['status'] ?? 'Unknown'} • ${anime['episodes'] ?? '?'} eps',
      ),
    );
  }

  @override
  ExploreViewModel viewModelBuilder(BuildContext context) => ExploreViewModel();
}
