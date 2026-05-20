import 'package:freezed_annotation/freezed_annotation.dart';
import 'sudoku_board.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

@freezed
abstract class GameState with _$GameState {
  const factory GameState({
    required SudokuBoard board,
    required String difficulty,
    @Default(0) int mistakesMade,
    required int maxMistakes,
    @Default(0) int hintsUsed,
    required int maxHints,
    @Default(0) int elapsedSeconds,
    @Default(false) bool isCompleted,
    @Default(false) bool isGameOver,
    int? selectedRow,
    int? selectedCol,
    @Default(false) bool isNotesMode,
    @Default(false) bool reviveUsed,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);
}
