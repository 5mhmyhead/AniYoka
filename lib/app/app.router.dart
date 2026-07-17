// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:aniyoka/ui/views/anime_info/anime_info_view.dart' as _i8;
import 'package:aniyoka/ui/views/anime_list/anime_list_view.dart' as _i9;
import 'package:aniyoka/ui/views/bookmarks/bookmarks_view.dart' as _i6;
import 'package:aniyoka/ui/views/explore/explore_view.dart' as _i4;
import 'package:aniyoka/ui/views/home/home_view.dart' as _i3;
import 'package:aniyoka/ui/views/main/main_view.dart' as _i2;
import 'package:aniyoka/ui/views/profile/profile_view.dart' as _i7;
import 'package:aniyoka/ui/views/watchlist/watchlist_view.dart' as _i5;
import 'package:aniyoka/utils/anime_list_helper.dart' as _i11;
import 'package:flutter/material.dart' as _i10;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i12;

class Routes {
  static const mainView = '/';

  static const homeView = '/home-view';

  static const exploreView = '/explore-view';

  static const watchlistView = '/watchlist-view';

  static const bookmarksView = '/bookmarks-view';

  static const profileView = '/profile-view';

  static const animeInfoView = '/anime-info-view';

  static const animeListView = '/anime-list-view';

