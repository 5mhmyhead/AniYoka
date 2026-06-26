import 'package:stacked/stacked.dart';

class MainViewModel extends BaseViewModel {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  void setPage(int index) {
    _currentPage = index;
    rebuildUi();
  }
}
