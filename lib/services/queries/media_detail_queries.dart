class MediaDetailQueries {
  static const String getMediaDetails = r'''
    query GetMediaDetails($id: Int!) {
      Media(id: $id) {
        id
        type
        title {
          english
          romaji
        }
        coverImage {
          extraLarge
        }
        format
        bannerImage
        description
        countryOfOrigin
        status
        season
        seasonYear
        episodes
        duration
        chapters
        volumes
        source
        meanScore
        averageScore
        popularity
        favourites
        startDate {
          year
          month
          day
        }
        endDate {
          year
          month
          day
        }
      }
    }
  ''';
}
