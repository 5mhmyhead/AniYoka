import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:aniyoka/ui/widgets/card_list_row.dart';
import 'package:aniyoka/ui/widgets/hero_carousel.dart';
import 'package:aniyoka/ui/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stacked/stacked.dart';
import 'discover_tab_viewmodel.dart';

class DiscoverTab extends StackedView<DiscoverTabViewModel> {
  const DiscoverTab({super.key});

  @override
  Widget builder(
      BuildContext context, DiscoverTabViewModel viewModel, Widget? child) {
    //note: change is busy call to something different later
    if (viewModel.isBusy) {
      return Center(
          child: LoadingAnimationWidget.fourRotatingDots(
              color: context.colors.primary, size: 50));
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

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        verticalSpaceLg,
        SectionHeader(title: 'Trending Anime', onTap: () {}),
        verticalSpaceMd,
        HeroCarousel(listItems: viewModel.trendingAnime),
        verticalSpaceLg,
        SectionHeader(title: 'This Season', onTap: () {}),
        verticalSpaceMd,
        CardListRow(listItems: viewModel.thisSeasonAnime),
        verticalSpaceLg,
        SectionHeader(title: 'Next Season', onTap: () {}),
        verticalSpaceMd,
        CardListRow(listItems: viewModel.nextSeasonAnime),
        verticalSpaceXl,
        verticalSpaceXl,
        verticalSpaceXl,
        verticalSpaceXl,
        verticalSpaceXl,
        verticalSpaceXl,
      ],
    );
  }

  @override
  DiscoverTabViewModel viewModelBuilder(BuildContext context) => DiscoverTabViewModel();

  @override
  void onViewModelReady(DiscoverTabViewModel viewModel) => viewModel.initialise();
}
