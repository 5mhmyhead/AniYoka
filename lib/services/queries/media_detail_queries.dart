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
        countryOfOrigin
      }
    }
  ''';
}
