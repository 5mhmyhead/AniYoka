import 'package:aniyoka/ui/common/ui_helpers.dart';
// linter insists to use lowerCamelCase for enums, but AniList uses uppercase for seasons
// ignore: constant_identifier_names
enum Season { WINTER, SPRING, SUMMER, FALL }

class SeasonHelper {
  static Season getCurrentSeason([DateTime? date]) {
    final now = date ?? DateTime.now();
    final month = now.month;

    // Season equates each season as
    // winter from months december to february
    // spring from months march to may
    // summer from months june to august
    // fall from months september to november
    if (month >= 3 && month <= 5) {
      return Season.SPRING;
    } else if (month >= 6 && month <= 8) {
      return Season.SUMMER;
    } else if (month >= 9 && month <= 11) {
      return Season.FALL;
    } else {
      return Season.WINTER;
    }
  }

  // december counts as next year's season
  static int getCurrentSeasonYear([DateTime? date]) {
    final now = date ?? DateTime.now();

    if (now.month == 12) {
      return now.year + 1;
    }

    return now.year;
  }

  static Season getNextSeason([DateTime? date]) {
    final season = getCurrentSeason(date);

    switch (season) {
      case Season.WINTER:
        return Season.SPRING;
      case Season.SPRING:
        return Season.SUMMER;
      case Season.SUMMER:
        return Season.FALL;
      case Season.FALL:
        return Season.WINTER;
    }
  }

  static int getNextSeasonYear([DateTime? date]) {
    final currentSeason = getCurrentSeason(date);
    final currentYear = getCurrentSeasonYear(date);

    // fall to winter switches to next year
    if (currentSeason == Season.FALL) {
      return currentYear + 1;
    }

    return currentYear;
  }

  static String getCurrentSeasonAsString([DateTime? date]) {
    final currentSeason = getCurrentSeason(date).name.toString().capitalize();
    final currentYear = getCurrentSeasonYear(date).toString();

    return '$currentSeason $currentYear';
  }

  static String getNextSeasonAsString([DateTime? date]) {
    final currentSeason = getNextSeason(date).name.toString().capitalize();
    final currentYear = getNextSeasonYear(date).toString();

    return '$currentSeason $currentYear';
  }
}
