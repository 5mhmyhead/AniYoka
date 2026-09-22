import 'package:aniyoka/app/app.locator.dart';
import 'package:aniyoka/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked/stacked.dart';

class OverviewTabViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

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

  void onMediaTap(int id) {
    _navigationService.navigateToMediaInfoView(
      mediaId: id,
      preventDuplicates: false,
    );
  }

  void onMediaLongPress(int id) {
    // TODO: change this to have another long press functionality
    _navigationService.navigateToMediaInfoView(
      mediaId: id,
      preventDuplicates: false,
    );
  }
}
