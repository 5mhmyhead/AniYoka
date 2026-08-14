import 'package:stacked/stacked.dart';

class MainViewModel extends BaseViewModel {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  // tracks which tabs have been opened at least once
  // the app only builds the view when visited, and will be kept alive after
  final Set<int> _visitedTabs = {0};
  bool hasVisited(int index) => _visitedTabs.contains(index);

  void setPage(int index) {
    _visitedTabs.add(index);
    _currentPage = index;
    rebuildUi();
  }
}
