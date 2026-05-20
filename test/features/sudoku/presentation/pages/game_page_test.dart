import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:sudoku/core/database/sudoku_database.dart';
import 'package:sudoku/features/sudoku/domain/repositories/sudoku_repository.dart';
import 'package:sudoku/features/sudoku/domain/models/game_state.dart';
import 'package:sudoku/features/sudoku/domain/models/sudoku_board.dart';
import 'package:sudoku/features/sudoku/domain/models/sudoku_cell.dart';
import 'package:sudoku/features/sudoku/presentation/cubit/settings_cubit.dart';
import 'package:sudoku/features/sudoku/presentation/cubit/economy_cubit.dart';
import 'package:sudoku/features/sudoku/presentation/cubit/campaign_cubit.dart';
import 'package:sudoku/features/sudoku/presentation/cubit/daily_challenge_cubit.dart';
import 'package:sudoku/features/sudoku/presentation/pages/game_page.dart';
import 'package:sudoku/features/sudoku/presentation/widgets/control_pad.dart';

class MockSudokuRepository extends Mock implements SudokuRepository {}
class MockSudokuDatabase extends Mock implements SudokuDatabase {}
class MockSettingsCubit extends MockCubit<SettingsState> implements SettingsCubit {}
class MockEconomyCubit extends MockCubit<EconomyState> implements EconomyCubit {}
class MockCampaignCubit extends MockCubit<CampaignState> implements CampaignCubit {}
class MockDailyChallengeCubit extends MockCubit<DailyChallengeState> implements DailyChallengeCubit {}

SudokuBoard createEmptyBoard() {
  final cells = List.generate(
    9,
    (row) => List.generate(
      9,
      (col) => SudokuCell(
        row: row,
        col: col,
        value: 0,
        correctValue: 5,
        isClue: false,
      ),
    ),
  );
  return SudokuBoard(cells: cells);
}

