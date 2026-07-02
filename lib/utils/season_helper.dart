// class that automatically changes anime seasons depending on date/time
class SeasonHelper {
  static final DateTime _now = DateTime.now();
  static int get currentYear => _now.year;

  static String get currentSeason {
    final month = _now.month;
    if (month <= 3) return 'WINTER';
    if (month <= 6) return 'SPRING';
    if (month <= 9) return 'SUMMER';
    return 'FALL';
  }

  static String get nextSeason {
    switch (currentSeason) {
      case 'WINTER': return 'SPRING';
      case 'SPRING': return 'SUMMER';
      case 'SUMMER': return 'FALL';
      case 'FALL': return 'WINTER';
      default: return 'WINTER';
    }
  }

  static int get nextSeasonYear {
    // if current season is fall, next season is winter of next year
    return currentSeason == 'FALL' ? currentYear + 1 : currentYear;
  }

  // season label of current season header
  static String get currentSeasonLabel {
    final season = currentSeason[0] + currentSeason.substring(1).toLowerCase();
    return '$season $currentYear';
  }
}