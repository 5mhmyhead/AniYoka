import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:aniyoka/utils/season_helper.dart';

class AniListService {
  late final GraphQLClient _client;
  List<dynamic>? _popularAnimeCache;

  AniListService() {
    final httpLink = HttpLink('https://graphql.anilist.co');
    _client = GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }

  Future<List<dynamic>> getPopularAnime() async {
    const query = r'''
      query {
        Page(page: 1, perPage: 10) {
          media(sort: TRENDING_DESC, type: ANIME, isAdult: false) {
            id
            title {
              english
              romaji
            }
            coverImage {
              large
              extraLarge
            }
            bannerImage
            episodes
            status
            format
            startDate {  
              year
            }
          }
        }
      }
    ''';

    final result = await _client.query(QueryOptions(document: gql(query)));
    if (result.hasException) throw Exception(result.exception.toString());
    return result.data!['Page']['media'];
  }

  Future<List<dynamic>> getNewlyAddedAnime() async {
    const query = r'''
      query {
        Page(page: 1, perPage: 10) {
          media(sort: ID_DESC, type: ANIME, isAdult: false) {
            id
            title { english romaji }
            coverImage { large }
            format
            startDate { year }
          }
        }
      }
    ''';

    final result = await _client.query(QueryOptions(document: gql(query)));
    if (result.hasException) throw Exception(result.exception.toString());
    return result.data!['Page']['media'];
  }

  Future<List<dynamic>> getNextSeasonAnime() async {
    final query = '''
      query {
        Page(page: 1, perPage: 10) {
          media(
            season: ${SeasonHelper.nextSeason},
            seasonYear: ${SeasonHelper.nextSeasonYear},
            type: ANIME,
            sort: POPULARITY_DESC, 
            isAdult: false
          ) {
            id
            title { english romaji }
            coverImage { large }
            format
            startDate { year }
          }
        }
      }
    ''';

    final result = await _client.query(QueryOptions(document: gql(query)));
    if (result.hasException) throw Exception(result.exception.toString());
    return result.data!['Page']['media'];
  }

  Future<List<dynamic>> getThisSeasonAnime() async {
    final query = '''
      query {
        Page(page: 1, perPage: 10) {
          media(
            season: ${SeasonHelper.currentSeason},
            seasonYear: ${SeasonHelper.currentYear},
            type: ANIME,
            sort: POPULARITY_DESC, 
            isAdult: false
          ) {
            id
            title { english romaji }
            coverImage { large }
            format
            startDate { year }
          }
        }
      }
    ''';

    final result = await _client.query(QueryOptions(document: gql(query)));
    if (result.hasException) throw Exception(result.exception.toString());
    return result.data!['Page']['media'];
  }

  Future<List<dynamic>> getAiringSoonAnime() async {
    const query = r'''
      query {
        Page(page: 1, perPage: 10) {
          media(status: NOT_YET_RELEASED, type: ANIME, sort: START_DATE, isAdult: false) {
            id
            title { english romaji }
            coverImage { large }
            format
            startDate { year }
          }
        }
      }
    ''';

    final result = await _client.query(QueryOptions(document: gql(query)));
    if (result.hasException) throw Exception(result.exception.toString());
    return result.data!['Page']['media'];
  }

  Future<Map<String, dynamic>> getAnimeDetails(int id) async {
    
    final query = '''
      query {
        Media(id: $id, type: ANIME) {
          id
          title {
            english
            romaji
          }
          coverImage {
            extraLarge
          }
          bannerImage
          format
          season
          seasonYear
          status
          meanScore
          episodes
          rankings {
            rank
            type
            allTime
          }
          description(asHtml: false)
          genres
          recommendations(perPage: 10) {
            nodes {
              mediaRecommendation {
                id
                title { english romaji }
                coverImage { large }
                format
                startDate { year }
              }
            }
          }
        }
      }
    ''';

    final result = await _client.query(QueryOptions(document: gql(query)));
    if (result.hasException) throw Exception(result.exception.toString());
    return result.data!['Media'];
  }

  Future<List<dynamic>> searchAnime(String searchText) async {
    final input = searchText.trim();

    if (input.isEmpty) {
      return [];
    }

    const query = r'''
    query SearchAnime($search: String) {
      page1: Page(page: 1, perPage: 50) {
        media(
          search: $search,
          type: ANIME,
          sort: SEARCH_MATCH,
          isAdult: false
        ) {
          id
          title {
            english
            romaji
            native
          }
          coverImage {
            large
          }
          episodes
          status
        }
      }

      page2: Page(page: 2, perPage: 50) {
        media(
          search: $search,
          type: ANIME,
          sort: SEARCH_MATCH,
          isAdult: false
        ) {
          id
          title {
            english
            romaji
            native
          }
          coverImage {
            large
          }
          episodes
          status
        }
      }

      page3: Page(page: 3, perPage: 50) {
        media(
          search: $search,
          type: ANIME,
          sort: SEARCH_MATCH,
          isAdult: false
        ) {
          id
          title {
            english
            romaji
            native
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
      QueryOptions(
        document: gql(query),
        variables: {
          'search': input,
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final data = result.data ?? {};

    return [
      ...List<dynamic>.from(data['page1']?['media'] ?? []),
      ...List<dynamic>.from(data['page2']?['media'] ?? []),
      ...List<dynamic>.from(data['page3']?['media'] ?? []),
    ];
  }

  Future<List<dynamic>> getPopularAnimeForSearchSuggestions() async {
    if (_popularAnimeCache != null) {
      return _popularAnimeCache!;
    }

    const query = r'''
    query {
      page1: Page(page: 1, perPage: 50) {
        media(type: ANIME, sort: POPULARITY_DESC, isAdult: false) {
          id
          title {
            english
            romaji
            native
          }
          coverImage {
            large
          }
          episodes
          status
        }
      }

      page2: Page(page: 2, perPage: 50) {
        media(type: ANIME, sort: POPULARITY_DESC, isAdult: false) {
          id
          title {
            english
            romaji
            native
          }
          coverImage {
            large
          }
          episodes
          status
        }
      }

      page3: Page(page: 3, perPage: 50) {
        media(type: ANIME, sort: POPULARITY_DESC, isAdult: false) {
          id
          title {
            english
            romaji
            native
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
      QueryOptions(
        document: gql(query),
        fetchPolicy: FetchPolicy.cacheFirst,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final data = result.data ?? {};

    _popularAnimeCache = [
      ...List<dynamic>.from(data['page1']?['media'] ?? []),
      ...List<dynamic>.from(data['page2']?['media'] ?? []),
      ...List<dynamic>.from(data['page3']?['media'] ?? []),
    ];

    return _popularAnimeCache!;
  }
}
