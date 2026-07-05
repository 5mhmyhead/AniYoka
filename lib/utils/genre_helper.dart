class GenreHelper {
  static const List<String> topGenres = [
    'Action',
    'Adventure',
    'Comedy',
    'Drama',
    'Fantasy',
    'Horror',
    'Mystery',
    'Romance',
    'Sci-Fi',
    'Slice of Life',
    'Sports',
    'Supernatural',
    'Thriller',
    'Psychological',
    'Mecha',
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
