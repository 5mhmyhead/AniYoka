import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_viewmodel.dart';

class ProfileView extends StackedView<ProfileViewModel> {
  const ProfileView({super.key});

  @override
  Widget builder(
      BuildContext context, ProfileViewModel viewModel, Widget? child) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: viewModel.isBusy
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderCard(),
                    Expanded(
                      child: _buildTabContent(viewModel),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // HEADER CARD (title + tab bar)
  Widget _buildHeaderCard() {
    return Container(
      color: const Color(
          0xFF1A1A1A), // Wrap the Column in a Container to set the background color
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restored the proper 20px side margins just for the header text
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              'Profile',
              style: GoogleFonts.nunito(
                fontSize: 42,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFFBD8DF),
              ),
            ),
          ),
          // Sits directly in the Column so it stretches perfectly edge-to-edge
          _buildTabBar(),
        ],
      ),
    );
  }

  // TAB BAR

  Widget _buildTabBar() {
    return TabBar(
      isScrollable: false,
      tabAlignment: TabAlignment.fill,
      padding: EdgeInsets.zero,
      labelPadding: EdgeInsets.zero,
      indicatorSize: TabBarIndicatorSize.label,

      //active tab text color
      labelColor: const Color(0xFFF45C82),

      labelStyle: GoogleFonts.nunito(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),

      //inactive tab text color
      unselectedLabelColor: Colors.grey,

      //underline under the active tab
      indicatorColor: const Color(0xFFF45C82),
      indicatorWeight: 3,

      //thin line across the full tab bar width
      dividerColor: Colors.grey.withOpacity(0.3),
      tabs: const [
        Tab(text: 'My Profile'),
        Tab(text: 'Recent Activity'),
        Tab(text: 'Settings'),
      ],
    );
  }

  // TAB CONTENT
  Widget _buildTabContent(ProfileViewModel viewModel) {
    return TabBarView(
      children: [
        _buildMyProfileTab(viewModel),
        Center(
          child: Text(
            'Recent Activity',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Center(
          child: Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  //PROFILE TAB with avatar, name, and email
  Widget _buildMyProfileTab(ProfileViewModel viewModel) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 35, horizontal: 15),
      child: Column(
        children: [
          //pink ring avatar
          Container(
            width: 200,
            height: 200,
            padding: const EdgeInsets.all(3), //thickness
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Color(0xFFF45C82) //ring color
                ),
            child: ClipOval(
              child: Image.network(
                viewModel.avatarUrl ??
                    'https://mrwallpaper.com/images/thumbnail/kid-luffy-pfp-one-piece-funny-fanart-denwom1cyqf9spm3.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          //username
          Text(
            viewModel.username ?? 'username', //falls back until real data loads
            style: GoogleFonts.inter(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFFBD8DF),
            ),
          ),
          const SizedBox(height: 4),
          //email
          Text(
            viewModel.email ?? 'name@example.com', //cleaned up fallback
            style: GoogleFonts.inter(
              fontSize: 17,
              color: const Color(0xFF7F7F7F),
            ),
          ),
          const SizedBox(height: 27), //space between the email and grd
          //stats grid
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 120,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.4,
            ),
            children: [
              _buildStatTile('${viewModel.episodesWatched ?? 0}',
                  'episodes watched'), //fallback, default
              _buildStatTile('${viewModel.animeInProgress ?? 0}',
                  'anime in progress'), //fallback
              _buildStatTile('${viewModel.animeCompleted ?? 0}',
                  'anime completed'), //fallback
              _buildStatTile('${viewModel.longestStreak ?? 0}',
                  'longest streak'), //fallback
              _buildStatTile(
                  '${viewModel.averageRating?.toInt() ?? 0}%', ////fallback
                  'average rating'),
            ],
          ),
          //favorites section
          const SizedBox(height: 28),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Favorites',
              style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFFBD8DF)),
            ),
          )
        ],
      ),
    );
  }

  // Single stat tile (the pink rounded boxes in the grid)
  Widget _buildStatTile(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF45C82),
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
              color: Color(0xFFFBD8DF),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: Color(0xFFFBD8DF),
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
