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

  // Called once when the ProfileView is first shown
  Future<void> initialise() async {
    setBusy(true);

    //TODO: replace with real user service call later
    await Future.delayed(const Duration(milliseconds: 500));
    _username = 'sanxwich';
    _email = 'sanxwich@gmail.com';
    _avatarUrl = null;

    _episodesWatched = 27;
    _animeInProgress = 1;
    _animeCompleted = 1;
    _longestStreak = 2;
    _averageRating = 30;

    setBusy(false);
    notifyListeners();
  }
}
