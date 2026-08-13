import 'package:aniyoka/models/media_model.dart';
import 'package:aniyoka/services/queries/discover_tab_queries.dart';
import 'package:aniyoka/ui/helpers/season_helper.dart';
import 'package:graphql/client.dart';

class AniListService {
  late final GraphQLClient _client;

  AniListService() {
    final HttpLink httpLink = HttpLink('https://graphql.anilist.co');
    _client = GraphQLClient(link: httpLink, cache: GraphQLCache());
  }

  Future<List<Media>> _queryMediaList({
    required String queryDocument,
    required Map<String, dynamic> variables,
  }) async {
    final options = QueryOptions(
      document: gql(queryDocument),
      variables: variables,
    );

    final result = await _client.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final List list = result.data?['Page']?['media'] ?? [];
    return list.map((item) => Media.fromAniListJson(item)).toList();
  }

  Future<List<Media>> fetchTrendingAnime({int page = 1, int perPage = 10}) {
    return _queryMediaList(
      queryDocument: DiscoverTabQueries.getTrendingMedia,
      variables: {'type': 'ANIME', 'page': page, 'perPage': perPage},
    );
  }

  Future<List<Media>> fetchTrendingManga({int page = 1, int perPage = 10}) {
    return _queryMediaList(
      queryDocument: DiscoverTabQueries.getTrendingMedia,
      variables: {'type': 'MANGA', 'page': page, 'perPage': perPage},
    );
  }

  Future<List<Media>> fetchHighestRatedManga({int page = 1, int perPage = 10}) {
    return _queryMediaList(
      queryDocument: DiscoverTabQueries.getHighestRatedMedia,
      variables: {'type': 'MANGA', 'page': page, 'perPage': perPage},
    );
  }

  Future<List<Media>> fetchThisSeasonAnime({
    Season? season,
    int? seasonYear,
    int page = 1,
    int perPage = 10,
  }) {
    season ??= SeasonHelper.getCurrentSeason();
    seasonYear ??= SeasonHelper.getCurrentSeasonYear();

    return _queryMediaList(
      queryDocument: DiscoverTabQueries.getSeasonalAnime,
      variables: {
        'season': season.name,
        'seasonYear': seasonYear,
        'page': page,
        'perPage': perPage,
      },
    );
  }

  Future<List<Media>> fetchNextSeasonAnime({
    Season? season,
    int? seasonYear,
    int page = 1,
    int perPage = 10,
  }) {
    season ??= SeasonHelper.getNextSeason();
    seasonYear ??= SeasonHelper.getNextSeasonYear();

    return _queryMediaList(
      queryDocument: DiscoverTabQueries.getSeasonalAnime,
      variables: {
        'season': season.name,
        'seasonYear': seasonYear,
        'page': page,
        'perPage': perPage,
      },
    );
  }
}
