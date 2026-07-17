import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:aniyoka/ui/views/anime_info/anime_info_view.dart';
import 'package:aniyoka/ui/widgets/watchlist_sheet.dart';
import 'package:aniyoka/utils/anime_list_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'anime_list_viewmodel.dart';

class AnimeListView extends StackedView<AnimeListViewModel> {
  final AnimeListFilter filter;
  const AnimeListView({super.key, required this.filter});

  @override
  AnimeListViewModel viewModelBuilder(BuildContext context) =>
      AnimeListViewModel(filter: filter);

  @override
  void onViewModelReady(AnimeListViewModel viewModel) => viewModel.loadAnimeList();

  @override
  Widget builder(BuildContext context, AnimeListViewModel viewModel, Widget? child) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kcBackgroundColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: kcBackgroundColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // header
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: kcSurfaceColor, width: 2),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: kcOffWhite),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        filter.title,
                        style: GoogleFonts.nunito(
                          color: kcPrimaryPink,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // content
              Expanded(
                child: viewModel.isBusy
                    ? const Center(
                        child: CircularProgressIndicator(color: kcPrimaryPink))
                    : NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification.metrics.pixels >=
                              notification.metrics.maxScrollExtent - 300) {
                            viewModel.loadMore();
                          }
                          return false;
                        },
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          itemCount: viewModel.animeList.length + (viewModel.isLoadingMore ? 1 : 0),
                          separatorBuilder: (_, __) => const Divider(
                            color: kcSurfaceColor,
                            height: 1,
                          ),
                          itemBuilder: (context, index) {
                            if (index == viewModel.animeList.length) {
                              return const Padding(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                  child: CircularProgressIndicator(
                                      color: kcPrimaryPink),
                                ),
                              );
                            }
                            return _buildListItem(context, viewModel.animeList[index]);
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, dynamic anime) {
    final title = anime['title']['english'] ?? anime['title']['romaji'] ?? '';
    final format = anime['format'] ?? '';
    final year = anime['startDate']?['year']?.toString() ?? '';
    final score = anime['meanScore'];

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => AnimeInfoView(animeId: anime['id']),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          transitionsBuilder: (_, __, ___, child) => child,
        ),
      ),
      onLongPress: () => showWatchlistSheetForAnime(context, animeId: anime['id']),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: anime['coverImage']['large'] ?? '',
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
                  if(score != null) 
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.star, color: kcLightGrey, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '$score%',
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
}