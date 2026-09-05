import 'package:stacked/stacked.dart';

class OverviewTabViewModel extends BaseViewModel {
  bool _isDescriptionExpanded = false;
  bool get isDescriptionExpanded => _isDescriptionExpanded;

  bool _showSpoilerTags = false;
  bool get showSpoilerTags => _showSpoilerTags;
  
  void toggleDescription() {
    _isDescriptionExpanded = !_isDescriptionExpanded;
    rebuildUi();
  }

  void toggleSpoilerTags() {
    _showSpoilerTags = !_showSpoilerTags;
    rebuildUi();
  }
}
