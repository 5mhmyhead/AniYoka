import 'package:aniyoka/utils/genre_helper.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:aniyoka/utils/season_helper.dart';

class AniListService {
  late final GraphQLClient _client;
  final Map<String, List<dynamic>> _popularAnimeCache = {};

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
          media(status: NOT_YET_RELEASED, type: ANIME, sort: POPULARITY_DESC, isAdult: false) {
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
          meanScore
          episodes
          seasonYear
          season
          format
          genres
          status
          popularity
          favourites
          tags {
            name
            isMediaSpoiler
            rank
          }
          rankings {
            rank
            type
            allTime
          }
          nextAiringEpisode {
            timeUntilAiring
            episode
          }
          description(asHtml: false)
          duration
          startDate { year month day }
          endDate { year month day }
          source
          relations {
            edges {
              relationType
              node {
                id
                type
                title { english romaji }
                coverImage { large }
                format
                startDate { year }
              }
            }
          }
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

 Future<List<dynamic>> getAnimeByGenreAndSort({
    required String genre,
    required String sort,
    bool isThisSeason = false,
    int? year,
    String? season,
  }) async {
    String seasonFilter = '';

    if (isThisSeason) {
      seasonFilter = '''
        season: ${SeasonHelper.currentSeason}
        seasonYear: ${SeasonHelper.currentYear}
      ''';
    } else {
      if (season != null) seasonFilter += 'season: $season\n';
      if (year != null) seasonFilter += 'seasonYear: $year\n';
    }

    final query = '''
      query {
        Page(page: 1, perPage: 20) {
          media(
            genre: "$genre"
            type: ANIME
            sort: $sort
            isAdult: false
            $seasonFilter
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

    final result = await _client.query(
      QueryOptions(
        document: gql(query),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    if (result.hasException) throw Exception(result.exception.toString());
    return result.data!['Page']['media'];
  }

  Future<List<dynamic>> searchAnime(
    String searchText, {
    String? status,
    String? genre,
    String? format,
    String sort = 'SEARCH_MATCH',
  }) async {
    final input = searchText.trim();

    if (input.isEmpty) {
      return [];
    }

    const query = r'''
      query SearchAnime(
        $search: String
        $status: MediaStatus
        $genre: String
        $format: MediaFormat
        $sort: [MediaSort]
      ) {
        Page(page: 1, perPage: 40) {
          media(
            search: $search,
            type: ANIME,
            status: $status,
            genre: $genre,
            format: $format,
            sort: $sort,
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
            format
          }
        }
      }
    ''';

    final result = await _client.query(
      QueryOptions(
        document: gql(query),
        variables: {
          'search': input,
          'status': status,
          'genre': genre,
          'format': format,
          'sort': [sort],
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return List<dynamic>.from(result.data?['Page']?['media'] ?? []);
  }

  Future<List<dynamic>> getPopularAnimeForSearchSuggestions({
    String? status,
    String? genre,
    String? format,
  }) async {
    final cacheKey = '${status ?? 'any'}|${genre ?? 'any'}|${format ?? 'any'}';

    if (_popularAnimeCache.containsKey(cacheKey)) {
      return _popularAnimeCache[cacheKey]!;
    }

    const query = r'''
      query PopularAnimeForSearchSuggestions(
        $status: MediaStatus
        $genre: String
        $format: MediaFormat
      ) {
        Page(page: 1, perPage: 40) {
          media(
            type: ANIME,
            status: $status,
            genre: $genre,
            format: $format,
            sort: POPULARITY_DESC,
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
            format
          }
        }
      }
    ''';

    final result = await _client.query(
      QueryOptions(
        document: gql(query),
        variables: {
          'status': status,
          'genre': genre,
          'format': format,
        },
        fetchPolicy: FetchPolicy.cacheFirst,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    _popularAnimeCache[cacheKey] =
        List<dynamic>.from(result.data?['Page']?['media'] ?? []);

    return _popularAnimeCache[cacheKey]!;
  }
}
