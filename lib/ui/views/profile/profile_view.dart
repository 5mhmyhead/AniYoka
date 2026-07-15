import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'profile_viewmodel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
                      child: _buildTabContent(viewModel, context),
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
  Widget _buildTabContent(ProfileViewModel viewModel, BuildContext context) {
    return TabBarView(
      children: [
        _buildMyProfileTab(viewModel),
        const Center(
          child: Text('Recent Activity', style: TextStyle(color: kcOffWhite)),
        ),
        _buildSettingsTab(context, viewModel),
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
            padding: const EdgeInsets.all(6),
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

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  viewModel.statsHidden
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: kcLightGrey,
                ),
                onPressed: viewModel.toggleStatsVisibility,
              ),
            ],
          ),

          // ── Stats grid (only builds if not hidden) ──
          if (!viewModel.statsHidden)
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
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
                _buildStatTile(
                    '${viewModel.totalWatchTimeHours ?? 0} hrs', 'watch time'),
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

  // SETTINGS TAB
  Widget _buildSettingsTab(BuildContext context, ProfileViewModel viewModel) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      children: [
        _SingleSection(
          title: "Account",
          children: [
            _CustomListTile(
              title: "Manage Account Settings",
              icon: Icons.account_circle_outlined,
            ),
            _CustomListTile(
              title: "Password & Security",
              icon: Icons.lock_outline_rounded,
            ),
            _CustomListTile(
              title: "Notifications",
              icon: Icons.notifications_none_rounded,
            ),
            _CustomListTile(title: "Log out", icon: Icons.logout)
          ],
        ),
        Divider(color: kcLightGrey),
        _SingleSection(
          title: "Prefrances ",
          children: [
            _CustomListTile(
              title: "Change Profile Picture",
              icon: Icons.person_outline_rounded,
            ),
            _CustomListTile(
              title: "Change Profile color",
              icon: Icons.color_lens_outlined,
            ),
            _CustomListTile(title: "Score Format", icon: Icons.star_border)
          ],
        ),
        Divider(color: kcLightGrey),
        _SingleSection(
          title: "Information",
          children: [
            _CustomListTile(
              title: "Github Repository",
              icon: FontAwesomeIcons.github,
              onTap: () => _showGithubDialog(context),
            ),
            _CustomListTile(
              title: "Help & Feedback",
              icon: Icons.help_outline_rounded,
              onTap: () => _showHelpFeedbackDialog(context),
            ),
            _CustomListTile(
              title: "About",
              icon: Icons.info_outline_rounded,
              onTap: () => _showAboutDialog(context),
            ),
            _CustomListTile(
                title: "Developed by VIVII", icon: Icons.code_rounded),
            _CustomListTile(
              title: "App Version",
              icon: FontAwesomeIcons.codeBranch,
              subtitle: viewModel.appVersion,
            ),
          ],
        ),
      ],
    );
  }

// Confirmation dialog before leaving the app for GitHub Repository
  void _showGithubDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: kcSurfaceColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                FontAwesomeIcons.github,
                color: kcPrimaryPink,
                size: 54,
              ),
              const SizedBox(height: 4),
              Text(
                'Leave AniYoka?',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: kcPrimaryPink,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'This will open your browser to view the GitHub repository.',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: kcOffWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: kcTertiaryPink,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            color: kcSurfaceColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _openUrl('https://github.com/5mhmyhead/AniYoka');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: kcPrimaryPink,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          'Continue',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            color: kcOffWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Confirmation dialog before leaving the app for Help & Feedback
  void _showHelpFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: kcSurfaceColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.help_outline_rounded,
                color: kcPrimaryPink,
                size: 54,
              ),
              const SizedBox(height: 4),
              Text(
                'Leave AniYoka?',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: kcPrimaryPink,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'This will open your  email app to report a bug or send feedback.',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: kcOffWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: kcTertiaryPink,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            color: kcSurfaceColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _openUrl(
                            'mailto:sanxwich89@gmail.com?subject=AniYoka Feedback and Bug Reports&body=Describe your issue or feedback here:');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: kcPrimaryPink,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          'Continue',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            color: kcOffWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // About dialog
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: kcSurfaceColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: kcPrimaryPink,
                size: 54,
              ),
              const SizedBox(height: 4),
              Text(
                'AniYoka',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: kcPrimaryPink,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Version 1.0.0',
                style: GoogleFonts.nunito(
                  color: kcPrimaryPink,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'AniYoka helps you track, discover, and organize the anime you watch. Keep your watchlist up to date, monitor your progress, and never miss an episode.',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: kcOffWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Divider(color: kcLightGrey.withValues(alpha: 0.3)),
              const SizedBox(height: 12),
              Text(
                'Developed by group VIVII',
                style: GoogleFonts.nunito(
                  color: kcLightGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: kcPrimaryPink,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      'Close',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        color: kcOffWhite,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Opens git repository URL in the browser/app
  Future<void> _openUrl(String url) async {
    debugPrint('Attempting to open: $url');
    final uri = Uri.parse(url);
    final success = await launchUrl(uri, mode: LaunchMode.externalApplication);
    debugPrint('Launch result: $success');
  }

  @override
  void onViewModelReady(ProfileViewModel viewModel) => viewModel.initialise();

  @override
  ProfileViewModel viewModelBuilder(BuildContext context) => ProfileViewModel();
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _CustomListTile({
    required this.title,
    required this.icon,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.inter(
            color: kcTertiaryPink, fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: GoogleFonts.inter(color: kcPrimaryPink, fontSize: 13),
            )
          : null,
      leading: Icon(icon, color: kcPrimaryPink),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kcLightGrey,
              ),
            ),
          ),
        Column(children: children),
      ],
    );
  }
}
