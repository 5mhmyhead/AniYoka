import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'bookmarks_viewmodel.dart';

class BookmarksView extends StackedView<BookmarksViewModel> {
  const BookmarksView({super.key});

  @override
  Widget builder(
      BuildContext context, BookmarksViewModel viewModel, Widget? child) {
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
              Expanded(
                child: _buildTabContent(viewModel),
              ),
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
      labelStyle: GoogleFonts.nunito(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.nunito(
        fontSize: 15,
      ),
      tabs: const [
        Tab(
            child: FittedBox(
                fit: BoxFit.scaleDown, child: Text('All Bookmarked'))),
        Tab(
            child: FittedBox(
                fit: BoxFit.scaleDown, child: Text('Recently Saved'))),
        Tab(
            child:
                FittedBox(fit: BoxFit.scaleDown, child: Text('Oldest Saves'))),
      ],
    );
  }

  Widget _buildTabContent(BookmarksViewModel viewModel) {
    if (viewModel.isBusy) {
      return const Center(
        child: CircularProgressIndicator(color: kcPrimaryPink),
      );
    }

    return TabBarView(
      children: [
        const Center(
          child: Text('All Bookmarked', style: TextStyle(color: kcOffWhite)),
        ),
        const Center(
          child: Text('Recently Saved', style: TextStyle(color: kcOffWhite)),
        ),
        const Center(
          child: Text('Oldest Saves', style: TextStyle(color: kcOffWhite)),
        ),
      ],
    );
  }

  @override
  BookmarksViewModel viewModelBuilder(BuildContext context) =>
      BookmarksViewModel();
}
