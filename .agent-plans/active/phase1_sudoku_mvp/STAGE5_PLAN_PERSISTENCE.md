# Stage 5 Plan: State Integration & Auto-Save (Persistence)

## 1. Objectives & Behavior
Integrate a persistent, automatic game saving and recovery mechanism to provide a seamless, robust gameplay experience:
1. **Auto-Save on Actions**: Automatically serialize and save the complete `GameState` (including the 9x9 board with clues, user entries, pencil marks, mistake counts, hints used, elapsed time, selected cell, and note toggle status) on every single player action:
   - Digit entry
   - Cell selection change (optional, but good to preserve user's last selected cell)
   - Note/pencil mark toggle or edit
   - Erase action
   - Undo action
   - Pause action / App exit
2. **Resume Game Flow**:
   - On application startup, check if a saved game exists in local storage.
   - If a saved game exists and is not finished (not game over and not completed), display a bold, tactile **"RESUME GAME"** button on the `HomePage` above the difficulty selection list.
   - Tapping "RESUME GAME" navigates directly to the `GamePage` restoring the saved game's state (including the timer starting from where it was paused).
3. **Save Clearance**:
   - When a puzzle is successfully completed or results in a Game Over, or when the player chooses to **Abandon** the game via the pause dialog, clear the saved game from local storage so that "RESUME GAME" is no longer shown.

---

## 2. Technical Stack & Clean Architecture
Following the project's **Clean Architecture** guidelines:

```text
lib/features/sudoku/
  data/
    repositories/
      sudoku_repository_impl.dart (implements SudokuRepository using SharedPreferences)
  domain/
    repositories/
      sudoku_repository.dart (defines the storage interface)
```

### Applied Skills
1. **Using Agent Skills**: Startup checks, lock file validation, following skill guidelines.
2. **Writing Plans**: Creating a decision-complete architecture and implementation plan.
3. **Flutter Clean Architecture**: Structuring data and domain folders correctly.
4. **Immutable Models**: Leveraging generated `freezed` DTO models `toJson()` and `fromJson()` to serialize the game state safely.
5. **Testing Checklist**: Building mock-based unit tests for cubit state persistence and verifying code with `flutter test`.

---

## 3. Data Interface & Serialization Details

### 3.1 Domain Repository Interface: `SudokuRepository`
```dart
abstract class SudokuRepository {
  Future<void> saveGameState(GameState state);
  Future<GameState?> loadGameState();
  Future<void> clearGameState();
  Future<bool> hasSavedGame();
}
```

### 3.2 Data Implementation: `SudokuRepositoryImpl`
- Uses `shared_preferences` package.
- Storage key: `newspaper_sudoku_saved_game_state`.
- Serializes `GameState` using `jsonEncode(state.toJson())`.
- Deserializes using `jsonDecode(jsonString)` and `GameState.fromJson()`.
- Wait, does `GameState` also serialize `SudokuBoard` and `SudokuCell`? Yes! The `.g.dart` generated files already implement nested JSON serialization recursively! Let's verify that `SudokuCell` and `SudokuBoard` have full JSON serialization. (Yes, they have `@freezed` + `part '....g.dart'` and `factory Model.fromJson(...)`!)

---

## 4. Implementation Steps

### Step 1: Create `SudokuRepository` Interface
File: `lib/features/sudoku/domain/repositories/sudoku_repository.dart`
Defines the abstract contract for storing, fetching, and clearing game state.

### Step 2: Create `SudokuRepositoryImpl` Implementation
File: `lib/features/sudoku/data/repositories/sudoku_repository_impl.dart`
Implements the contract using `SharedPreferences`.

### Step 3: Register Dependencies with `GetIt`
File: `lib/core/di/service_locator.dart`
Register `SharedPreferences` and `SudokuRepository` as singletons.
File: `lib/main.dart`
Initialize the service locator at application startup using `WidgetsFlutterBinding.ensureInitialized()`.

### Step 4: Refactor `SudokuCubit`
File: `lib/features/sudoku/presentation/cubit/sudoku_cubit.dart`
- Inject `SudokuRepository` in the constructor (defaulting to `GetIt.I<SudokuRepository>()`).
- Expose a `Future<void> loadSavedGame()` method that loads the state, resumes the timer, and sets the state.
- Update `enterDigit()`, `erase()`, `undo()`, `useHint()`, `selectCell()`, `toggleNotesMode()`, and `pauseTimer()` to trigger `_repository.saveGameState(state)` asynchronously.
- Clear the saved game via `_repository.clearGameState()` when:
  - Game is completed
  - Game is over
  - A new game is started (overwriting the old save, or saving the new game immediately)
  - Game is abandoned (so the user cannot resume it again).

### Step 5: Update `HomePage` (UI Integration)
File: `lib/features/sudoku/presentation/pages/home_page.dart`
- Make it a `StatefulWidget` or use a `FutureBuilder` to check if a saved game exists.
- If a saved game exists, display a highly polished tactile "RESUME GAME" button above the difficulty options.
- The resume button will navigate to the `GamePage(difficulty: '', isResume: true)`.

### Step 6: Update `GamePage` (UI Integration)
File: `lib/features/sudoku/presentation/pages/game_page.dart`
- Add `final bool isResume` constructor parameter (defaulting to `false`).
- In `initState`, if `isResume` is true, trigger `_cubit.loadSavedGame()`. Otherwise, trigger `_cubit.startNewGame(widget.difficulty)`.
- When the user taps **Abandon** in the pause dialog, call `_cubit.abandonGame()` which stops the timer and clears the save from local storage.

---

## 5. Verification & Testing Plan
1. **Unit Testing**:
   - Create `test/features/sudoku/data/repositories/sudoku_repository_impl_test.dart` to assert correct serialization/deserialization.
   - Update/create unit tests in `test/features/sudoku/presentation/cubit/sudoku_cubit_test.dart` to check that auto-save is triggered on every valid move, and that loading a saved game restores state exactly.
2. **E2E & Visual Verification**:
   - Run the application on a Chrome/browser session.
   - Enter values, toggle notes, pause, go back to HomePage, check if the "RESUME GAME" button appears.
   - Tap "RESUME GAME" and verify everything (cell selections, mistake counts, elapsed time) is exactly where it was left.
   - Finish the game or abandon it, and verify that the "RESUME GAME" button disappears on the HomePage.
