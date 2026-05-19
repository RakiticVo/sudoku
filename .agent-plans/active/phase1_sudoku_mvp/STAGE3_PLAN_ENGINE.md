# Implementation Plan: Phase 1 — Stage 3: Logic & Sudoku Algorithm

This plan outlines the implementation of the core computational engine of the classic newspaper Sudoku game: the immutable models, the backtracking solver, the human-like logical solver classifier, and the irregular random generator in pure Dart.

---

## 1. Applied Skills
*   **Using Agent Skills**: Follow the project skill lock and instructions.
*   **Writing Plans**: Ensure a decision-complete, compact, and concrete plan.
*   **Flutter Clean Architecture**: Keep all algorithms and data models strictly within the Domain layer (`lib/core/algorithms/` and `lib/features/sudoku/domain/models/`), totally decoupled from presentation/widgets.
*   **Immutable Models**: Utilize `freezed` for immutable models (`SudokuCell`, `SudokuBoard`, `GameState`).
*   **Testing Checklist**: Design exhaustive test suites for unique solution guarantees and generation speed.
*   **Doubt-Driven Development**: Introduce a lightweight generation timeout mechanism to prevent worst-case infinite loops on Expert level under restricted conditions.

---

## 2. Desired Behavior & Algorithmic Decisions

### A. Sudoku Models (`lib/features/sudoku/domain/models/`)
We will define three immutable models using `freezed`:
*   **`SudokuCell`**:
    *   `int row`: 0 to 8.
    *   `int col`: 0 to 8.
    *   `int value`: The digit placed in the cell (0 for empty).
    *   `int correctValue`: The actual solution digit.
    *   `bool isClue`: True if pre-filled original number.
    *   `Set<int> notes`: Pencil marks (1-9).
    *   `bool isInvalid`: True if placed value does not match correctValue.
*   **`SudokuBoard`**:
    *   `List<List<SudokuCell>> cells`: 9x9 grid representation.
*   **`GameState`**:
    *   `SudokuBoard board`: The current active board.
    *   `String difficulty`: 'easy', 'medium', 'hard', 'expert'.
    *   `int mistakesMade`: Counter of incorrect value placements.
    *   `int maxMistakes`: Limit based on difficulty (Easy: 3, Medium: 2, Hard: 1, Expert: 0).
    *   `int hintsUsed`: Counter of hints requested.
    *   `int maxHints`: Limit based on difficulty (Easy: 2, Medium: 1, Hard: 0, Expert: 0).
    *   `int elapsedSeconds`: Time taken so far.
    *   `bool isCompleted`: True if the board is fully and correctly solved.
    *   `bool isGameOver`: True if mistakes reach the limit or game is lost.
    *   `int? selectedRow`: Row of currently selected cell.
    *   `int? selectedCol`: Col of currently selected cell.
    *   `bool isNotesMode`: Toggle for manual pencil markings.

### B. Backtracking Solver (`lib/core/algorithms/sudoku_solver.dart`)
*   **Algorithm**: Standard recursive depth-first backtracking search.
*   **Functionality**:
    *   `bool solve(List<List<int>> grid)`: Fills the grid and returns `true` if solvable, `false` otherwise.
    *   `int countSolutions(List<List<int>> grid, {int limit = 2})`: Runs backtracking, continuing the search after finding the first solution to see if there is another. Returns 0, 1, or 2 (representing "2 or more"). Used to guarantee a **unique solution** for generated grids.
*   **Optimization**: Bitmask pruning of valid choices per cell to achieve solver execution under 2ms.

### C. Human-Like Logical Solver Classifier (`lib/core/algorithms/sudoku_classifier.dart`)
To accurately classify board difficulty, we will build a cascading solver that implements human-like reasoning step-by-step. It tracks the highest level technique required to solve the puzzle:
1.  **Level 1: Basic Scanning (Easy)**:
    *   *Naked Single*: A cell has only one possible candidate remaining in its candidate list.
    *   *Hidden Single*: A candidate has only one possible position inside a row, column, or 3x3 box.
