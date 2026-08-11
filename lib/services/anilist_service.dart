import 'package:aniyoka/models/anime_model.dart';
import 'package:aniyoka/services/queries/discover_tab_queries.dart';
import 'package:graphql/client.dart';

class AniListService {
  late final GraphQLClient _client;

  AniListService() {
    final HttpLink httpLink = HttpLink('https://graphql.anilist.co');
    _client = GraphQLClient(link: httpLink, cache: GraphQLCache());
  }

  Future<List<Anime>> fetchTrendingAnime({int page = 1, int perPage = 10}) async {
    final options = QueryOptions(
      document: gql(DiscoverTabQueries.getTrending),
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
