class GenreHelper {
  static const List<String> topGenres = [
    'Action',
    'Romance',
    'Comedy',
    'Drama',
    'Fantasy',
    'Horror',
    'Thriller',
  ];
}

enum GenreFilter {
  popularity,
  currentSeason,
  topRated,
}

extension GenreFilterLabel on GenreFilter {
  String get label {
    switch (this) {
      case GenreFilter.popularity:
        return 'Popular';
      case GenreFilter.currentSeason:
        return 'This Season';
      case GenreFilter.topRated:
        return 'Top Rated';
    }
  }
}
