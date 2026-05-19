import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/features/sudoku/domain/models/sudoku_cell.dart';
import 'package:sudoku/features/sudoku/domain/models/sudoku_board.dart';
import 'package:sudoku/features/sudoku/domain/models/game_state.dart';

void main() {
  group('Sudoku Models', () {
    test('SudokuCell mutability test', () {
      final cell = SudokuCell(
        row: 0,
        col: 0,
        value: 0,
        correctValue: 5,
        isClue: false,
      );

      expect(cell.notes.isEmpty, isTrue);

      final newCell = cell.copyWith(notes: {1, 2});

      expect(newCell.notes.contains(1), isTrue);
      expect(cell.notes.isEmpty, isTrue);
    });

    test('GameState JSON Serialization & Deserialization', () {
      final cell = SudokuCell(
        row: 0,
        col: 0,
        value: 1,
        correctValue: 1,
        isClue: true,
      );
      final board = SudokuBoard(cells: [
        [cell]
      ]);

      final state = GameState(
        board: board,
        difficulty: 'easy',
        maxMistakes: 3,
        maxHints: 2,
        isNotesMode: true,
      );

      final json = state.toJson();
      final newState = GameState.fromJson(json);

      expect(newState.difficulty, 'easy');
      expect(newState.maxMistakes, 3);
      expect(newState.isNotesMode, true);
      expect(newState.board.cells[0][0].value, 1);
    });
  });
}
