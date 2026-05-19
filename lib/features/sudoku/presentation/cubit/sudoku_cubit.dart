import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/algorithms/sudoku_generator.dart';
import '../../../../core/algorithms/sudoku_solver.dart';
import '../../domain/models/game_state.dart';
import '../../domain/models/sudoku_board.dart';
import '../../domain/models/sudoku_cell.dart';
import '../../domain/repositories/sudoku_repository.dart';

class SudokuCubit extends Cubit<GameState> {
  final SudokuRepository _repository;
  Timer? _timer;
  final List<SudokuBoard> _history = [];

  SudokuCubit({SudokuRepository? repository})
      : _repository = repository ?? GetIt.I<SudokuRepository>(),
        super(const GameState(
          board: SudokuBoard(cells: []),
          difficulty: 'medium',
          maxMistakes: 3,
          maxHints: 3,
        ));

  Future<void> loadSavedGame() async {
    final savedState = await _repository.loadGameState();
    if (savedState != null) {
      _timer?.cancel();
      _history.clear();
      emit(savedState);
      if (!savedState.isCompleted && !savedState.isGameOver) {
        _startTimer();
      }
    }
  }

  Future<void> abandonGame() async {
    _timer?.cancel();
    await _repository.clearGameState();
  }

  void startNewGame(String difficulty) {
    _timer?.cancel();
    _history.clear();

    // 1. Generate puzzle grid with SudokuGenerator
    final puzzleGrid = SudokuGenerator.generate(difficulty);

    // 2. Solve the puzzle grid using backtracking to get correct values
    // To avoid mutating puzzleGrid (which contains 0s), create a deep copy first
    final List<List<int>> solvedGrid = List.generate(
      9,
      (r) => List.generate(9, (c) => puzzleGrid[r][c]),
    );
    SudokuSolver.solve(solvedGrid);

    // 3. Build SudokuCells
    final List<List<SudokuCell>> cellMatrix = List.generate(9, (r) {
      return List.generate(9, (c) {
        final val = puzzleGrid[r][c];
        return SudokuCell(
          row: r,
          col: c,
          value: val,
          correctValue: solvedGrid[r][c],
          isClue: val != 0,
          notes: const {},
          isInvalid: false,
        );
      });
    });

    final board = SudokuBoard(cells: cellMatrix);

    emit(GameState(
      board: board,
      difficulty: difficulty,
      mistakesMade: 0,
      maxMistakes: 3,
      hintsUsed: 0,
      maxHints: difficulty == 'hard' || difficulty == 'expert' ? 0 : 3,
      elapsedSeconds: 0,
      isCompleted: false,
      isGameOver: false,
      selectedRow: null,
      selectedCol: null,
      isNotesMode: false,
    ));

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!state.isCompleted && !state.isGameOver) {
        emit(state.copyWith(elapsedSeconds: state.elapsedSeconds + 1));
      } else {
        _timer?.cancel();
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
  }

  void resumeTimer() {
    if (!state.isCompleted && !state.isGameOver) {
      _startTimer();
    }
  }

  void selectCell(int row, int col) {
    if (state.isCompleted || state.isGameOver) return;
    emit(state.copyWith(selectedRow: row, selectedCol: col));
  }

  void toggleNotesMode() {
    if (state.isCompleted || state.isGameOver) return;
    emit(state.copyWith(isNotesMode: !state.isNotesMode));
  }

