import 'package:stacked/stacked.dart';

class ProfileViewModel extends BaseViewModel {
  // Private fields
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
  final String appVersion = '1.0.0';
  //Public getters for user name
  String? get username => _username;
  String? get email => _email;
  String? get avatarUrl => _avatarUrl;

  //Public getters fro stats
  int? get episodesWatched => _episodesWatched;
  int? get animeInProgress => _animeInProgress;
  int? get animeCompleted => _animeCompleted;
  int? get longestStreak => _longestStreak;
  double? get averageRating => _averageRating;
  int? get totalWatchTimeHours => _totalWatchTimeHours;
  bool get statsHidden => _statsHidden;

  void toggleStatsVisibility() {
    _statsHidden = !_statsHidden;
    notifyListeners(); // rebuilds the View so the grid shows/hides immediately
  }

  // Called once when the ProfileView is first shown
  Future<void> initialise() async {
    setBusy(true);

    //TODO: replace with real user service call later
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

    setBusy(false);
    notifyListeners();
  }
}
