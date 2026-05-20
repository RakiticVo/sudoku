import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/core/algorithms/daily_challenge_generator.dart';

void main() {
  group('DailyChallengeGenerator Test Suite', () {
    test('Seed generation should be strictly deterministic for the same date', () {
      final date = DateTime(2026, 5, 20); // May 20, 2026
      
      final seed1 = DailyChallengeGenerator.getSeedForDate(date);
      final seed2 = DailyChallengeGenerator.getSeedForDate(date);
      final seed3 = DailyChallengeGenerator.getSeedForDate(DateTime(2026, 5, 20, 10, 30)); // different time, same date

      expect(seed1, equals(seed2));
      expect(seed1, equals(seed3));
    });

    test('Seed generation should produce distinct seeds for different dates', () {
      final date1 = DateTime(2026, 5, 20);
      final date2 = DateTime(2026, 5, 21);

      final seed1 = DailyChallengeGenerator.getSeedForDate(date1);
      final seed2 = DailyChallengeGenerator.getSeedForDate(date2);

      expect(seed1, isNot(equals(seed2)));
    });

    test('Seed generation should handle year/month/day padding consistently', () {
      final date1 = DateTime(2026, 1, 9); // needs single digit padding -> 2026-01-09
      final seed1 = DailyChallengeGenerator.getSeedForDate(date1);

      final date2 = DateTime(2026, 10, 12);
      final seed2 = DailyChallengeGenerator.getSeedForDate(date2);

      expect(seed1, isNotNull);
      expect(seed2, isNotNull);
      expect(seed1, isNot(equals(seed2)));
    });

    test('Difficulty mapping should assign correct categories by day of week', () {
      // Monday -> 'easy'
      final monday = DateTime(2026, 5, 18);
      expect(monday.weekday, equals(DateTime.monday));
      expect(DailyChallengeGenerator.getDifficultyForDate(monday), equals('easy'));

      // Tuesday -> 'medium'
      final tuesday = DateTime(2026, 5, 19);
      expect(tuesday.weekday, equals(DateTime.tuesday));
      expect(DailyChallengeGenerator.getDifficultyForDate(tuesday), equals('medium'));

      // Wednesday -> 'medium'
      final wednesday = DateTime(2026, 5, 20);
      expect(wednesday.weekday, equals(DateTime.wednesday));
      expect(DailyChallengeGenerator.getDifficultyForDate(wednesday), equals('medium'));

      // Thursday -> 'hard'
      final thursday = DateTime(2026, 5, 21);
      expect(thursday.weekday, equals(DateTime.thursday));
      expect(DailyChallengeGenerator.getDifficultyForDate(thursday), equals('hard'));

      // Friday -> 'hard'
      final friday = DateTime(2026, 5, 22);
      expect(friday.weekday, equals(DateTime.friday));
      expect(DailyChallengeGenerator.getDifficultyForDate(friday), equals('hard'));

      // Saturday -> 'expert'
      final saturday = DateTime(2026, 5, 23);
      expect(saturday.weekday, equals(DateTime.saturday));
      expect(DailyChallengeGenerator.getDifficultyForDate(saturday), equals('expert'));

      // Sunday -> 'expert'
      final sunday = DateTime(2026, 5, 24);
      expect(sunday.weekday, equals(DateTime.sunday));
      expect(DailyChallengeGenerator.getDifficultyForDate(sunday), equals('expert'));
    });
  });
}
