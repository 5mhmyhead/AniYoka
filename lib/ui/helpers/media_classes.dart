// object classes to help parse data from the API
// fuzzy date for start date and end date
class FuzzyDate {
  final int? year;
  final int? month;
  final int? day;

  const FuzzyDate({this.year, this.month, this.day});

  factory FuzzyDate.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const FuzzyDate();

    return FuzzyDate(
      year: json['year'] as int?,
      month: json['month'] as int?,
      day: json['day'] as int?,
    );
  }

  String? get formattedYear => year != null ? '$year' : null;

  DateTime? toDateTime() {
    if (year != null && month != null && day != null) {
      return DateTime(year!, month!, day!);
    }
    return null;
  }

  String? toFormattedString() {
    if (year == null) return null;
    if (month == null) return '$year';

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final monthName = months[(month! - 1).clamp(0, 11)];
    if (day == null) return '$monthName $year';
    return '$monthName $day, $year';
  }
}

class NextAiring {
  final int episode;
  final int airingAt;
  final int timeUntilAiring;

  NextAiring({
    required this.episode,
    required this.airingAt,
    required this.timeUntilAiring,
  });

  factory NextAiring.fromJson(Map<String, dynamic> json) {
    return NextAiring(
      episode: json['episode'] as int? ?? 0,
      airingAt: json['airingAt'] as int? ?? 0,
      timeUntilAiring: json['timeUntilAiring'] as int? ?? 0,
    );
  }

  DateTime get airingDateTime =>
      DateTime.fromMillisecondsSinceEpoch(airingAt * 1000);

  Duration get remainingTime {
    final difference = airingDateTime.difference(DateTime.now());
    return difference.isNegative ? Duration.zero : difference;
  }

  String get formattedCountdown {
    final duration = remainingTime;
    if (duration == Duration.zero) return 'Ep $episode airing soon';

    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);

    if (days > 0) {
      return 'Ep $episode in ${days}d ${hours}h';
    } else {
      return 'Ep $episode in ${hours}h';
    }
  }
}

class MediaTag {
  final String name;
  final bool isMediaSpoiler;
  final int rank;

  const MediaTag({
    required this.name,
    required this.isMediaSpoiler,
    required this.rank,
  });

  factory MediaTag.fromJson(Map<String, dynamic> json) {
    return MediaTag(
      name: json['name'] as String? ?? '',
      isMediaSpoiler: json['isMediaSpoiler'] as bool? ?? false,
      rank: json['rank'] as int? ?? 0,
    );
  }
}