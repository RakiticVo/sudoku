class SudokuSolver {
  static const int emptyCell = 0;

  /// Checks if it is safe to place [num] in [grid] at [row], [col].
  static bool isSafe(List<List<int>> grid, int row, int col, int num) {
    // Check row and column
    for (int x = 0; x < 9; x++) {
      if (grid[row][x] == num) return false;
      if (grid[x][col] == num) return false;
    }

    // Check 3x3 box
    int startRow = row - row % 3;
    int startCol = col - col % 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (grid[i + startRow][j + startCol] == num) return false;
      }
    }

    return true;
  }

  /// Solves the Sudoku grid using backtracking. Returns true if a solution exists.
  /// Mutates the grid to contain the solution.
  static bool solve(List<List<int>> grid) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (grid[row][col] == emptyCell) {
          for (int num = 1; num <= 9; num++) {
            if (isSafe(grid, row, col, num)) {
              grid[row][col] = num;
              if (solve(grid)) {
                return true;
              }
              grid[row][col] = emptyCell;
            }
          }
          return false;
        }
      }
    }
    return true;
  }

  /// Counts the number of solutions up to [limit].
  /// Does not mutate the original grid permanently.
  static int countSolutions(List<List<int>> grid, {int limit = 2}) {
    int count = 0;

    void backtrack(int row, int col) {
      if (count >= limit) return;
      if (row == 9) {
        count++;
        return;
      }

      int nextRow = col == 8 ? row + 1 : row;
      int nextCol = col == 8 ? 0 : col + 1;

      if (grid[row][col] != emptyCell) {
        backtrack(nextRow, nextCol);
      } else {
        for (int num = 1; num <= 9; num++) {
          if (isSafe(grid, row, col, num)) {
            grid[row][col] = num;
            backtrack(nextRow, nextCol);
            grid[row][col] = emptyCell;
          }
        }
      }
    }

    backtrack(0, 0);
    return count;
  }
}
