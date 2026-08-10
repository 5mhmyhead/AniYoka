import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'discover_tab_viewmodel.dart';

class DiscoverTab extends StackedView<DiscoverTabViewModel> {
  const DiscoverTab({super.key});

  @override
  Widget builder(BuildContext context, DiscoverTabViewModel viewModel, Widget? child) {
    if (viewModel.isBusy) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Something went wrong'),
            TextButton(
              onPressed: viewModel.initialise,
              child: Text('Try again'),
            )
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      itemCount: viewModel.trendingAnime.length,
      itemBuilder: (context, index) {
        final anime = viewModel.trendingAnime[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              anime.coverImage,
              width: 50,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(anime.title),
          subtitle: Text('Score: ${anime.rating} ★'),
        );
      },
    );
  }

  @override
  DiscoverTabViewModel viewModelBuilder(BuildContext context) => DiscoverTabViewModel();

  @override 
  void onViewModelReady(DiscoverTabViewModel viewModel) => viewModel.initialise();
}