void main() {
  late MockSudokuRepository mockRepository;
  late MockSudokuDatabase mockDatabase;
  late MockSettingsCubit mockSettingsCubit;
  late MockEconomyCubit mockEconomyCubit;
  late MockCampaignCubit mockCampaignCubit;
  late MockDailyChallengeCubit mockDailyChallengeCubit;

  setUpAll(() {
    registerFallbackValue(SettingsState.initial());
    registerFallbackValue(EconomyState.initial());
    registerFallbackValue(GameState(
      board: createEmptyBoard(),
      difficulty: 'medium',
      maxMistakes: 3,
      maxHints: 4,
    ));
  });

  setUp(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.window.physicalSizeTestValue = const Size(1080, 1920);
    binding.window.devicePixelRatioTestValue = 1.0;

    mockRepository = MockSudokuRepository();
    mockDatabase = MockSudokuDatabase();
    mockSettingsCubit = MockSettingsCubit();
    mockEconomyCubit = MockEconomyCubit();
    mockCampaignCubit = MockCampaignCubit();
    mockDailyChallengeCubit = MockDailyChallengeCubit();

    // Default stubbing
    when(() => mockRepository.hasSavedGame()).thenAnswer((_) async => false);
    when(() => mockRepository.loadGameState()).thenAnswer((_) async => null);
    when(() => mockRepository.saveGameState(any())).thenAnswer((_) async => {});
    when(() => mockRepository.clearGameState()).thenAnswer((_) async => {});
    
    when(() => mockDatabase.getAllReplays()).thenAnswer((_) async => []);

    final sl = GetIt.instance;
    sl.allowReassignment = true;
    sl.registerSingleton<SudokuRepository>(mockRepository);
    sl.registerSingleton<SudokuDatabase>(mockDatabase);
    sl.registerSingleton<SettingsCubit>(mockSettingsCubit);
    sl.registerSingleton<EconomyCubit>(mockEconomyCubit);
    sl.registerSingleton<CampaignCubit>(mockCampaignCubit);
    sl.registerSingleton<DailyChallengeCubit>(mockDailyChallengeCubit);

    // Default state stubbing
    when(() => mockSettingsCubit.state).thenReturn(SettingsState.initial());
    when(() => mockEconomyCubit.state).thenReturn(EconomyState.initial());
    when(() => mockCampaignCubit.state).thenReturn(const CampaignState(volumes: [], completionStatus: {}));
    when(() => mockDailyChallengeCubit.state).thenReturn(const DailyChallengeState(completedChallenges: {}));
  });

  tearDown(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.window.clearPhysicalSizeTestValue();
    binding.window.clearDevicePixelRatioTestValue();
  });

  Widget createTestWidget({required String difficulty, bool isResume = false}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>.value(value: mockSettingsCubit),
        BlocProvider<EconomyCubit>.value(value: mockEconomyCubit),
        BlocProvider<CampaignCubit>.value(value: mockCampaignCubit),
        BlocProvider<DailyChallengeCubit>.value(value: mockDailyChallengeCubit),
      ],
      child: MaterialApp(
        home: GamePage(difficulty: difficulty, isResume: isResume),
      ),
    );
  }

  group('Sudoku GamePage - Hint Caps & Instant Hint Buy (TC_GAME_001 to TC_GAME_005)', () {
    testWidgets('TC_GAME_001: Expert mode hint limit block shows SnackBar', (WidgetTester tester) async {
      final initialGame = GameState(
        board: createEmptyBoard(),
        difficulty: 'expert',
        maxMistakes: 3,
        maxHints: 0,
        hintsUsed: 0,
        selectedRow: 0,
        selectedCol: 0,
      );
      when(() => mockRepository.loadGameState()).thenAnswer((_) async => initialGame);

      await tester.pumpWidget(createTestWidget(difficulty: 'expert', isResume: true));
      await tester.pumpAndSettle();

      // Tap Hint button
      final hintFinder = find.ancestor(
        of: find.byIcon(Icons.lightbulb_outline),
        matching: find.byType(TactileButton),
      );
      expect(hintFinder, findsOneWidget);
      await tester.tap(hintFinder);
      await tester.pump();

      // Verify SnackBar message matching the implementation plan
      expect(find.text('Expert Edition: Logical hints are not permitted on Expert broadsheets.'), findsOneWidget);
    });

    testWidgets('TC_GAME_002: Hard mode difficulty hint limit cap shows SnackBar when at limit', (WidgetTester tester) async {
      final initialGame = GameState(
        board: createEmptyBoard(),
        difficulty: 'hard',
        maxMistakes: 3,
        maxHints: 3,
        hintsUsed: 3,
        selectedRow: 0,
        selectedCol: 0,
      );
      when(() => mockRepository.loadGameState()).thenAnswer((_) async => initialGame);

      await tester.pumpWidget(createTestWidget(difficulty: 'hard', isResume: true));
      await tester.pumpAndSettle();

      // Tap Hint button
      final hintFinder = find.ancestor(
        of: find.byIcon(Icons.lightbulb_outline),
        matching: find.byType(TactileButton),
      );
      expect(hintFinder, findsOneWidget);
      await tester.tap(hintFinder);
      await tester.pump();

      // Verify SnackBar message matching the implementation plan
      expect(find.text('Logical Limit Reached: You can only use at most 3 hints on hard difficulty.'), findsOneWidget);
    });

    testWidgets('TC_GAME_003: Out of Hints popup triggers when pre-owned wallet is 0', (WidgetTester tester) async {
      final initialGame = GameState(
        board: createEmptyBoard(),
        difficulty: 'medium',
        maxMistakes: 3,
        maxHints: 4,
        hintsUsed: 0,
        selectedRow: 0,
        selectedCol: 0,
      );
      when(() => mockRepository.loadGameState()).thenAnswer((_) async => initialGame);
      when(() => mockEconomyCubit.state).thenReturn(EconomyState.initial().copyWith(hints: 0));

      await tester.pumpWidget(createTestWidget(difficulty: 'medium', isResume: true));
      await tester.pumpAndSettle();

      // Tap Hint button
      final hintFinder = find.ancestor(
        of: find.byIcon(Icons.lightbulb_outline),
        matching: find.byType(TactileButton),
      );
      await tester.tap(hintFinder);
      await tester.pumpAndSettle();

      // Verify Dialog renders
      expect(find.text('OUT OF HINTS'), findsOneWidget);
      expect(find.text('CANCEL'), findsOneWidget);
      expect(find.text('Buy & Use (50 💧)'), findsOneWidget);
    });

    testWidgets('TC_GAME_004: Instant Hint buy success triggers economy actions', (WidgetTester tester) async {
      final initialGame = GameState(
        board: createEmptyBoard(),
        difficulty: 'medium',
        maxMistakes: 3,
        maxHints: 4,
        hintsUsed: 0,
        selectedRow: 0,
        selectedCol: 0,
      );
      when(() => mockRepository.loadGameState()).thenAnswer((_) async => initialGame);
      when(() => mockEconomyCubit.state).thenReturn(
        EconomyState.initial().copyWith(hints: 0, balance: 100),
      );
      when(() => mockEconomyCubit.buyHint(any())).thenAnswer((_) async => true);
      when(() => mockEconomyCubit.useHintToken()).thenAnswer((_) async => {});

      await tester.pumpWidget(createTestWidget(difficulty: 'medium', isResume: true));
      await tester.pumpAndSettle();

      // Open out-of-hints popup
      final hintFinder = find.ancestor(
        of: find.byIcon(Icons.lightbulb_outline),
        matching: find.byType(TactileButton),
      );
      await tester.tap(hintFinder);
      await tester.pumpAndSettle();

      // Tap Buy & Use
      await tester.tap(find.text('Buy & Use (50 💧)'));
      await tester.pumpAndSettle();

      // Verify cubit interactions
      verify(() => mockEconomyCubit.buyHint(50)).called(1);
    });

    testWidgets('TC_GAME_005: Instant Hint buy disabled when low balance', (WidgetTester tester) async {
      final initialGame = GameState(
        board: createEmptyBoard(),
        difficulty: 'medium',
        maxMistakes: 3,
        maxHints: 4,
        hintsUsed: 0,
        selectedRow: 0,
        selectedCol: 0,
      );
      when(() => mockRepository.loadGameState()).thenAnswer((_) async => initialGame);
      when(() => mockEconomyCubit.state).thenReturn(
        EconomyState.initial().copyWith(hints: 0, balance: 20), // Low balance!
      );

      await tester.pumpWidget(createTestWidget(difficulty: 'medium', isResume: true));
      await tester.pumpAndSettle();

      // Open out-of-hints popup
      final hintFinder = find.ancestor(
        of: find.byIcon(Icons.lightbulb_outline),
        matching: find.byType(TactileButton),
      );
      await tester.tap(hintFinder);
      await tester.pumpAndSettle();

      // Tap Buy & Use (should do nothing / early return)
      await tester.tap(find.text('Buy & Use (50 💧)'));
      await tester.pumpAndSettle();

      // Verify buyHint was never called
      verifyNever(() => mockEconomyCubit.buyHint(any()));
    });
  });

  group('Sudoku GamePage - Mistakes Revive Flow (TC_GAME_006 to TC_GAME_011)', () {
    testWidgets('TC_GAME_006: Mistake Revive popup displays on 3rd mistake', (WidgetTester tester) async {
      final gameOverState = GameState(
        board: createEmptyBoard(),
        difficulty: 'medium',
        maxMistakes: 3,
        mistakesMade: 3,
        isGameOver: true,
        reviveUsed: false,
        maxHints: 4,
      );
      when(() => mockRepository.loadGameState()).thenAnswer((_) async => gameOverState);
      when(() => mockEconomyCubit.state).thenReturn(
        EconomyState.initial().copyWith(revives: 1),
      );

      await tester.pumpWidget(createTestWidget(difficulty: 'medium', isResume: true));
      await tester.pumpAndSettle();

      // Verify custom revive dialogue is shown
      expect(find.text('THE PRESS OVERFLOWED: OUT OF MISTAKES'), findsOneWidget);
    });

    testWidgets('TC_GAME_007: Revive via pre-owned token calls economy action', (WidgetTester tester) async {
      final gameOverState = GameState(
        board: createEmptyBoard(),
        difficulty: 'medium',
        maxMistakes: 3,
        mistakesMade: 3,
        isGameOver: true,
        reviveUsed: false,
        maxHints: 4,
      );
      when(() => mockRepository.loadGameState()).thenAnswer((_) async => gameOverState);
      when(() => mockEconomyCubit.state).thenReturn(
        EconomyState.initial().copyWith(revives: 1),
      );
      when(() => mockEconomyCubit.useReviveToken()).thenAnswer((_) async => {});

      await tester.pumpWidget(createTestWidget(difficulty: 'medium', isResume: true));
      await tester.pumpAndSettle();

      // Tap Use 1 Revive Token
      await tester.tap(find.text('Use 1 Revive Token'));
      await tester.pumpAndSettle();

      verify(() => mockEconomyCubit.useReviveToken()).called(1);
    });

    testWidgets('TC_GAME_008: Revive via droplet purchase calls spend droplets', (WidgetTester tester) async {
      final gameOverState = GameState(
        board: createEmptyBoard(),
        difficulty: 'medium',
        maxMistakes: 3,
        mistakesMade: 3,
        isGameOver: true,
        reviveUsed: false,
        maxHints: 4,
      );
      when(() => mockRepository.loadGameState()).thenAnswer((_) async => gameOverState);
      when(() => mockEconomyCubit.state).thenReturn(
        EconomyState.initial().copyWith(revives: 0, balance: 600),
      );
      when(() => mockEconomyCubit.buyRevive(any())).thenAnswer((_) async => true);
      when(() => mockEconomyCubit.useReviveToken()).thenAnswer((_) async => {});

      await tester.pumpWidget(createTestWidget(difficulty: 'medium', isResume: true));
      await tester.pumpAndSettle();

      // Tap Buy & Use Revive (500 💧)
      await tester.tap(find.text('Buy & Use Revive (500 💧)'));
      await tester.pumpAndSettle();

      verify(() => mockEconomyCubit.buyRevive(500)).called(1);
    });

    testWidgets('TC_GAME_009: Accept Defeat exits revive dialog and shows game over screen', (WidgetTester tester) async {
      final gameOverState = GameState(
        board: createEmptyBoard(),
        difficulty: 'medium',
        maxMistakes: 3,
        mistakesMade: 3,
        isGameOver: true,
        reviveUsed: false,
        maxHints: 4,
      );
      when(() => mockRepository.loadGameState()).thenAnswer((_) async => gameOverState);
      when(() => mockEconomyCubit.state).thenReturn(
        EconomyState.initial().copyWith(revives: 1),
      );

      await tester.pumpWidget(createTestWidget(difficulty: 'medium', isResume: true));
      await tester.pumpAndSettle();

      // Tap Accept Defeat
      await tester.tap(find.text('Accept Defeat'));
      await tester.pumpAndSettle();

      // Verify Standard game over dialog is shown
      expect(find.text('PUZZLE FAILED'), findsOneWidget);
    });

    testWidgets('TC_GAME_010: Double Mistake Defeat block shows standard defeat immediately', (WidgetTester tester) async {
      final doubleGameOverState = GameState(
        board: createEmptyBoard(),
        difficulty: 'medium',
        maxMistakes: 3,
        mistakesMade: 3,
        isGameOver: true,
        reviveUsed: true, // Revive already used!
        maxHints: 4,
      );
      when(() => mockRepository.loadGameState()).thenAnswer((_) async => doubleGameOverState);

      await tester.pumpWidget(createTestWidget(difficulty: 'medium', isResume: true));
      await tester.pumpAndSettle();

      // Verify standard game over dialogue is shown directly
      expect(find.text('PUZZLE FAILED'), findsOneWidget);
      expect(find.text('THE PRESS OVERFLOWED: OUT OF MISTAKES'), findsNothing);
    });

    testWidgets('TC_GAME_011: Direct Defeat occurs immediately if balance < 500 and no pre-owned revives', (WidgetTester tester) async {
      final gameOverState = GameState(
        board: createEmptyBoard(),
        difficulty: 'medium',
        maxMistakes: 3,
        mistakesMade: 3,
        isGameOver: true,
        reviveUsed: false,
        maxHints: 4,
      );
      when(() => mockRepository.loadGameState()).thenAnswer((_) async => gameOverState);
      when(() => mockEconomyCubit.state).thenReturn(
        EconomyState.initial().copyWith(revives: 0, balance: 100), // Low balance and 0 revives!
      );

      await tester.pumpWidget(createTestWidget(difficulty: 'medium', isResume: true));
      await tester.pumpAndSettle();

      // Verify standard game over dialogue is shown directly (direct defeat block)
      expect(find.text('PUZZLE FAILED'), findsOneWidget);
      expect(find.text('THE PRESS OVERFLOWED: OUT OF MISTAKES'), findsNothing);
    });
  });
}
