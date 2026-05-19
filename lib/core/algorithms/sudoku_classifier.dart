import 'dart:math';

class SudokuClassifier {
  /// Analyzes a grid and returns its difficulty.
  /// Returns 'easy', 'medium', 'hard', or 'expert'.
  static String classify(List<List<int>> grid) {
    int clues = 0;
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (grid[r][c] != 0) clues++;
      }
    }
    // Mathematically no unique Sudoku solution exists with < 17 clues, and < 20 clues is exceptionally hard
    if (clues < 17) return 'expert';

    final cg = CandidateGrid(grid);
    int highestLevelUsed = 1;

    while (true) {
      // Loop Level 1 moves as much as possible
      bool progressLevel1 = true;
      while (progressLevel1) {
        progressLevel1 = cg.applyNakedSingles() || cg.applyHiddenSingles();
      }

      if (cg.isSolved()) break;

      // Level 2 strategies
      bool progressLevel2 = cg.applyPointingPairs() ||
          cg.applyBoxLineReduction() ||
          cg.applyNakedPairs() ||
          cg.applyHiddenPairs();

      if (progressLevel2) {
        highestLevelUsed = max(highestLevelUsed, 2);
        continue;
      }

      // Level 3 strategies
      bool progressLevel3 = cg.applyNakedTriples();
      if (progressLevel3) {
        highestLevelUsed = max(highestLevelUsed, 3);
        continue;
      }

      // Level 4 strategies
      bool progressLevel4 = cg.applyXWing() || cg.applyXYWing();
      if (progressLevel4) {
        highestLevelUsed = max(highestLevelUsed, 4);
        continue;
      }

      break;
    }

    if (cg.isSolved()) {
      if (highestLevelUsed == 1) return 'easy';
      if (highestLevelUsed == 2) return 'medium';
      if (highestLevelUsed == 3) return 'hard';
      return 'expert';
    }

    // If it's not logically solved with these standard strategies, it's a very advanced/expert puzzle.
    return 'expert';
  }
}

class CandidateGrid {
  final List<List<int>> grid;
  late List<List<Set<int>>> candidates;

  CandidateGrid(List<List<int>> initialGrid)
      : grid = List.generate(9, (r) => List.from(initialGrid[r])) {
    candidates = List.generate(9, (r) => List.generate(9, (_) => <int>{}));
    _initCandidates();
  }

