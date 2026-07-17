enum AnimeListType {
  popular,
  thisSeason,
  nextSeason,
  newlyAdded,
  airingSoon,
  topRated,
  airing,
  season,
}

class AnimeListFilter {
  final AnimeListType type;
  final String title;
  final String? season;

  const AnimeListFilter({
    required this.type,
    required this.title,
    this.season,
  });
}