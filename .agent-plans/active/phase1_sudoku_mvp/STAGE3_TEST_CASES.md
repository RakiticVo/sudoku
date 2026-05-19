# Test Cases Catalog: Phase 1 — Stage 3: Logic & Sudoku Algorithm

This document serves as the catalog of test cases for the computational core of the Sudoku project, detailing both manual validation and automated unit test scenarios written in Dart.

---

## 1. Sudoku Solver Test Cases (`test/core/algorithms/sudoku_solver_test.dart`)

### TC_SOLVER_001: Solve Valid Complete Board
*   **Description**: Verify that the solver can successfully solve a partially filled valid board.
*   **Input**: A standard Sudoku board with a known unique solution (e.g., a standard Easy-level puzzle).
*   **Expected Outcome**: Solver returns `true` and the output board is filled correctly, satisfying all Sudoku rules (no duplicates in rows, columns, or 3x3 grids).

### TC_SOLVER_002: Identify Unsolvable Board
*   **Description**: Verify that the solver correctly identifies a board that violates Sudoku rules and cannot be solved.
*   **Input**: A board containing duplicates in a row (e.g., two `5`s in row 0).
*   **Expected Outcome**: Solver returns `false` and does not mutate/corrupt the grid.

### TC_SOLVER_003: Count Solutions (Unique Solution)
*   **Description**: Verify that `countSolutions` returns `1` for a puzzle with exactly one unique solution.
*   **Input**: A standard valid Sudoku puzzle.
*   **Expected Outcome**: Returns `1` exactly.

### TC_SOLVER_004: Count Solutions (Multiple Solutions)
*   **Description**: Verify that `countSolutions` returns `2` (or more) when multiple valid solutions exist.
*   **Input**: An empty 9x9 board, or a board with only 4 clues placed.
*   **Expected Outcome**: Returns `2` (since multiple solutions exist).

---

## 2. Sudoku Classifier Test Cases (`test/core/algorithms/sudoku_classifier_test.dart`)

### TC_CLASS_001: Classify Easy Board
*   **Description**: Verify that a board solved using only Naked/Hidden Singles is classified as `easy`.
*   **Expected Outcome**: Returns `easy` strictly.

### TC_CLASS_002: Classify Medium Board
*   **Description**: Verify that a board requiring Naked/Hidden Pairs or Pointing Pairs (and cannot be solved by Level 1 alone) is classified as `medium`.
*   **Expected Outcome**: Returns `medium` strictly.

### TC_CLASS_003: Classify Hard Board
*   **Description**: Verify that a board requiring Naked/Hidden Triples is classified as `hard`.
*   **Expected Outcome**: Returns `hard` strictly.

### TC_CLASS_004: Classify Expert Board
*   **Description**: Verify that a board requiring X-Wing, XY-Wing, Swordfish, or logical chains is classified as `expert`.
*   **Expected Outcome**: Returns `expert` strictly.

---

## 3. Sudoku Generator Test Cases (`test/core/algorithms/sudoku_generator_test.dart`)

### TC_GEN_001: Clue Count Ranges by Difficulty
*   **Description**: Verify that the generator removes cells to match the precise clue count constraints for each difficulty level.
*   **Input**: Invoke generator with different difficulties.
*   **Expected Outcomes**:
    *   `easy`: 35 to 45 filled clues remaining.
    *   `medium`: 30 to 34 filled clues remaining.
    *   `hard`: 25 to 29 filled clues remaining.
    *   `expert`: 17 to 24 filled clues remaining.

### TC_GEN_002: Unique Solution Guarantee
*   **Description**: Assert that every generated puzzle, regardless of difficulty, has exactly one single solution.
*   **Verification**: Generate 10 consecutive puzzles (across all difficulties) and run `countSolutions` on each.
*   **Expected Outcome**: Every generated puzzle must return `1` from `countSolutions`.

### TC_GEN_003: Performance Benchmark (< 1.5s Generation)
*   **Description**: Verify that puzzle generation is lightning fast on the CPU, running under 1.5 seconds.
*   **Verification**: Measure generation elapsed time on 10 expert puzzles.
*   **Expected Outcome**: Average generation time is < 500ms, and maximum time remains strictly below 1.5 seconds.

### TC_GEN_004: Irregular Clue Distribution & Constraints
*   **Description**: Ensure clue patterns do *not* have rotational symmetry, and that clues are distributed evenly enough that no single row, column, or 3x3 block has fewer than 2 clues.
*   **Expected Outcome**: Checking the cells reveals no 180-degree reflection symmetry in empty cell coordinates, and row/col/box clue counts are all >= 2.

---

## 4. Domain Model Tests (`test/features/sudoku/domain/models_test.dart`)

### TC_MODEL_001: Cell Notes Mutability
*   **Description**: Verify that pencil marks (notes) can be added or removed while maintaining immutability using `freezed` copy operations.
*   **Expected Outcome**: Copying a cell with added note returns a new instance with the updated set, leaving the original cell unchanged.

### TC_MODEL_002: JSON Serialization & Deserialization
*   **Description**: Ensure that `GameState`, `SudokuBoard`, and `SudokuCell` serialize to JSON and deserialize back to identical objects.
*   **Expected Outcome**: Calling `toJson()` on a game state and subsequently initializing a new state from that JSON block results in a state identical to the original.
