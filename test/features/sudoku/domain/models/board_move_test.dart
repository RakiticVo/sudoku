import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/features/sudoku/domain/models/board_move.dart';

void main() {
  group('BoardMove Test Suite', () {
    test('Should instantiate BoardMove correctly', () {
      const move = BoardMove(
        timestampOffsetMs: 1250,
        row: 3,
        col: 5,
        val: 9,
        isNote: false,
      );

      expect(move.timestampOffsetMs, equals(1250));
      expect(move.row, equals(3));
      expect(move.col, equals(5));
      expect(move.val, equals(9));
      expect(move.isNote, isFalse);
    });

    test('Should serialize to compact JSON keys correctly', () {
      const move = BoardMove(
        timestampOffsetMs: 5000,
        row: 0,
        col: 0,
        val: 5,
        isNote: true,
      );

      final json = move.toJson();

      expect(json['t'], equals(5000));
      expect(json['r'], equals(0));
      expect(json['c'], equals(0));
      expect(json['v'], equals(5));
      expect(json['n'], equals(1)); // encoded as 1 for true
    });

    test('Should deserialize from JSON correctly', () {
      final json = {
        't': 3400,
        'r': 8,
        'c': 7,
        'v': 2,
        'n': 0, // encoded as 0 for false
      };

      final move = BoardMove.fromJson(json);

      expect(move.timestampOffsetMs, equals(3400));
      expect(move.row, equals(8));
      expect(move.col, equals(7));
      expect(move.val, equals(2));
      expect(move.isNote, isFalse);
    });

    test('Should maintain round-trip consistency', () {
      const original = BoardMove(
        timestampOffsetMs: 9800,
        row: 4,
        col: 4,
        val: 1,
        isNote: true,
      );

      final json = original.toJson();
      final reconstructed = BoardMove.fromJson(json);

      expect(reconstructed.timestampOffsetMs, equals(original.timestampOffsetMs));
      expect(reconstructed.row, equals(original.row));
      expect(reconstructed.col, equals(original.col));
      expect(reconstructed.val, equals(original.val));
      expect(reconstructed.isNote, equals(original.isNote));
    });
  });
}
