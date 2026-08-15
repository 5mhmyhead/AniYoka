// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:aniyoka/ui/views/explore/explore_view.dart' as _i4;
import 'package:aniyoka/ui/views/forum/forum_view.dart' as _i6;
import 'package:aniyoka/ui/views/home/home_view.dart' as _i3;
import 'package:aniyoka/ui/views/library/library_view.dart' as _i5;
import 'package:aniyoka/ui/views/main/main_view.dart' as _i2;
import 'package:aniyoka/ui/views/media_info/media_info_view.dart' as _i8;
import 'package:aniyoka/ui/views/profile/profile_view.dart' as _i7;
import 'package:flutter/material.dart' as _i9;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i10;

class Routes {
  static const mainView = '/main-view';

  static const homeView = '/home-view';

  static const exploreView = '/explore-view';

  static const libraryView = '/library-view';

  static const forumView = '/forum-view';

  static const profileView = '/profile-view';

  static const mediaInfoView = '/media-info-view';

  static const all = <String>{
    mainView,
    homeView,
    exploreView,
    libraryView,
    forumView,
    profileView,
    mediaInfoView,
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
      Routes.libraryView,
      page: _i5.LibraryView,
    ),
    _i1.RouteDef(
      Routes.forumView,
      page: _i6.ForumView,
    ),
    _i1.RouteDef(
      Routes.profileView,
      page: _i7.ProfileView,
    ),
    _i1.RouteDef(
      Routes.mediaInfoView,
      page: _i8.MediaInfoView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.MainView: (data) {
      final args = data.getArgs<MainViewArguments>(
        orElse: () => const MainViewArguments(),
      );
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.MainView(key: args.key),
        settings: data,
      );
    },
    _i3.HomeView: (data) {
      final args = data.getArgs<HomeViewArguments>(
        orElse: () => const HomeViewArguments(),
      );
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => _i3.HomeView(key: args.key),
        settings: data,
      );
    },
    _i4.ExploreView: (data) {
      final args = data.getArgs<ExploreViewArguments>(
        orElse: () => const ExploreViewArguments(),
      );
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => _i4.ExploreView(key: args.key),
        settings: data,
      );
    },
    _i5.LibraryView: (data) {
      final args = data.getArgs<LibraryViewArguments>(
        orElse: () => const LibraryViewArguments(),
      );
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => _i5.LibraryView(key: args.key),
        settings: data,
      );
    },
    _i6.ForumView: (data) {
      final args = data.getArgs<ForumViewArguments>(
        orElse: () => const ForumViewArguments(),
      );
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => _i6.ForumView(key: args.key),
        settings: data,
      );
    },
    _i7.ProfileView: (data) {
      final args = data.getArgs<ProfileViewArguments>(
        orElse: () => const ProfileViewArguments(),
      );
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => _i7.ProfileView(key: args.key),
        settings: data,
      );
    },
    _i8.MediaInfoView: (data) {
      final args = data.getArgs<MediaInfoViewArguments>(nullOk: false);
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i8.MediaInfoView(key: args.key, mediaId: args.mediaId),
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

  final _i9.Key? key;

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

  final _i9.Key? key;

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

  final _i9.Key? key;

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

class LibraryViewArguments {
  const LibraryViewArguments({this.key});

  final _i9.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant LibraryViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class ForumViewArguments {
  const ForumViewArguments({this.key});

  final _i9.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ForumViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class ProfileViewArguments {
  const ProfileViewArguments({this.key});

  final _i9.Key? key;

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

class MediaInfoViewArguments {
  const MediaInfoViewArguments({
    this.key,
    required this.mediaId,
  });

  final _i9.Key? key;

  final int mediaId;

  @override
  String toString() {
    return '{"key": "$key", "mediaId": "$mediaId"}';
  }

  @override
  bool operator ==(covariant MediaInfoViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.mediaId == mediaId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ mediaId.hashCode;
  }
}

extension NavigatorStateExtension on _i10.NavigationService {
  Future<dynamic> navigateToMainView({
    _i9.Key? key,
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
    _i9.Key? key,
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
    _i9.Key? key,
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

  Future<dynamic> navigateToLibraryView({
    _i9.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.libraryView,
        arguments: LibraryViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToForumView({
    _i9.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.forumView,
        arguments: ForumViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToProfileView({
    _i9.Key? key,
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

  Future<dynamic> navigateToMediaInfoView({
    _i9.Key? key,
    required int mediaId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.mediaInfoView,
        arguments: MediaInfoViewArguments(key: key, mediaId: mediaId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMainView({
    _i9.Key? key,
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
    _i9.Key? key,
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
    _i9.Key? key,
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

  Future<dynamic> replaceWithLibraryView({
    _i9.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.libraryView,
        arguments: LibraryViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithForumView({
    _i9.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.forumView,
        arguments: ForumViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithProfileView({
    _i9.Key? key,
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

  Future<dynamic> replaceWithMediaInfoView({
    _i9.Key? key,
    required int mediaId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.mediaInfoView,
        arguments: MediaInfoViewArguments(key: key, mediaId: mediaId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
