// this was originally separated into two anime and manga models,
// but anilist has a dedicated media type that holds both anime and manga.
import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:aniyoka/ui/helpers/media_classes.dart';

class Media {
  final int id;
  final String type;
  final String title;
  final String coverImage;
  final String format;
  // nullable parameters
  // if unreleased, rating is made null
  final String? bannerImage;
  final String? description;
  final String? countryOfOrigin;
  final String? status;
  final String? season;
  final String? source;
  final double? rating;
  final int? seasonYear;
  final int? episodes;
  final int? duration;
  final int? chapters;
  final int? volumes;
  final int? meanScore;
  final int? averageScore;
  final int? popularity;
  final int? favourites;
  final List<String>? genres;
  final List<MediaTag>? tags;
  final FuzzyDate? startDate;
  final FuzzyDate? endDate;
  final NextAiring? nextAiringEpisode;

  Media({
    required this.id,
    required this.type,
    required this.title,
    required this.coverImage,
    required this.format,
    // nullable parameters
    this.bannerImage,
    this.description,
    this.countryOfOrigin,
    this.status,
    this.season,
    this.source,
    this.rating,
    this.episodes,
    this.duration,
    this.chapters,
    this.volumes,
    this.meanScore,
    this.averageScore,
    this.popularity,
    this.favourites,
    this.genres,
    this.tags,
    this.seasonYear,
    this.startDate,
    this.endDate,
    this.nextAiringEpisode,
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
    final country = json['countryOfOrigin'] as String?;

    // since AniList defaults any manhwa or manhua to manga,
    // we check the country of origin and change the format accordingly
    final String format;
    if (type == 'MANGA') {
      switch (country) {
        case 'KR':
          format = 'MANHWA';
          break;
        case 'CN' || 'TW':
          format = 'MANHUA';
          break;
        case 'JP':
          format = 'MANGA';
          break;
        default:
          format = 'MANGA';
          break;
      }
    } else {
      format = rawFormat;
    }

    final bannerImage = json['bannerImage'] as String?;
    final description = json['description'] as String?;

    final rawScore = (json['averageScore'] as num?)?.toDouble();
    final double? rating = rawScore != null ? rawScore / 10 : null;

    final rawStatus = json['status'] as String?;
    final status = rawStatus?.formatString();

    final rawSeason = json['season'] as String?;
    final season = rawSeason?.capitalize();

    final episodes = json['episodes'] as int?;
    final duration = json['duration'] as int?;
    final chapters = json['chapters'] as int?;
    final volumes = json['volumes'] as int?;

    final rawSource = json['source'] as String?;
    final source = rawSource?.formatString();

    final seasonYear = json['seasonYear'] as int?;
    final popularity = json['popularity'] as int?;
    final favourites = json['favourites'] as int?;

    final meanScore = json['meanScore'] as int?;
    final averageScore = json['averageScore'] as int?;

    final genres = (json['genres'] as List?)
        ?.map((e) => e as String)
        .toList();

    final tags = (json['tags'] as List?)
        ?.map((e) => MediaTag.fromJson(e as Map<String, dynamic>))
        .toList();

    final rawStartDate = json['startDate'] as Map<String, dynamic>?;
    final startDate =
        rawStartDate != null ? FuzzyDate.fromJson(rawStartDate) : null;

    final rawEndDate = json['endDate'] as Map<String, dynamic>?;
    final endDate = rawEndDate != null ? FuzzyDate.fromJson(rawEndDate) : null;

    final rawNextAiring = json['nextAiringEpisode'] as Map<String, dynamic>?;
    final nextAiringEpisode =
        rawNextAiring != null ? NextAiring.fromJson(rawNextAiring) : null;

    return Media(
      id: id,
      type: type,
      title: title,
      coverImage: coverImage,
      format: format,
      bannerImage: bannerImage,
      description: description,
      countryOfOrigin: country,
      status: status,
      season: season,
      source: source,
      rating: rating,
      episodes: episodes,
      duration: duration,
      chapters: chapters,
      volumes: volumes,
      meanScore: meanScore,
      averageScore: averageScore,
      popularity: popularity,
      favourites: favourites,
      seasonYear: seasonYear,
      genres: genres,
      tags: tags,
      startDate: startDate,
      endDate: endDate,
      nextAiringEpisode: nextAiringEpisode,
    );
  }
}
