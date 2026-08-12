// this was originally separated into two anime and manga models,
// but anilist has a dedicated media type that holds both anime and manga.
class Media {
  final int id;
  final String type;
  final String title;
  final String coverImage;
  final String format;
  final double rating;

  Media({
    required this.id,
    required this.type,
    required this.title,
    required this.coverImage,
    required this.format,
    required this.rating,
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

    final format = json['format'] as String? ?? 'TV';
    final rating = ((json['averageScore'] as num?)?.toDouble() ?? 0.0) / 10;

    return Media(
      id: id,
      type: type,
      title: title,
      coverImage: coverImage,
      format: format,
      rating: rating,
    );
  }
}
