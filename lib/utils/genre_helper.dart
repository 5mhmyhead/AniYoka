class GenreHelper {
  static const List<String> allGenres = [
    'Action',
    'Adventure',
    'Comedy',
    'Drama',
    'Ecchi',
    'Fantasy',
    'Horror',
    'Mahou Shoujo',
    'Mecha',
    'Music',
    'Mystery',
    'Psychological',
    'Romance',
    'Sci-Fi',
    'Slice of Life',
    'Sports',
    'Supernatural',
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
