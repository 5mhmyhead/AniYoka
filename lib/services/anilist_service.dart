import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:aniyoka/utils/season_helper.dart';

class AniListService {
  late final GraphQLClient _client;

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
            }
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
}
