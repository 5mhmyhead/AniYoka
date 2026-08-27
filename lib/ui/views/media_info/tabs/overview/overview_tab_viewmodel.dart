import 'package:stacked/stacked.dart';

class OverviewTabViewModel extends BaseViewModel {
  bool _isDescriptionExpanded = false;
  bool get isDescriptionExpanded => _isDescriptionExpanded;
  
  void toggleDescription() {
    _isDescriptionExpanded = !_isDescriptionExpanded;
    rebuildUi();
  }
}