  void enterDigit(int digit) {
    if (state.isCompleted || state.isGameOver) return;
    final r = state.selectedRow;
    final c = state.selectedCol;
    if (r == null || c == null) return;

    final cell = state.board.cells[r][c];
    if (cell.isClue || cell.value == cell.correctValue) return;

    // Save history before modifying
    _history.add(state.board);

    if (state.isNotesMode) {
      // Toggle note
      final newNotes = Set<int>.from(cell.notes);
      if (newNotes.contains(digit)) {
        newNotes.remove(digit);
      } else {
        newNotes.add(digit);
      }

      final updatedCell = cell.copyWith(notes: newNotes, value: 0, isInvalid: false);
      _updateCell(r, c, updatedCell);
    } else {
      final isCorrect = digit == cell.correctValue;
      if (isCorrect) {
        final updatedCell = cell.copyWith(value: digit, isInvalid: false, notes: const {});
        // Automatically remove this digit from the notes of all other cells in the same row, col, and 3x3 box (automatic candidate cleanup!)
        final updatedBoard = _getBoardWithRemovedNotes(r, c, digit, updatedCell);
        
        // Check completion
        final isCompleted = _checkBoardCompletion(updatedBoard);
        
        emit(state.copyWith(
          board: updatedBoard,
          isCompleted: isCompleted,
        ));

        if (isCompleted) {
          _timer?.cancel();
        }
      } else {
        final newMistakes = state.mistakesMade + 1;
        final isGameOver = newMistakes >= state.maxMistakes;
        final updatedCell = cell.copyWith(value: digit, isInvalid: true);
        
        _updateCell(r, c, updatedCell);
        emit(state.copyWith(
          mistakesMade: newMistakes,
          isGameOver: isGameOver,
        ));

        if (isGameOver) {
          _timer?.cancel();
        }
      }
    }
  }

  void erase() {
    if (state.isCompleted || state.isGameOver) return;
    final r = state.selectedRow;
    final c = state.selectedCol;
    if (r == null || c == null) return;

    final cell = state.board.cells[r][c];
    if (cell.isClue) return;

    _history.add(state.board);

    final updatedCell = cell.copyWith(value: 0, isInvalid: false, notes: const {});
    _updateCell(r, c, updatedCell);
  }

  void undo() {
    if (state.isCompleted || state.isGameOver || _history.isEmpty) return;
    final previousBoard = _history.removeLast();
    emit(state.copyWith(board: previousBoard));
  }

  void useHint() {
    if (state.isCompleted || state.isGameOver) return;
    if (state.hintsUsed >= state.maxHints) return;

    final r = state.selectedRow;
    final c = state.selectedCol;
    if (r == null || c == null) return;

    final cell = state.board.cells[r][c];
    if (cell.isClue || cell.value == cell.correctValue) return;

    _history.add(state.board);

    final correctDigit = cell.correctValue;
    final updatedCell = cell.copyWith(value: correctDigit, isInvalid: false, notes: const {});
    final updatedBoard = _getBoardWithRemovedNotes(r, c, correctDigit, updatedCell);

    final isCompleted = _checkBoardCompletion(updatedBoard);

    emit(state.copyWith(
      board: updatedBoard,
      hintsUsed: state.hintsUsed + 1,
      isCompleted: isCompleted,
    ));

    if (isCompleted) {
      _timer?.cancel();
    }
  }

  void _updateCell(int r, int c, SudokuCell updatedCell) {
    final newCells = state.board.cells.map((row) => List<SudokuCell>.from(row)).toList();
    newCells[r][c] = updatedCell;
    emit(state.copyWith(board: SudokuBoard(cells: newCells)));
  }

  SudokuBoard _getBoardWithRemovedNotes(int activeRow, int activeCol, int digit, SudokuCell updatedActiveCell) {
    final newCells = state.board.cells.map((row) => List<SudokuCell>.from(row)).toList();
    newCells[activeRow][activeCol] = updatedActiveCell;

    final boxRowStart = activeRow - activeRow % 3;
    final boxColStart = activeCol - activeCol % 3;

    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (r == activeRow && c == activeCol) continue;

        // Check if in same row, column, or 3x3 box
        final inSameRow = r == activeRow;
        final inSameCol = c == activeCol;
        final inSameBox = (r >= boxRowStart && r < boxRowStart + 3) && (c >= boxColStart && c < boxColStart + 3);

        if (inSameRow || inSameCol || inSameBox) {
          final currentCell = newCells[r][c];
          if (currentCell.notes.contains(digit)) {
            final updatedNotes = Set<int>.from(currentCell.notes)..remove(digit);
            newCells[r][c] = currentCell.copyWith(notes: updatedNotes);
          }
        }
      }
    }

    return SudokuBoard(cells: newCells);
  }

  bool _checkBoardCompletion(SudokuBoard board) {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        final cell = board.cells[r][c];
        if (cell.value != cell.correctValue) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  void onChange(Change<GameState> change) {
    super.onChange(change);
    final next = change.nextState;
    if (next.board.cells.isEmpty) return;
    
    if (next.isCompleted || next.isGameOver) {
      _repository.clearGameState();
    } else {
      _repository.saveGameState(next);
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
