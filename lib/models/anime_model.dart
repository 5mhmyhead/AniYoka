class Anime {
  final int id;
  final String title;
  final String coverImage;
  final String format;
  final double rating;

  Anime({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.format,
    required this.rating,
  });

  factory Anime.fromAniListJson(Map<String, dynamic> json) {
    final id = json['id'] as int? ?? 0;
    
    final title = json['title']?['english'] as String? ??
                  json['title']?['romaji'] as String? ??
                  'Unknown Title';

    final coverImage = json['coverImage']?['extraLarge'] as String? ??
                       json['coverImage']?['large'] as String? ??
                       '';

    final format = json['format'] as String? ?? 'TV';
    final rating = ((json['averageScore'] as num?)?.toDouble() ?? 0.0) / 10;

    return Anime(
      id: id,
      title: title,
      coverImage: coverImage,
      format: format,
      rating: rating,
    );
  }
}
