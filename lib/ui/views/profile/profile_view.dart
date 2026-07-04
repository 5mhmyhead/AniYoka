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
      dividerColor: Colors.grey.withValues(alpha: 0.3),
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

  Widget _buildMyProfileTab(ProfileViewModel viewModel) {
    // placeholder — add avatar/stats/favorites content here
    return const SizedBox.shrink();
  }

  @override
  ProfileViewModel viewModelBuilder(BuildContext context) => ProfileViewModel();
}
