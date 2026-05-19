import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/core/algorithms/sudoku_generator.dart';
import 'package:sudoku/core/algorithms/sudoku_solver.dart';

void main() {
  group('SudokuGenerator', () {
    test('generate creates puzzle with exactly 1 solution', () {
      final puzzle = SudokuGenerator.generate('easy');
      final solutions = SudokuSolver.countSolutions(puzzle, limit: 2);
      expect(solutions, 1);
    });

    test('generate respects minimum clue count constraints (>= 2 per row/col/box)', () {
      final puzzle = SudokuGenerator.generate('expert');

      // Check rows and cols
      for (int i = 0; i < 9; i++) {
        int rowCount = puzzle[i].where((c) => c != 0).length;
        int colCount = 0;
        for (int j = 0; j < 9; j++) {
          if (puzzle[j][i] != 0) colCount++;
        }
        expect(rowCount, greaterThanOrEqualTo(2));
        expect(colCount, greaterThanOrEqualTo(2));
      }

      // Check boxes
      for (int r = 0; r < 9; r += 3) {
        for (int c = 0; c < 9; c += 3) {
          int boxCount = 0;
          for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
              if (puzzle[r + i][c + j] != 0) boxCount++;
            }
          }
          expect(boxCount, greaterThanOrEqualTo(2));
        }
      }
    });

    test('Performance: Generate 5 expert puzzles within acceptable time', () {
      final stopWatch = Stopwatch()..start();
      for (int i = 0; i < 5; i++) {
        SudokuGenerator.generate('expert');
      }
      stopWatch.stop();
      expect(stopWatch.elapsedMilliseconds, lessThan(8000));
    });
  });
}
