// this was originally separated into two anime and manga models,
// but anilist has a dedicated media type that holds both anime and manga.
import 'package:aniyoka/ui/common/ui_helpers.dart';
import 'package:aniyoka/ui/helpers/fuzzy_date.dart';

class Media {
  final int id;
  final String type;
  final String title;
  final String coverImage;
  final String format;
  // nullable parameters
  // if unreleased, rating is made null
  final String? bannerImage;
  final String? countryOfOrigin;
  final double? rating;
  final String? status;
  final String? season;
  final int? seasonYear;
  final FuzzyDate? startDate;

  Media({
    required this.id,
    required this.type,
    required this.title,
    required this.coverImage,
    required this.format,
    // nullable parameters
    this.bannerImage,
    this.countryOfOrigin,
    this.rating,
    this.status,
    this.season,
    this.seasonYear,
    this.startDate,
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

    final rawScore = (json['averageScore'] as num?)?.toDouble();
    final double? rating = rawScore != null ? rawScore / 10 : null;

    final rawStatus = json['status'] as String?;
    final status = rawStatus?.formatString();

    final rawSeason = json['season'] as String?;
    final season = rawSeason?.capitalize();

    final seasonYear = json['seasonYear'] as int?;

    final rawStartDate = json['startDate'] as Map<String, dynamic>?;
    final startDate = rawStartDate != null ? FuzzyDate.fromJson(rawStartDate) : null;

    return Media(
      id: id,
      type: type,
      title: title,
      coverImage: coverImage,
      format: format,
      bannerImage: bannerImage,
      countryOfOrigin: country,
      rating: rating,
      status: status,
      season: season,
      seasonYear: seasonYear,
      startDate: startDate,
    );
  }
}
