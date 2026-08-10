import 'package:aniyoka/models/anime_model.dart';
import 'package:graphql/client.dart';

class AniListService {
  late final GraphQLClient _client;

  AniListService() {
    final HttpLink httpLink = HttpLink('https://graphql.anilist.co');
    _client = GraphQLClient(link: httpLink, cache: GraphQLCache());
  }

  static const String _trendingQuery = r'''
    query GetTrending($page: Int, $perPage: Int) {
      Page(page: $page, perPage: $perPage) {
        media(type: ANIME, sort: TRENDING_DESC) {
          id
          title {
            english
            romaji
          }
          coverImage {
            extraLarge
          }
          format
          averageScore
        }
      }
    }
  ''';

  Future<List<Anime>> fetchTrendingAnime(
      {int page = 1, int perPage = 10}) async {
    final options = QueryOptions(
      document: gql(_trendingQuery),
      variables: {'page': page, 'perPage': perPage},
    );

    final result = await _client.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final List list = result.data?['Page']?['media'] ?? [];
    return list.map((item) => Anime.fromAniListJson(item)).toList();
  }
}
