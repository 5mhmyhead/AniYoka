import 'package:aniyoka/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:aniyoka/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:aniyoka/ui/views/home/home_view.dart';
import 'package:aniyoka/ui/views/main/main_viewmodel.dart';
import 'package:aniyoka/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:aniyoka/ui/views/main/main_view.dart';
import 'package:aniyoka/ui/views/explore/explore_view.dart';
import 'package:aniyoka/ui/views/watchlist/watchlist_view.dart';
import 'package:aniyoka/ui/views/bookmarks/bookmarks_view.dart';
import 'package:aniyoka/ui/views/profile/profile_view.dart';
import 'package:aniyoka/ui/views/anime_info/anime_info_view.dart';
import 'package:aniyoka/ui/views/anime_list/anime_list_view.dart';

import 'package:aniyoka/services/bookmark_service.dart';
import 'package:aniyoka/services/anilist_service.dart';
import 'package:aniyoka/services/watchlist_service.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView, initial: true),
    MaterialRoute(page: MainView),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: ExploreView),
    MaterialRoute(page: WatchlistView),
    MaterialRoute(page: BookmarksView),
    MaterialRoute(page: ProfileView),
    CustomRoute(page: AnimeInfoView),
    MaterialRoute(page: AnimeListView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: AniListService),
    LazySingleton(classType: BookmarkService),
    LazySingleton(classType: WatchlistService),
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
