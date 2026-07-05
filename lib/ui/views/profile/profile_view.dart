import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'profile_viewmodel.dart';

class ProfileView extends StackedView<ProfileViewModel> {
  const ProfileView({super.key});

  @override
  Widget builder(
      BuildContext context, ProfileViewModel viewModel, Widget? child) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kcSurfaceColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: kcBackgroundColor,
          body: viewModel.isBusy
              ? const Center(
                  child: CircularProgressIndicator(color: kcPrimaryPink))
              : Column(
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

  // HEADER (title + tab bar)
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              'Profile',
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

  // TAB BAR
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
        Tab(child: FittedBox(fit: BoxFit.scaleDown, child: Text('My Profile'))),
        Tab(
            child: FittedBox(
                fit: BoxFit.scaleDown, child: Text('Recent Activity'))),
        Tab(child: FittedBox(fit: BoxFit.scaleDown, child: Text('Settings'))),
      ],
    );
  }

  // TAB CONTENT
  Widget _buildTabContent(ProfileViewModel viewModel) {
    return TabBarView(
      children: [
        _buildMyProfileTab(viewModel),
        const Center(
          child: Text('Recent Activity', style: TextStyle(color: kcOffWhite)),
        ),
        const Center(
          child: Text('Settings', style: TextStyle(color: kcOffWhite)),
        ),
      ],
    );
  }

  // PROFILE TAB with avatar, name, and email
  Widget _buildMyProfileTab(ProfileViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 15),
      child: Column(
        children: [
          // pink ring avatar
          Container(
            width: 200,
            height: 200,
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kcPrimaryPink,
            ),
            child: ClipOval(
              child: Image.network(
                viewModel.avatarUrl ??
                    'https://mrwallpaper.com/images/thumbnail/kid-luffy-pfp-one-piece-funny-fanart-denwom1cyqf9spm3.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // username
          Text(
            viewModel.username ?? 'username',
            style: GoogleFonts.inter(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: kcTertiaryPink,
            ),
          ),
          const SizedBox(height: 4),
          // email
          Text(
            viewModel.email ?? 'name@example.com',
            style: GoogleFonts.inter(
              fontSize: 17,
              color: kcLightGrey,
            ),
          ),
          const SizedBox(height: 27),
          // stats grid
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 120,
              mainAxisSpacing: 15,
              crossAxisSpacing: 10,
              childAspectRatio: 1.6,
            ),
            children: [
              _buildStatTile(
                  '${viewModel.episodesWatched ?? 0}', 'episodes watched'),
              _buildStatTile(
                  '${viewModel.animeInProgress ?? 0}', 'anime in progress'),
              _buildStatTile(
                  '${viewModel.animeCompleted ?? 0}', 'anime completed'),
              _buildStatTile(
                  '${viewModel.longestStreak ?? 0}', 'longest streak'),
              _buildStatTile('${viewModel.averageRating?.toInt() ?? 0}%',
                  'average rating'),
            ],
          ),
          // favorites section
          const SizedBox(height: 28),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Favorites',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: kcTertiaryPink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Single stat tile (the pink rounded boxes in the grid)
  Widget _buildStatTile(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: kcPrimaryPink,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 27,
              fontWeight: FontWeight.w800,
              color: kcTertiaryPink,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: kcTertiaryPink,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onViewModelReady(ProfileViewModel viewModel) => viewModel.initialise();

  @override
  ProfileViewModel viewModelBuilder(BuildContext context) => ProfileViewModel();
}
