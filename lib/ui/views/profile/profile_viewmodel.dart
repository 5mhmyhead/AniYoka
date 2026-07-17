import 'package:aniyoka/services/recent_activity_service.dart';
import 'package:stacked/stacked.dart';

class ProfileViewModel extends BaseViewModel {
  final RecentActivityService _recentActivityService = RecentActivityService();

  // Private profile fields.
  String? _username;
  String? _email;
  String? _avatarUrl;
  int? _episodesWatched;
  int? _animeInProgress;
  int? _animeCompleted;
  int? _longestStreak;
  double? _averageRating;
  int? _totalWatchTimeHours;
  bool _statsHidden = false;

  List<RecentActivityEntry> _recentActivities = [];
  bool _activitiesLoading = false;

  final String appVersion = '1.0.0';

  String? get username => _username;
  String? get email => _email;
  String? get avatarUrl => _avatarUrl;

  int? get episodesWatched => _episodesWatched;
  int? get animeInProgress => _animeInProgress;
  int? get animeCompleted => _animeCompleted;
  int? get longestStreak => _longestStreak;
  double? get averageRating => _averageRating;
  int? get totalWatchTimeHours => _totalWatchTimeHours;
  bool get statsHidden => _statsHidden;

  List<RecentActivityEntry> get recentActivities =>
      List<RecentActivityEntry>.unmodifiable(_recentActivities);
  bool get activitiesLoading => _activitiesLoading;

  void toggleStatsVisibility() {
    _statsHidden = !_statsHidden;
    rebuildUi();
  }

  Future<void> initialise() async {
    setBusy(true);

    // replace these temporary values with a user service later.
    await Future.delayed(const Duration(milliseconds: 500));
    _username = 'sanxwich';
    _email = 'sanxwich@gmail.com';
    _avatarUrl = null;

    _episodesWatched = 0;
    _animeInProgress = 0;
    _animeCompleted = 0;
    _longestStreak = 0;
    _averageRating = 0;
    _totalWatchTimeHours = 0;

    await loadRecentActivities(notify: false);

    setBusy(false);
    rebuildUi();
  }

  Future<void> loadRecentActivities({bool notify = true}) async {
    _activitiesLoading = true;
    if (notify) rebuildUi();

    try {
      _recentActivities = await _recentActivityService.getActivities();
    } finally {
      _activitiesLoading = false;
      if (notify) rebuildUi();
    }
  }

  Future<void> clearRecentActivities() async {
    await _recentActivityService.clearActivities();
    _recentActivities = [];
    rebuildUi();
  }
}
