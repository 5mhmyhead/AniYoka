class DiscoverTabQueries {
  static const String getTrendingAnime = r'''
    query GetTrendingAnime($page: Int, $perPage: Int) {
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
