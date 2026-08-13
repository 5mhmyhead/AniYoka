// this was originally separated into two anime and manga models,
// but anilist has a dedicated media type that holds both anime and manga.
class Media {
  final int id;
  final String type;
  final String title;
  final String coverImage;
  final String format;
  // if unreleased, rating is made null
  final double? rating;
  final String? countryOfOrigin;

  Media({
    required this.id,
    required this.type,
    required this.title,
    required this.coverImage,
    required this.format,
    // nullable parameters
    this.rating,
    this.countryOfOrigin
  });

  factory Media.fromAniListJson(Map<String, dynamic> json) {
    final id = json['id'] as int? ?? 0;
    final type = json['type'] as String? ?? 'ANIME';

    final title = json['title']?['english'] as String? ??
        json['title']?['romaji'] as String? ??
        'Unknown Title';

    final coverImage = json['coverImage']?['extraLarge'] as String? ??
        json['coverImage']?['large'] as String? ??
        '';

    final rawFormat = json['format'] as String? ?? 'TV';

    final rawScore = (json['averageScore'] as num?)?.toDouble();
    final double? rating = rawScore != null ? rawScore / 10 : null;

    final country = json['countryOfOrigin'] as String?;

    // since AniList defaults any manhwa or manhua to manga,
    // we check the country of origin and change the format accordingly
    final String format;
    if (type == 'MANGA') {
      switch (country) {
        case 'KR': format = 'MANHWA'; break;
        case 'CN': format = 'MANHUA'; break;
        case 'JP': format = 'MANGA'; break;
        default: format = 'MANGA'; break;
      }
    } else {
      format = rawFormat;
    }

    return Media(
      id: id,
      type: type,
      countryOfOrigin: country,
      title: title,
      coverImage: coverImage,
      format: format,
      rating: rating,
    );
  }
}
