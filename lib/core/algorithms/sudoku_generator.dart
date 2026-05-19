import 'dart:math';
import 'sudoku_solver.dart';
import 'sudoku_classifier.dart';

class SudokuGenerator {
  static final Random _random = Random();

  /// Generates a valid puzzle targeting the given [difficulty].
  static List<List<int>> generate(String difficulty) {
    final startTime = DateTime.now();
    const timeout = Duration(milliseconds: 1200);

    List<List<int>> grid = List.generate(9, (_) => List.filled(9, 0));
    _fillDiagonal(grid);
    SudokuSolver.solve(grid);

    int minClues, maxClues;
    switch (difficulty) {
      case 'easy':
        minClues = 35; maxClues = 45; break;
      case 'medium':
        minClues = 30; maxClues = 34; break;
      case 'hard':
        minClues = 25; maxClues = 29; break;
      case 'expert':
      default:
        minClues = 17; maxClues = 24; break;
    }

    int targetClues = minClues + _random.nextInt(maxClues - minClues + 1);
    List<int> coords = List.generate(81, (i) => i)..shuffle(_random);
    int remainingClues = 81;

    for (int pos in coords) {
      if (DateTime.now().difference(startTime) > timeout) {
        break;
      }

      if (remainingClues <= targetClues) {
        if (SudokuClassifier.classify(grid) == difficulty || remainingClues <= minClues) {
           break;
        }
      }

      int r = pos ~/ 9;
      int c = pos % 9;
      int backup = grid[r][c];

      grid[r][c] = 0;

      if (!_meetsSafetyConstraints(grid)) {
        grid[r][c] = backup;
        continue;
      }

      if (SudokuSolver.countSolutions(grid, limit: 2) != 1) {
        grid[r][c] = backup;
      } else {
        remainingClues--;
      }
    }

    return grid;
  }

  static void _fillDiagonal(List<List<int>> grid) {
    for (int i = 0; i < 9; i = i + 3) {
      _fillBox(grid, i, i);
    }
  }

  static void _fillBox(List<List<int>> grid, int rowStart, int colStart) {
    int num;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        do {
          num = _random.nextInt(9) + 1;
        } while (!_isSafeInBox(grid, rowStart, colStart, num));
        grid[rowStart + i][colStart + j] = num;
      }
    }
  }

  static bool _isSafeInBox(List<List<int>> grid, int rowStart, int colStart, int num) {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (grid[rowStart + i][colStart + j] == num) return false;
      }
    }
    return true;
  }

  static bool _meetsSafetyConstraints(List<List<int>> grid) {
    for (int i = 0; i < 9; i++) {
      int rowCount = 0;
      int colCount = 0;
      for (int j = 0; j < 9; j++) {
        if (grid[i][j] != 0) rowCount++;
        if (grid[j][i] != 0) colCount++;
      }
      if (rowCount < 2 || colCount < 2) return false;
    }

    for (int r = 0; r < 9; r += 3) {
      for (int c = 0; c < 9; c += 3) {
        int boxCount = 0;
        for (int i = 0; i < 3; i++) {
          for (int j = 0; j < 3; j++) {
            if (grid[r + i][c + j] != 0) boxCount++;
          }
        }
        if (boxCount < 2) return false;
      }
    }

    return true;
  }
}