2.  **Level 2: Basic Candidates (Medium)**:
    *   *Naked/Hidden Pairs*: Two cells in a unit (row, col, or box) contain exactly the same two candidates (Naked Pair), or two candidates are confined to only two cells in a unit (Hidden Pair). This allows removing these candidates from other cells in that unit.
    *   *Pointing Pairs / Box-Line Reduction (Intersection Removal)*: If candidates for a number in a 3x3 block are confined to a single row/col, they can be removed from the rest of that row/col outside the block (or vice versa).
3.  **Level 3: Intermediate Strategies (Hard)**:
    *   *Naked/Hidden Triples & Quads*: Extensions of pairs to groups of 3 or 4 cells/candidates.
4.  **Level 4: Advanced positional strategies (Expert/Fiendish)**:
    *   *X-Wing*: Forms a rectangle of candidate restrictions across two parallel units.
    *   *XY-Wing*: Triangle of cells of the form XY, XZ, YZ sharing units, eliminating candidate Z.
    *   *Swordfish*: Extension of X-Wing to three rows/columns.
    *   *Unique Rectangles*: Elimination of candidates based on avoiding a 2-solution layout pattern.
    *   *Forcing Chains / AIC / Backtracking*: Fallback logical chain techniques.

**Classification Output**:
*   If solved using only Level 1: `easy`.
*   If solved using Level 2 (and cannot be solved by Level 1 alone): `medium`.
*   If solved using Level 3: `hard`.
*   If solved using Level 4 (or cannot be resolved by Level 3 and below but has exactly one solution): `expert`.

### D. Sudoku Generator (`lib/core/algorithms/sudoku_generator.dart`)
*   **Irregular Digging Rule**: Digs holes randomly without rotational symmetry to increase hardcore visual difficulty.
*   **Clue & Safety Constraints**:
    1.  Target clues: Easy: 35-45, Medium: 30-34, Hard: 25-29, Expert: 17-24.
    2.  No row, column, or 3x3 box can have fewer than 2 clues remaining (guarantees clues >= 2 to prevent extreme blackouts/blind spots).
*   **Steps**:
    1.  Generate a fully solved valid 9x9 board (start empty, fill diagonal boxes, backtrack-solve remaining).
    2.  Create a randomized list of 81 coordinates.
    3.  Iterate through coordinates. Temporarily clear the cell.
    4.  Verify uniqueness of solution using `countSolutions`. If unique, keep empty; else restore.
    5.  Run `SudokuClassifier` to check the current difficulty level.
    6.  Check row/col/box count constraints. If violated, restore cell.
    7.  Stop when targeted clues and difficulty are reached.
*   **Performance Timeout**: Max 1.2s timeout. If reached, return the best valid board matching the target criteria to maintain mobile response time < 1.5s.

---

## 3. Main Files Affected
We will create the following files:
*   `lib/core/algorithms/sudoku_solver.dart` (Backtracking solver)
*   `lib/core/algorithms/sudoku_classifier.dart` (Human-like logical classifier)
*   `lib/core/algorithms/sudoku_generator.dart` (Puzzle generator)
*   `lib/features/sudoku/domain/models/sudoku_cell.dart` (Freezed model)
*   `lib/features/sudoku/domain/models/sudoku_board.dart` (Freezed model)
*   `lib/features/sudoku/domain/models/game_state.dart` (Freezed model)

---

## 4. Verification & Testing Checklist

We will write unit tests under `test/core/algorithms/`:
1.  **Solver Tests**: Verify correct solutions, unsolvable boards, and count solutions (TC_SOLVER_001 -> TC_SOLVER_004).
2.  **Classifier Tests**: Verify correct identification of Easy, Medium, Hard, and Expert techniques (TC_CLASS_001 -> TC_CLASS_004).
3.  **Generator Tests**: Verify clue counts by difficulty, unique solution guarantee, no symmetry, row/col box clue counts >= 2, and performance benchmark under 1.5 seconds (TC_GEN_001 -> TC_GEN_004).
4.  **Model Tests**: Verify Freezed copy immutability and JSON serialization compatibility for local storage (TC_MODEL_001 -> TC_MODEL_002).