  void _initCandidates() {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (grid[r][c] == 0) {
          candidates[r][c] = _getPossibleValues(r, c);
        } else {
          candidates[r][c] = <int>{};
        }
      }
    }
  }

  Set<int> _getPossibleValues(int row, int col) {
    final possible = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    for (int i = 0; i < 9; i++) {
      possible.remove(grid[row][i]);
      possible.remove(grid[i][col]);
    }
    int boxRow = row - row % 3;
    int boxCol = col - col % 3;
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        possible.remove(grid[boxRow + r][boxCol + c]);
      }
    }
    return possible;
  }

  bool isSolved() {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (grid[r][c] == 0) return false;
      }
    }
    return true;
  }

  void _placeValue(int r, int c, int val) {
    grid[r][c] = val;
    candidates[r][c] = <int>{};
    for (int i = 0; i < 9; i++) {
      candidates[r][i].remove(val);
      candidates[i][c].remove(val);
    }
    int boxRow = r - r % 3;
    int boxCol = c - c % 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        candidates[boxRow + i][boxCol + j].remove(val);
      }
    }
  }

  /// LEVEL 1: Naked Singles
  bool applyNakedSingles() {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (grid[r][c] == 0 && candidates[r][c].length == 1) {
          _placeValue(r, c, candidates[r][c].first);
          return true;
        }
      }
    }
    return false;
  }

  /// LEVEL 1: Hidden Singles
  bool applyHiddenSingles() {
    // Check rows
    for (int r = 0; r < 9; r++) {
      for (int num = 1; num <= 9; num++) {
        int count = 0;
        int targetCol = -1;
        for (int c = 0; c < 9; c++) {
          if (grid[r][c] == 0 && candidates[r][c].contains(num)) {
            count++;
            targetCol = c;
          }
        }
        if (count == 1) {
          _placeValue(r, targetCol, num);
          return true;
        }
      }
    }

    // Check columns
    for (int c = 0; c < 9; c++) {
      for (int num = 1; num <= 9; num++) {
        int count = 0;
        int targetRow = -1;
        for (int r = 0; r < 9; r++) {
          if (grid[r][c] == 0 && candidates[r][c].contains(num)) {
            count++;
            targetRow = r;
          }
        }
        if (count == 1) {
          _placeValue(targetRow, c, num);
          return true;
        }
      }
    }

    // Check boxes
    for (int b = 0; b < 9; b++) {
      int startRow = (b ~/ 3) * 3;
      int startCol = (b % 3) * 3;
      for (int num = 1; num <= 9; num++) {
        int count = 0;
        int targetRow = -1;
        int targetCol = -1;
        for (int i = 0; i < 3; i++) {
          for (int j = 0; j < 3; j++) {
            int r = startRow + i;
            int c = startCol + j;
            if (grid[r][c] == 0 && candidates[r][c].contains(num)) {
              count++;
              targetRow = r;
              targetCol = c;
            }
          }
        }
        if (count == 1) {
          _placeValue(targetRow, targetCol, num);
          return true;
        }
      }
    }
    return false;
  }

  /// LEVEL 2: Pointing Pairs
  bool applyPointingPairs() {
    bool eliminated = false;
    for (int b = 0; b < 9; b++) {
      int startRow = (b ~/ 3) * 3;
      int startCol = (b % 3) * 3;
      for (int num = 1; num <= 9; num++) {
        List<int> rows = [];
        List<int> cols = [];
        for (int i = 0; i < 3; i++) {
          for (int j = 0; j < 3; j++) {
            int r = startRow + i;
            int c = startCol + j;
            if (grid[r][c] == 0 && candidates[r][c].contains(num)) {
              if (!rows.contains(r)) rows.add(r);
              if (!cols.contains(c)) cols.add(c);
            }
          }
        }
        if (rows.length == 1) {
          int r = rows.first;
          for (int c = 0; c < 9; c++) {
            if ((c < startCol || c >= startCol + 3) && grid[r][c] == 0) {
              if (candidates[r][c].remove(num)) eliminated = true;
            }
          }
        }
        if (cols.length == 1) {
          int c = cols.first;
          for (int r = 0; r < 9; r++) {
            if ((r < startRow || r >= startRow + 3) && grid[r][c] == 0) {
              if (candidates[r][c].remove(num)) eliminated = true;
            }
          }
        }
      }
    }
    return eliminated;
  }

  /// LEVEL 2: Box-Line Reduction
  bool applyBoxLineReduction() {
    bool eliminated = false;
    // Row-wise
    for (int r = 0; r < 9; r++) {
      for (int num = 1; num <= 9; num++) {
        List<int> boxes = [];
        for (int c = 0; c < 9; c++) {
          if (grid[r][c] == 0 && candidates[r][c].contains(num)) {
            int box = (r ~/ 3) * 3 + (c ~/ 3);
            if (!boxes.contains(box)) boxes.add(box);
          }
        }
        if (boxes.length == 1) {
          int targetBox = boxes.first;
          int startRow = (targetBox ~/ 3) * 3;
          int startCol = (targetBox % 3) * 3;
          for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
              int br = startRow + i;
              int bc = startCol + j;
              if (br != r && grid[br][bc] == 0) {
                if (candidates[br][bc].remove(num)) eliminated = true;
              }
            }
          }
        }
      }
    }
    // Col-wise
    for (int c = 0; c < 9; c++) {
      for (int num = 1; num <= 9; num++) {
        List<int> boxes = [];
        for (int r = 0; r < 9; r++) {
          if (grid[r][c] == 0 && candidates[r][c].contains(num)) {
            int box = (r ~/ 3) * 3 + (c ~/ 3);
            if (!boxes.contains(box)) boxes.add(box);
          }
        }
        if (boxes.length == 1) {
          int targetBox = boxes.first;
          int startRow = (targetBox ~/ 3) * 3;
          int startCol = (targetBox % 3) * 3;
          for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
              int br = startRow + i;
              int bc = startCol + j;
              if (bc != c && grid[br][bc] == 0) {
                if (candidates[br][bc].remove(num)) eliminated = true;
              }
            }
          }
        }
      }
    }
    return eliminated;
  }

  /// LEVEL 2: Naked Pairs
  bool applyNakedPairs() {
    bool eliminated = false;
    // Row-wise
    for (int r = 0; r < 9; r++) {
      for (int c1 = 0; c1 < 9; c1++) {
        if (grid[r][c1] == 0 && candidates[r][c1].length == 2) {
          for (int c2 = c1 + 1; c2 < 9; c2++) {
            if (grid[r][c2] == 0 &&
                candidates[r][c2].length == 2 &&
                _setEquals(candidates[r][c1], candidates[r][c2])) {
              final pair = candidates[r][c1];
              for (int c = 0; c < 9; c++) {
                if (c != c1 && c != c2 && grid[r][c] == 0) {
                  for (int val in pair) {
                    if (candidates[r][c].remove(val)) eliminated = true;
                  }
                }
              }
            }
          }
        }
      }
    }

    // Col-wise
    for (int c = 0; c < 9; c++) {
      for (int r1 = 0; r1 < 9; r1++) {
        if (grid[r1][c] == 0 && candidates[r1][c].length == 2) {
          for (int r2 = r1 + 1; r2 < 9; r2++) {
            if (grid[r2][c] == 0 &&
                candidates[r2][c].length == 2 &&
                _setEquals(candidates[r1][c], candidates[r2][c])) {
              final pair = candidates[r1][c];
              for (int r = 0; r < 9; r++) {
                if (r != r1 && r != r2 && grid[r][c] == 0) {
                  for (int val in pair) {
                    if (candidates[r][c].remove(val)) eliminated = true;
                  }
                }
              }
            }
          }
        }
      }
    }

    // Box-wise
    for (int b = 0; b < 9; b++) {
      int startRow = (b ~/ 3) * 3;
      int startCol = (b % 3) * 3;
      List<Point> pairs = [];
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          int r = startRow + i;
          int c = startCol + j;
          if (grid[r][c] == 0 && candidates[r][c].length == 2) {
            pairs.add(Point(r, c));
          }
        }
      }
      for (int i = 0; i < pairs.length; i++) {
        for (int j = i + 1; j < pairs.length; j++) {
          Point p1 = pairs[i];
          Point p2 = pairs[j];
          if (_setEquals(candidates[p1.r][p1.c], candidates[p2.r][p2.c])) {
            final pair = candidates[p1.r][p1.c];
            for (int r = startRow; r < startRow + 3; r++) {
              for (int c = startCol; c < startCol + 3; c++) {
                if ((r != p1.r || c != p1.c) &&
                    (r != p2.r || c != p2.c) &&
                    grid[r][c] == 0) {
                  for (int val in pair) {
                    if (candidates[r][c].remove(val)) eliminated = true;
                  }
                }
              }
            }
          }
        }
      }
    }
    return eliminated;
  }

  /// LEVEL 2: Hidden Pairs
  bool applyHiddenPairs() {
    bool eliminated = false;
    // Row-wise
    for (int r = 0; r < 9; r++) {
      for (int n1 = 1; n1 <= 9; n1++) {
        for (int n2 = n1 + 1; n2 <= 9; n2++) {
          List<int> cols = [];
          for (int c = 0; c < 9; c++) {
            if (grid[r][c] == 0 && (candidates[r][c].contains(n1) || candidates[r][c].contains(n2))) {
              cols.add(c);
            }
          }
          if (cols.length == 2) {
            int c1 = cols[0];
            int c2 = cols[1];
            if (candidates[r][c1].contains(n1) && candidates[r][c1].contains(n2) &&
                candidates[r][c2].contains(n1) && candidates[r][c2].contains(n2)) {
              for (int val = 1; val <= 9; val++) {
                if (val != n1 && val != n2) {
                  if (candidates[r][c1].remove(val)) eliminated = true;
                  if (candidates[r][c2].remove(val)) eliminated = true;
                }
              }
            }
          }
        }
      }
    }

    // Col-wise
    for (int c = 0; c < 9; c++) {
      for (int n1 = 1; n1 <= 9; n1++) {
        for (int n2 = n1 + 1; n2 <= 9; n2++) {
          List<int> rows = [];
          for (int r = 0; r < 9; r++) {
            if (grid[r][c] == 0 && (candidates[r][c].contains(n1) || candidates[r][c].contains(n2))) {
              rows.add(r);
            }
          }
          if (rows.length == 2) {
            int r1 = rows[0];
            int r2 = rows[1];
            if (candidates[r1][c].contains(n1) && candidates[r1][c].contains(n2) &&
                candidates[r2][c].contains(n1) && candidates[r2][c].contains(n2)) {
              for (int val = 1; val <= 9; val++) {
                if (val != n1 && val != n2) {
                  if (candidates[r1][c].remove(val)) eliminated = true;
                  if (candidates[r2][c].remove(val)) eliminated = true;
                }
              }
            }
          }
        }
      }
    }

    // Box-wise
    for (int b = 0; b < 9; b++) {
      int startRow = (b ~/ 3) * 3;
      int startCol = (b % 3) * 3;
      for (int n1 = 1; n1 <= 9; n1++) {
        for (int n2 = n1 + 1; n2 <= 9; n2++) {
          List<Point> points = [];
          for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
              int r = startRow + i;
              int c = startCol + j;
              if (grid[r][c] == 0 && (candidates[r][c].contains(n1) || candidates[r][c].contains(n2))) {
                points.add(Point(r, c));
              }
            }
          }
          if (points.length == 2) {
            Point p1 = points[0];
            Point p2 = points[1];
            if (candidates[p1.r][p1.c].contains(n1) && candidates[p1.r][p1.c].contains(n2) &&
                candidates[p2.r][p2.c].contains(n1) && candidates[p2.r][p2.c].contains(n2)) {
              for (int val = 1; val <= 9; val++) {
                if (val != n1 && val != n2) {
                  if (candidates[p1.r][p1.c].remove(val)) eliminated = true;
                  if (candidates[p2.r][p2.c].remove(val)) eliminated = true;
                }
              }
            }
          }
        }
      }
    }

    return eliminated;
  }

  /// LEVEL 3: Naked Triples
  bool applyNakedTriples() {
    bool eliminated = false;
    // Row-wise
    for (int r = 0; r < 9; r++) {
      for (int c1 = 0; c1 < 9; c1++) {
        if (grid[r][c1] == 0 && candidates[r][c1].length >= 2 && candidates[r][c1].length <= 3) {
          for (int c2 = c1 + 1; c2 < 9; c2++) {
            if (grid[r][c2] == 0 && candidates[r][c2].length >= 2 && candidates[r][c2].length <= 3) {
              for (int c3 = c2 + 1; c3 < 9; c3++) {
                if (grid[r][c3] == 0 && candidates[r][c3].length >= 2 && candidates[r][c3].length <= 3) {
                  final union = {...candidates[r][c1], ...candidates[r][c2], ...candidates[r][c3]};
                  if (union.length == 3) {
                    for (int c = 0; c < 9; c++) {
                      if (c != c1 && c != c2 && c != c3 && grid[r][c] == 0) {
                        for (int val in union) {
                          if (candidates[r][c].remove(val)) eliminated = true;
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    // Col-wise
    for (int c = 0; c < 9; c++) {
      for (int r1 = 0; r1 < 9; r1++) {
        if (grid[r1][c] == 0 && candidates[r1][c].length >= 2 && candidates[r1][c].length <= 3) {
          for (int r2 = r1 + 1; r2 < 9; r2++) {
            if (grid[r2][c] == 0 && candidates[r2][c].length >= 2 && candidates[r2][c].length <= 3) {
              for (int r3 = r2 + 1; r3 < 9; r3++) {
                if (grid[r3][c] == 0 && candidates[r3][c].length >= 2 && candidates[r3][c].length <= 3) {
                  final union = {...candidates[r1][c], ...candidates[r2][c], ...candidates[r3][c]};
                  if (union.length == 3) {
                    for (int r = 0; r < 9; r++) {
                      if (r != r1 && r != r2 && r != r3 && grid[r][c] == 0) {
                        for (int val in union) {
                          if (candidates[r][c].remove(val)) eliminated = true;
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    // Box-wise
    for (int b = 0; b < 9; b++) {
      int startRow = (b ~/ 3) * 3;
      int startCol = (b % 3) * 3;
      List<Point> cellList = [];
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          int r = startRow + i;
          int c = startCol + j;
          if (grid[r][c] == 0 && candidates[r][c].length >= 2 && candidates[r][c].length <= 3) {
            cellList.add(Point(r, c));
          }
        }
      }
      for (int i = 0; i < cellList.length; i++) {
        for (int j = i + 1; j < cellList.length; j++) {
          for (int k = j + 1; k < cellList.length; k++) {
            Point p1 = cellList[i];
            Point p2 = cellList[j];
            Point p3 = cellList[k];
            final union = {...candidates[p1.r][p1.c], ...candidates[p2.r][p2.c], ...candidates[p3.r][p3.c]};
            if (union.length == 3) {
              for (int r = startRow; r < startRow + 3; r++) {
                for (int c = startCol; c < startCol + 3; c++) {
                  if (grid[r][c] == 0) {
                    Point test = Point(r, c);
                    if (test != p1 && test != p2 && test != p3) {
                      for (int val in union) {
                        if (candidates[r][c].remove(val)) eliminated = true;
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    return eliminated;
  }

  /// LEVEL 4: X-Wing
  bool applyXWing() {
    bool eliminated = false;
    for (int num = 1; num <= 9; num++) {
      // Row-wise X-Wing
      for (int r1 = 0; r1 < 9; r1++) {
        List<int> cols1 = [];
        for (int c = 0; c < 9; c++) {
          if (grid[r1][c] == 0 && candidates[r1][c].contains(num)) cols1.add(c);
        }
        if (cols1.length == 2) {
          int c1 = cols1[0];
          int c2 = cols1[1];
          for (int r2 = r1 + 1; r2 < 9; r2++) {
            List<int> cols2 = [];
            for (int c = 0; c < 9; c++) {
              if (grid[r2][c] == 0 && candidates[r2][c].contains(num)) cols2.add(c);
            }
            if (cols2.length == 2 && cols2[0] == c1 && cols2[1] == c2) {
              for (int r = 0; r < 9; r++) {
                if (r != r1 && r != r2) {
                  if (grid[r][c1] == 0 && candidates[r][c1].remove(num)) eliminated = true;
                  if (grid[r][c2] == 0 && candidates[r][c2].remove(num)) eliminated = true;
                }
              }
            }
          }
        }
      }

      // Column-wise X-Wing
      for (int c1 = 0; c1 < 9; c1++) {
        List<int> rows1 = [];
        for (int r = 0; r < 9; r++) {
          if (grid[r][c1] == 0 && candidates[r][c1].contains(num)) rows1.add(r);
        }
        if (rows1.length == 2) {
          int r1 = rows1[0];
          int r2 = rows1[1];
          for (int c2 = c1 + 1; c2 < 9; c2++) {
            List<int> rows2 = [];
            for (int r = 0; r < 9; r++) {
              if (grid[r][c2] == 0 && candidates[r][c2].contains(num)) rows2.add(r);
            }
            if (rows2.length == 2 && rows2[0] == r1 && rows2[1] == r2) {
              for (int c = 0; c < 9; c++) {
                if (c != c1 && c != c2) {
                  if (grid[r1][c] == 0 && candidates[r1][c].remove(num)) eliminated = true;
                  if (grid[r2][c] == 0 && candidates[r2][c].remove(num)) eliminated = true;
                }
              }
            }
          }
        }
      }
    }
    return eliminated;
  }

  /// LEVEL 4: XY-Wing
  bool applyXYWing() {
    bool eliminated = false;
    List<Point> biValues = [];
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (grid[r][c] == 0 && candidates[r][c].length == 2) {
          biValues.add(Point(r, c));
        }
      }
    }

    for (int i = 0; i < biValues.length; i++) {
      Point pivot = biValues[i];
      Set<int> pivotCand = candidates[pivot.r][pivot.c];
      int x = pivotCand.first;
      int y = pivotCand.last;

      for (int j = 0; j < biValues.length; j++) {
        if (i == j) continue;
        Point pincer1 = biValues[j];
        if (!_shareUnit(pivot, pincer1)) continue;

        Set<int> p1Cand = candidates[pincer1.r][pincer1.c];
        if (!p1Cand.contains(x) && !p1Cand.contains(y)) continue;
        int shared1 = p1Cand.contains(x) ? x : y;
        int z1 = p1Cand.first == shared1 ? p1Cand.last : p1Cand.first;

        for (int k = j + 1; k < biValues.length; k++) {
          if (i == k) continue;
          Point pincer2 = biValues[k];
          if (!_shareUnit(pivot, pincer2)) continue;

          Set<int> p2Cand = candidates[pincer2.r][pincer2.c];
          int shared2 = pivotCand.first == shared1 ? y : x;
          if (!p2Cand.contains(shared2)) continue;
          int z2 = p2Cand.first == shared2 ? p2Cand.last : p2Cand.first;

          if (z1 == z2) {
            int z = z1;
            for (int r = 0; r < 9; r++) {
              for (int c = 0; c < 9; c++) {
                if (grid[r][c] == 0) {
                  Point test = Point(r, c);
                  if (test != pincer1 && test != pincer2 && test != pivot) {
                    if (_shareUnit(test, pincer1) && _shareUnit(test, pincer2)) {
                      if (candidates[r][c].remove(z)) eliminated = true;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return eliminated;
  }

  bool _shareUnit(Point a, Point b) {
    if (a.r == b.r) return true;
    if (a.c == b.c) return true;
    if ((a.r ~/ 3) == (b.r ~/ 3) && (a.c ~/ 3) == (b.c ~/ 3)) return true;
    return false;
  }

  bool _setEquals(Set<int> a, Set<int> b) {
    if (a.length != b.length) return false;
    return a.containsAll(b);
  }
}

class Point {
  final int r;
  final int c;
  Point(this.r, this.c);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point && runtimeType == other.runtimeType && r == other.r && c == other.c;

  @override
  int get hashCode => r.hashCode ^ c.hashCode;
}
