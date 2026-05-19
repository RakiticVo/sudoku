import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:sudoku/main.dart';
import 'package:sudoku/features/sudoku/domain/repositories/sudoku_repository.dart';
import 'package:sudoku/features/sudoku/domain/models/game_state.dart';

class FakeSudokuRepository implements SudokuRepository {
  @override
  Future<void> saveGameState(GameState state) async {}

  @override
  Future<GameState?> loadGameState() async => null;

  @override
  Future<void> clearGameState() async {}

  @override
  Future<bool> hasSavedGame() async => false;
}

void main() {
  setUpAll(() {
    final sl = GetIt.instance;
    if (!sl.isRegistered<SudokuRepository>()) {
      sl.registerSingleton<SudokuRepository>(FakeSudokuRepository());
    }
  });

  testWidgets('Classic Sudoku Smoke Test - Renders Home Page correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title and subheadings are displayed.
    expect(find.text('THE CLASSIC'), findsOneWidget);
    expect(find.text('S U D O K U'), findsOneWidget);
    expect(find.text('Tactile Newsprint Edition'), findsOneWidget);
    expect(find.text('SELECT DIFFICULTY'), findsOneWidget);

    // Verify that the difficulty buttons are rendered.
    expect(find.text('Beginner'), findsOneWidget);
    expect(find.text('Medium'), findsOneWidget);
    expect(find.text('Hard'), findsOneWidget);
    expect(find.text('Expert'), findsOneWidget);
  });
}
