import 'package:aniyoka/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:aniyoka/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:aniyoka/ui/views/main/main_view.dart';
import 'package:aniyoka/ui/views/home/home_view.dart';
import 'package:aniyoka/ui/views/explore/explore_view.dart';
import 'package:aniyoka/ui/views/library/library_view.dart';
import 'package:aniyoka/ui/views/forum/forum_view.dart';
import 'package:aniyoka/ui/views/profile/profile_view.dart';
import 'package:aniyoka/services/anilist_service.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: MainView),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: ExploreView),
    MaterialRoute(page: LibraryView),
    MaterialRoute(page: ForumView),
    MaterialRoute(page: ProfileView),
    // @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: AniListService)
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