  static const all = <String>{
    mainView,
    homeView,
    exploreView,
    watchlistView,
    bookmarksView,
    profileView,
    animeInfoView,
    animeListView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.mainView,
      page: _i2.MainView,
    ),
    _i1.RouteDef(
      Routes.homeView,
      page: _i3.HomeView,
    ),
    _i1.RouteDef(
      Routes.exploreView,
      page: _i4.ExploreView,
    ),
    _i1.RouteDef(
      Routes.watchlistView,
      page: _i5.WatchlistView,
    ),
    _i1.RouteDef(
      Routes.bookmarksView,
      page: _i6.BookmarksView,
    ),
    _i1.RouteDef(
      Routes.profileView,
      page: _i7.ProfileView,
    ),
    _i1.RouteDef(
      Routes.animeInfoView,
      page: _i8.AnimeInfoView,
    ),
    _i1.RouteDef(
      Routes.animeListView,
      page: _i9.AnimeListView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.MainView: (data) {
      final args = data.getArgs<MainViewArguments>(
        orElse: () => const MainViewArguments(),
      );
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.MainView(key: args.key),
        settings: data,
      );
    },
    _i3.HomeView: (data) {
      final args = data.getArgs<HomeViewArguments>(
        orElse: () => const HomeViewArguments(),
      );
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => _i3.HomeView(key: args.key),
        settings: data,
      );
    },
    _i4.ExploreView: (data) {
      final args = data.getArgs<ExploreViewArguments>(
        orElse: () => const ExploreViewArguments(),
      );
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => _i4.ExploreView(key: args.key),
        settings: data,
      );
    },
    _i5.WatchlistView: (data) {
      final args = data.getArgs<WatchlistViewArguments>(
        orElse: () => const WatchlistViewArguments(),
      );
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => _i5.WatchlistView(
            key: args.key, onNavigateToExplore: args.onNavigateToExplore),
        settings: data,
      );
    },
    _i6.BookmarksView: (data) {
      final args = data.getArgs<BookmarksViewArguments>(
        orElse: () => const BookmarksViewArguments(),
      );
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => _i6.BookmarksView(
            key: args.key, onNavigateToExplore: args.onNavigateToExplore),
        settings: data,
      );
    },
    _i7.ProfileView: (data) {
      final args = data.getArgs<ProfileViewArguments>(
        orElse: () => const ProfileViewArguments(),
      );
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) => _i7.ProfileView(key: args.key),
        settings: data,
      );
    },
    _i8.AnimeInfoView: (data) {
      final args = data.getArgs<AnimeInfoViewArguments>(nullOk: false);
      return _i10.PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _i8.AnimeInfoView(key: args.key, animeId: args.animeId),
        settings: data,
        transitionsBuilder: data.transition ??
            (context, animation, secondaryAnimation, child) {
              return child;
            },
      );
    },
    _i9.AnimeListView: (data) {
      final args = data.getArgs<AnimeListViewArguments>(nullOk: false);
      return _i10.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i9.AnimeListView(key: args.key, filter: args.filter),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class MainViewArguments {
  const MainViewArguments({this.key});

  final _i10.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant MainViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class HomeViewArguments {
  const HomeViewArguments({this.key});

  final _i10.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant HomeViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class ExploreViewArguments {
  const ExploreViewArguments({this.key});

  final _i10.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ExploreViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class WatchlistViewArguments {
  const WatchlistViewArguments({
    this.key,
    this.onNavigateToExplore,
  });

  final _i10.Key? key;

  final void Function()? onNavigateToExplore;

  @override
  String toString() {
    return '{"key": "$key", "onNavigateToExplore": "$onNavigateToExplore"}';
  }

  @override
  bool operator ==(covariant WatchlistViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.onNavigateToExplore == onNavigateToExplore;
  }

  @override
  int get hashCode {
    return key.hashCode ^ onNavigateToExplore.hashCode;
  }
}

class BookmarksViewArguments {
  const BookmarksViewArguments({
    this.key,
    this.onNavigateToExplore,
  });

  final _i10.Key? key;

  final void Function()? onNavigateToExplore;

  @override
  String toString() {
    return '{"key": "$key", "onNavigateToExplore": "$onNavigateToExplore"}';
  }

  @override
  bool operator ==(covariant BookmarksViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.onNavigateToExplore == onNavigateToExplore;
  }

  @override
  int get hashCode {
    return key.hashCode ^ onNavigateToExplore.hashCode;
  }
}

class ProfileViewArguments {
  const ProfileViewArguments({this.key});

  final _i10.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ProfileViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class AnimeInfoViewArguments {
  const AnimeInfoViewArguments({
    this.key,
    required this.animeId,
  });

  final _i10.Key? key;

  final int animeId;

  @override
  String toString() {
    return '{"key": "$key", "animeId": "$animeId"}';
  }

  @override
  bool operator ==(covariant AnimeInfoViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.animeId == animeId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ animeId.hashCode;
  }
}

class AnimeListViewArguments {
  const AnimeListViewArguments({
    this.key,
    required this.filter,
  });

  final _i10.Key? key;

  final _i11.AnimeListFilter filter;

  @override
  String toString() {
    return '{"key": "$key", "filter": "$filter"}';
  }

  @override
  bool operator ==(covariant AnimeListViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.filter == filter;
  }

  @override
  int get hashCode {
    return key.hashCode ^ filter.hashCode;
  }
}

extension NavigatorStateExtension on _i12.NavigationService {
  Future<dynamic> navigateToMainView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.mainView,
        arguments: MainViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToHomeView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.homeView,
        arguments: HomeViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToExploreView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.exploreView,
        arguments: ExploreViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToWatchlistView({
    _i10.Key? key,
    void Function()? onNavigateToExplore,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.watchlistView,
        arguments: WatchlistViewArguments(
            key: key, onNavigateToExplore: onNavigateToExplore),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToBookmarksView({
    _i10.Key? key,
    void Function()? onNavigateToExplore,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.bookmarksView,
        arguments: BookmarksViewArguments(
            key: key, onNavigateToExplore: onNavigateToExplore),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToProfileView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.profileView,
        arguments: ProfileViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAnimeInfoView({
    _i10.Key? key,
    required int animeId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.animeInfoView,
        arguments: AnimeInfoViewArguments(key: key, animeId: animeId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAnimeListView({
    _i10.Key? key,
    required _i11.AnimeListFilter filter,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.animeListView,
        arguments: AnimeListViewArguments(key: key, filter: filter),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMainView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.mainView,
        arguments: MainViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomeView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.homeView,
        arguments: HomeViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithExploreView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.exploreView,
        arguments: ExploreViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithWatchlistView({
    _i10.Key? key,
    void Function()? onNavigateToExplore,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.watchlistView,
        arguments: WatchlistViewArguments(
            key: key, onNavigateToExplore: onNavigateToExplore),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithBookmarksView({
    _i10.Key? key,
    void Function()? onNavigateToExplore,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.bookmarksView,
        arguments: BookmarksViewArguments(
            key: key, onNavigateToExplore: onNavigateToExplore),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithProfileView({
    _i10.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.profileView,
        arguments: ProfileViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAnimeInfoView({
    _i10.Key? key,
    required int animeId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.animeInfoView,
        arguments: AnimeInfoViewArguments(key: key, animeId: animeId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAnimeListView({
    _i10.Key? key,
    required _i11.AnimeListFilter filter,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.animeListView,
        arguments: AnimeListViewArguments(key: key, filter: filter),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
