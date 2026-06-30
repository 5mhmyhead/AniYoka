import 'package:graphql_flutter/graphql_flutter.dart';

class AniListService {
  late final GraphQLClient _client;

  AniListService() {
    final httpLink = HttpLink('https://graphql.anilist.co');
    _client = GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }

  Future<List<dynamic>> getTrendingAnime() async {
    const query = r'''
      query {
        Page(page: 1, perPage: 10) {
          media(sort: TRENDING_DESC, type: ANIME) {
            id
            title {
              english
              romaji
            }
            coverImage {
              large
            }
            episodes
            status
          }
        }
      }
    ''';

    final result = await _client.query(
      QueryOptions(document: gql(query)),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return result.data!['Page']['media'];
  }
}
