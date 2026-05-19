import 'dart:math';
import 'package:sudoku/core/algorithms/sudoku_solver.dart';
import 'package:sudoku/core/algorithms/sudoku_classifier.dart';

void main() {
  final random = Random();
  print('Starting high-speed hard grid search...');

  for (int boardAttempt = 0; boardAttempt < 50; boardAttempt++) {
    // Generate a fully solved grid
    List<List<int>> solved = List.generate(9, (_) => List.filled(9, 0));
    _fillDiagonal(solved, random);
    SudokuSolver.solve(solved);

    for (int digAttempt = 0; digAttempt < 200; digAttempt++) {
      List<List<int>> grid = List.generate(9, (r) => List.from(solved[r]));
      List<int> coords = List.generate(81, (i) => i)..shuffle(random);
      int remainingClues = 81;

      for (int pos in coords) {
        int r = pos ~/ 9;
        int c = pos % 9;
        int backup = grid[r][c];

        grid[r][c] = 0;
        remainingClues--;

        if (!_meetsSafetyConstraints(grid)) {
          grid[r][c] = backup;
          remainingClues++;
          continue;
        }

        if (SudokuSolver.countSolutions(grid, limit: 2) != 1) {
          grid[r][c] = backup;
          remainingClues++;
          continue;
        }

        // Only check classification if we are in the target clue range for hard (24-32 clues)
        if (remainingClues <= 32 && remainingClues >= 24) {
          final classified = SudokuClassifier.classify(grid);
          if (classified == 'hard') {
            print('SUCCESS: Found stable hard grid with $remainingClues clues on board $boardAttempt, dig $digAttempt!');
            print('Grid:');
            print('[');
            for (final row in grid) {
              print('  $row,');
            }
            print('];');
            return;
          }
        }
        
        if (remainingClues < 24) {
          break; // Don't dig too deep, otherwise it becomes expert
        }
      }
    }
  }
  print('Search completed, hard grid not found.');
}

void _fillDiagonal(List<List<int>> grid, Random random) {
  for (int i = 0; i < 9; i = i + 3) {
    _fillBox(grid, i, i, random);
  }
}

void _fillBox(List<List<int>> grid, int rowStart, int colStart, Random random) {
  int num;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      do {
        num = random.nextInt(9) + 1;
      } while (!_isSafeInBox(grid, rowStart, colStart, num));
      grid[rowStart + i][colStart + j] = num;
    }
  }
}

bool _isSafeInBox(List<List<int>> grid, int rowStart, int colStart, int num) {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (grid[rowStart + i][colStart + j] == num) return false;
    }
  }
  return true;
}

bool _meetsSafetyConstraints(List<List<int>> grid) {
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
