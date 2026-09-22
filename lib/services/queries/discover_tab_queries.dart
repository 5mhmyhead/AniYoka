class DiscoverTabQueries {
  static const String getDiscoverTab = r'''
    query GetDiscoverTab(
      $season: MediaSeason
      $seasonYear: Int
      $nextSeason: MediaSeason
      $nextSeasonYear: Int
      $perPage: Int
    ) {
      trendingAnime: Page(perPage: $perPage) {
        media(type: ANIME, sort: TRENDING_DESC) {
          ...MediaFields
        }
      }
      trendingManga: Page(perPage: $perPage) {
        media(type: MANGA, sort: TRENDING_DESC) {
          ...MediaFields
        }
      }
      thisSeason: Page(perPage: $perPage) {
        media(type: ANIME, season: $season, seasonYear: $seasonYear, sort: POPULARITY_DESC) {
          ...MediaFields
        }
      }
      nextSeason: Page(perPage: $perPage) {
        media(type: ANIME, season: $nextSeason, seasonYear: $nextSeasonYear, sort: POPULARITY_DESC) {
          ...MediaFields
        }
      }
      highestRatedManga: Page(perPage: $perPage) {
        media(type: MANGA, sort: SCORE_DESC) {
          ...MediaFields
        }
      }
    }

    fragment MediaFields on Media {
      id
      type
      countryOfOrigin
      title { 
        english 
        romaji 
      }
      coverImage { 
        large
        extraLarge 
      }
      format
      averageScore
    }
  ''';

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
