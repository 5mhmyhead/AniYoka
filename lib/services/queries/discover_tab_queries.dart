class DiscoverTabQueries {
  static const String getTrending = r'''
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
}