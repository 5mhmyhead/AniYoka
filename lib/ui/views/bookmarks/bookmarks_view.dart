import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:aniyoka/ui/views/anime_info/anime_info_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'bookmarks_viewmodel.dart';

class BookmarksView extends StackedView<BookmarksViewModel> {
  const BookmarksView({super.key});

  @override
  Widget builder(BuildContext context, BookmarksViewModel viewModel, Widget? child) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kcSurfaceColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: kcBackgroundColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: kcSurfaceColor,
                child: _buildHeader(),
              ),
              Expanded(child: _buildTabContent(viewModel, context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              'Bookmarks',
              style: GoogleFonts.nunito(
                color: kcPrimaryPink,
                fontSize: 42,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        _buildTabBar(),
      ],
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      isScrollable: false,
      labelColor: kcPrimaryPink,
      unselectedLabelColor: kcLightGrey,
      indicatorColor: kcPrimaryPink,
      indicatorWeight: 2,
      dividerColor: kcLightGrey,
      labelStyle: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.nunito(fontSize: 15),
      tabs: const [
        Tab(child: FittedBox(fit: BoxFit.scaleDown, child: Text('All Bookmarked'))),
        Tab(child: FittedBox(fit: BoxFit.scaleDown, child: Text('Recently Saved'))),
        Tab(child: FittedBox(fit: BoxFit.scaleDown, child: Text('Alphabetical'))),
      ],
    );
  }

  Widget _buildTabContent(BookmarksViewModel viewModel, BuildContext context) {
    if (viewModel.isBusy) {
      return const Center(child: CircularProgressIndicator(color: kcPrimaryPink));
    }

    return TabBarView(
      children: [
        _buildGrid(viewModel.oldestSaves, viewModel, context),
        _buildGrid(viewModel.recentlySaved, viewModel, context),
        _buildGrid(viewModel.allBookmarks, viewModel, context),
      ],
    );
  }

  Widget _buildGrid(
    List<Map<String, dynamic>> list,
    BookmarksViewModel viewModel,
    BuildContext context,
  ) {
    if (list.isEmpty) {
      return RefreshIndicator(
        color: kcPrimaryPink,
        backgroundColor: kcSurfaceColor,
        onRefresh: viewModel.loadBookmarks,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bookmark_outline, color: kcLightGrey, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'No bookmarks yet',
                      style: GoogleFonts.nunito(color: kcLightGrey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: kcPrimaryPink,
      backgroundColor: kcSurfaceColor,
      onRefresh: viewModel.loadBookmarks,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.56,
        ),
        itemCount: list.length,
        itemBuilder: (context, index) =>
            _buildCard(list[index], viewModel, context),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> anime, BookmarksViewModel viewModel, BuildContext context) {
    final title = anime['title']['english'] ?? anime['title']['romaji'] ?? '';
    final format = anime['format'] ?? '';
    final year = anime['startDate']?['year']?.toString() ?? '';

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => AnimeInfoView(animeId: anime['id']),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            transitionsBuilder: (_, __, ___, child) => child,
          ),
        );
        // reload bookmarks when user comes back
        viewModel.loadBookmarks();
      },
      onLongPress: () => _showRemoveDialog(context, anime, viewModel),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 250,
            width: 180,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: anime['coverImage']['large'] ?? '',
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: kcSurfaceColor),
                errorWidget: (_, __, ___) => Container(color: kcSurfaceColor),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: kcOffWhite,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            year.isNotEmpty ? '$format • $year' : format,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: kcLightGrey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showRemoveDialog(
    BuildContext context,
    Map<String, dynamic> anime,
    BookmarksViewModel viewModel,
  ) {
    final title = anime['title']['english'] ?? anime['title']['romaji'] ?? '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kcSurfaceColor,
        title: Text(
          'Remove Bookmark',
          style: GoogleFonts.nunito(color: kcOffWhite, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Remove "$title" from bookmarks?',
          style: GoogleFonts.nunito(color: kcLightGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.nunito(color: kcLightGrey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              viewModel.removeBookmark(anime['id']);
            },
            child: Text('Remove', style: GoogleFonts.nunito(color: kcPrimaryPink)),
          ),
        ],
      ),
    );
  }

  @override
  void onViewModelReady(BookmarksViewModel viewModel) => viewModel.loadBookmarks();

  @override
  BookmarksViewModel viewModelBuilder(BuildContext context) => BookmarksViewModel();
}
