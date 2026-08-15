import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:aniyoka/ui/helpers/season_helper.dart';
import 'package:aniyoka/ui/widgets/card_list_row.dart';
import 'package:aniyoka/ui/widgets/hero_carousel.dart';
import 'package:aniyoka/ui/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'discover_tab_viewmodel.dart';

// switching between tabs became costly since it was rebuilt every time
// so discover tab was changed to a StatefulWidget to give it
// AutomaticKeepAliveClientMixin for improved performance
class DiscoverTab extends StatefulWidget {
  const DiscoverTab({super.key});

  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ViewModelBuilder<DiscoverTabViewModel>.reactive(
      viewModelBuilder: () => DiscoverTabViewModel(),
      onViewModelReady: (viewModel) => viewModel.initialise(),
      builder: (context, viewModel, child) {
        // TODO: change is busy call to something different later
        if (viewModel.isBusy) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // TODO: change has error call to something else
        if (viewModel.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Something went wrong'),
                TextButton(
                  onPressed: viewModel.initialise,
                  child: Text('Try again'),
                ),
              ],
            ),
          );
        }

        return SafeArea(
          top: false,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              verticalSpaceLg,
              _buildSection(
                title: 'Trending Anime',
                onTap: () {},
                content: HeroCarousel(
                  listItems: viewModel.trendingAnime,
                  onTap: (id) => viewModel.onMediaTap(id),
                  onLongPress: (id) => viewModel.onMediaLongPress(id),
                ),
              ),
              _buildSection(
                title: 'This Season',
                subtitle: SeasonHelper.getCurrentSeasonAsString(),
                color: context.colors.secondary,
                onTap: () {},
                content: CardListRow(
                  listItems: viewModel.thisSeasonAnime,
                  onTap: (id) => viewModel.onMediaTap(id),
                  onLongPress: (id) => viewModel.onMediaLongPress(id),
                ),
              ),
              _buildSection(
                title: 'Next Season',
                subtitle: SeasonHelper.getNextSeasonAsString(),
                color: context.colors.secondary,
                onTap: () {},
                content: CardListRow(
                  listItems: viewModel.nextSeasonAnime,
                  onTap: (id) => viewModel.onMediaTap(id),
                  onLongPress: (id) => viewModel.onMediaLongPress(id),
                ),
              ),
              _buildSection(
                title: 'Trending Manga',
                onTap: () {},
                content: HeroCarousel(
                  listItems: viewModel.trendingManga,
                  onTap: (id) => viewModel.onMediaTap(id),
                  onLongPress: (id) => viewModel.onMediaLongPress(id),
                ),
              ),
              _buildSection(
                title: 'Highest Rated Manga',
                color: context.colors.secondary,
                onTap: () {},
                content: CardListRow(
                  listItems: viewModel.highestRatedManga,
                  onTap: (id) => viewModel.onMediaTap(id),
                  onLongPress: (id) => viewModel.onMediaLongPress(id),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildSection({
  required String title,
  required Widget content,
  String? subtitle,
  Color? color,
  VoidCallback? onTap,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionHeader(
        title: title,
        subtitle: subtitle,
        color: color,
        onTap: onTap,
      ),
      verticalSpaceMd,
      content,
      verticalSpaceLg,
    ],
  );
}
