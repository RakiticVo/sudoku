import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/game_state.dart';
import '../../domain/repositories/sudoku_repository.dart';

class SudokuRepositoryImpl implements SudokuRepository {
  final SharedPreferences _prefs;
  static const String _key = 'newspaper_sudoku_saved_game_state';

  SudokuRepositoryImpl(this._prefs);

  @override
  Future<void> saveGameState(GameState state) async {
    try {
      final jsonString = jsonEncode(state.toJson());
      await _prefs.setString(_key, jsonString);
    } catch (_) {
      // Gracefully handle or log serialization errors
    }
  }

  @override
  Future<GameState?> loadGameState() async {
    try {
      final jsonString = _prefs.getString(_key);
      if (jsonString == null) return null;
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return GameState.fromJson(jsonMap);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearGameState() async {
    await _prefs.remove(_key);
  }

  @override
  Future<bool> hasSavedGame() async {
    final jsonString = _prefs.getString(_key);
    if (jsonString == null) return false;
    try {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      final state = GameState.fromJson(jsonMap);
      // We only consider the game restorable if it is not completed and not game over
      return !state.isCompleted && !state.isGameOver;
    } catch (_) {
      return false;
    }
  }
}
