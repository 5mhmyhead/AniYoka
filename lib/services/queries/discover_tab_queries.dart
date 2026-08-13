class DiscoverTabQueries {
  static const String getTrendingMedia = r'''
    query GetTrendingAnime($type: MediaType $page: Int, $perPage: Int) {
      Page(page: $page, perPage: $perPage) {
        media(type: $type, sort: TRENDING_DESC) {
          id
          type
          countryOfOrigin
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

  static const String getHighestRatedMedia = r'''
    query GetHighestRatedAnime($type: MediaType $page: Int, $perPage: Int) {
      Page(page: $page, perPage: $perPage) {
        media(type: $type, sort: SCORE_DESC) {
          id
          type
          countryOfOrigin
          title {
            english
            romaji
          }
          coverImage {
            large
          }
          format
          averageScore
        }
      }
    }
  ''';

  static const String getSeasonalAnime = r'''
    query GetSeasonalAnime($season: MediaSeason, $seasonYear: Int, $page: Int, $perPage: Int) {
      Page(page: $page, perPage: $perPage) {
        media(type: ANIME, sort: POPULARITY_DESC, season: $season, seasonYear: $seasonYear) {
          id
          title {
            english
            romaji
          }
          coverImage {
            large
          }
          format
          averageScore
        }
      }
    }
  ''';
}
