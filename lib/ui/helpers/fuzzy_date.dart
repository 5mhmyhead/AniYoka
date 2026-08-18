class FuzzyDate {
  final int? year;
  final int? month;
  final int? day;
  
  const FuzzyDate({this.year, this.month, this.day});

  String? get formattedYear => year != null ? '$year' : null;

  factory FuzzyDate.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const FuzzyDate();
    
    return FuzzyDate(
      year: json['year'] as int?,
      month: json['month'] as int?,
      day: json['day'] as int?,
    );
  }

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
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final monthName = months[(month! - 1).clamp(0, 11)];
    if (day == null) return '$monthName $year';
    return '$monthName $day, $year';
  }
}
