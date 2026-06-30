import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: viewModel.popularAnime.length,
              itemBuilder: (context, index) {
                final anime = viewModel.popularAnime[index];
                final title = anime['title']['english'] ?? anime['title']['romaji'];
                return ListTile(
                  leading: Image.network(anime['coverImage']['large'], width: 50),
                  title: Text(title),
                  subtitle: Text('${anime['status']} • ${anime['episodes'] ?? '?'} eps'),
                );
              },
            ),
    );
  }

  @override
  void onViewModelReady(HomeViewModel viewModel) => viewModel.loadTrendingAnime();

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}
