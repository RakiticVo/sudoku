class DailyChallengeGenerator {
  /// Converts a [DateTime] date (e.g. 2026-05-20) into a deterministic integer seed.
  static int getSeedForDate(DateTime date) {
    final dateStr = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    int hash = 0;
    for (int i = 0; i < dateStr.length; i++) {
      hash = dateStr.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return hash.abs();
  }

  /// Suggests a difficulty for the daily challenge based on the day of the week.
  /// Weekdays are medium/hard, weekends are expert, Mondays are easy.
  static String getDifficultyForDate(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'easy';
      case DateTime.tuesday:
      case DateTime.wednesday:
        return 'medium';
      case DateTime.thursday:
      case DateTime.friday:
        return 'hard';
      case DateTime.saturday:
      case DateTime.sunday:
      default:
        return 'expert';
    }
  }
}
