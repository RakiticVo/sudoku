import '../models/game_state.dart';

abstract class SudokuRepository {
  Future<void> saveGameState(GameState state);
  Future<GameState?> loadGameState();
  Future<void> clearGameState();
  Future<bool> hasSavedGame();
}
