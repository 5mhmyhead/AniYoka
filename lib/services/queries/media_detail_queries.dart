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
        genres
        tags {
          name
          isMediaSpoiler
          rank
        }
        relations {
          edges {
            relationType
            node {
              id
              type
              title { 
                english 
                romaji 
              }
              coverImage { 
                large 
              }
              format
              meanScore
            }
          }
        }
        recommendations(perPage: 10) {
          nodes {
            mediaRecommendation {
              id
              type
              title { 
                english 
                romaji 
              }
              coverImage { 
                large 
              }
              format
              meanScore
            }
          }
        }
        nextAiringEpisode {
          airingAt
          timeUntilAiring
          episode
        }
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
