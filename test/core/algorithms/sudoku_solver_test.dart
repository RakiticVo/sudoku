import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/core/algorithms/sudoku_solver.dart';

void main() {
  group('SudokuSolver', () {
    test('solve returns true and fills a valid solvable grid', () {
      final grid = [
        [5, 3, 0, 0, 7, 0, 0, 0, 0],
        [6, 0, 0, 1, 9, 5, 0, 0, 0],
        [0, 9, 8, 0, 0, 0, 0, 6, 0],
        [8, 0, 0, 0, 6, 0, 0, 0, 3],
        [4, 0, 0, 8, 0, 3, 0, 0, 1],
        [7, 0, 0, 0, 2, 0, 0, 0, 6],
        [0, 6, 0, 0, 0, 0, 2, 8, 0],
        [0, 0, 0, 4, 1, 9, 0, 0, 5],
        [0, 0, 0, 0, 8, 0, 0, 7, 9],
      ];

      final isSolved = SudokuSolver.solve(grid);
      expect(isSolved, isTrue);
      expect(grid[0][2], 4);
    });

    test('countSolutions returns 1 for a unique solution grid', () {
      final grid = [
        [5, 3, 0, 0, 7, 0, 0, 0, 0],
        [6, 0, 0, 1, 9, 5, 0, 0, 0],
        [0, 9, 8, 0, 0, 0, 0, 6, 0],
        [8, 0, 0, 0, 6, 0, 0, 0, 3],
        [4, 0, 0, 8, 0, 3, 0, 0, 1],
        [7, 0, 0, 0, 2, 0, 0, 0, 6],
        [0, 6, 0, 0, 0, 0, 2, 8, 0],
        [0, 0, 0, 4, 1, 9, 0, 0, 5],
        [0, 0, 0, 0, 8, 0, 0, 7, 9],
      ];

      final count = SudokuSolver.countSolutions(grid);
      expect(count, 1);
    });

    test('countSolutions returns 2 for an empty grid (multiple solutions)', () {
      final emptyGrid = List.generate(9, (_) => List.filled(9, 0));
      final count = SudokuSolver.countSolutions(emptyGrid);
      expect(count, 2);
    });
  });
}
