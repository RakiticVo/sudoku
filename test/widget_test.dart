import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sudoku/main.dart';
import 'package:sudoku/features/sudoku/domain/repositories/sudoku_repository.dart';
import 'package:sudoku/features/sudoku/domain/models/game_state.dart';
import 'package:sudoku/features/sudoku/presentation/cubit/settings_cubit.dart';
import 'package:sudoku/features/sudoku/presentation/cubit/economy_cubit.dart';
import 'package:sudoku/features/sudoku/presentation/cubit/campaign_cubit.dart';
import 'package:sudoku/features/sudoku/presentation/cubit/daily_challenge_cubit.dart';

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

class FakeSettingsCubit extends Cubit<SettingsState> implements SettingsCubit {
  FakeSettingsCubit() : super(SettingsState.initial());

  @override
  Future<void> toggleDarkNewsprint(bool value) async {}

  @override
  Future<void> setFontFamily(String font) async {}

  @override
  Future<void> setInkColor(String ink) async {}

  @override
  Future<void> setStampStyle(String stamp) async {}

  @override
  Future<void> setUsername(String name) async {}
}

class FakeEconomyCubit extends Cubit<EconomyState> implements EconomyCubit {
  FakeEconomyCubit() : super(EconomyState.initial());

  @override
  Future<void> addDroplets(int amount) async {}

  @override
  Future<bool> spendDroplets(int amount) async => true;

  @override
  Future<bool> buyHint(int cost) async => true;

  @override
  Future<void> useHintToken() async {}

  @override
  Future<bool> buyRevive(int cost) async => true;

  @override
  Future<void> useReviveToken() async {}

  @override
  Future<bool> unlockFont(String font, int cost) async => true;

  @override
  Future<bool> unlockInk(String ink, int cost) async => true;

  @override
  Future<bool> unlockStamp(String stamp, int cost) async => true;
}

class FakeCampaignCubit extends Cubit<CampaignState> implements CampaignCubit {
  FakeCampaignCubit() : super(const CampaignState(volumes: [], completionStatus: {}));

  @override
  Future<void> loadProgress() async {}

  @override
  Future<void> completeLevel(String volumeId, int levelIndex, int timeTakenSeconds) async {}

  @override
  bool isVolumeCompleted(String volumeId) => false;
}

class FakeDailyChallengeCubit extends Cubit<DailyChallengeState> implements DailyChallengeCubit {
  FakeDailyChallengeCubit() : super(const DailyChallengeState(completedChallenges: {}));

  @override
  Future<void> loadChallenges() async {}

  @override
  Future<void> completeChallenge({
    required String date,
    required String difficulty,
    required int solveTimeSeconds,
  }) async {}

  @override
  bool isDateCompleted(String date) => false;
}

void main() {
  setUpAll(() {
    final sl = GetIt.instance;
    
    // Register mock repository if not already registered
    if (!sl.isRegistered<SudokuRepository>()) {
      sl.registerSingleton<SudokuRepository>(FakeSudokuRepository());
    }

    // Register all Cubits for MyApp DI mapping
    if (!sl.isRegistered<SettingsCubit>()) {
      sl.registerSingleton<SettingsCubit>(FakeSettingsCubit());
    }
    if (!sl.isRegistered<EconomyCubit>()) {
      sl.registerSingleton<EconomyCubit>(FakeEconomyCubit());
    }
    if (!sl.isRegistered<CampaignCubit>()) {
      sl.registerSingleton<CampaignCubit>(FakeCampaignCubit());
    }
    if (!sl.isRegistered<DailyChallengeCubit>()) {
      sl.registerSingleton<DailyChallengeCubit>(FakeDailyChallengeCubit());
    }
  });

  testWidgets('Classic Sudoku Smoke Test - Renders Home Page correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the personalized greeting renders.
    expect(find.text('Hello User'), findsOneWidget);

    // Verify that the title and subheadings are displayed.
    expect(find.text('THE CLASSIC'), findsOneWidget);
    expect(find.text('S U D O K U'), findsOneWidget);
    expect(find.text('Tactile Newsprint Edition'), findsOneWidget);
    expect(find.text('PLAY QUICK EDITION'), findsOneWidget);

    // Click the PLAY QUICK EDITION card to open the difficulty dialog.
    await tester.tap(find.byKey(const Key('quick_play_card')));
    await tester.pumpAndSettle();

    // Verify the dialog header.
    expect(find.text('SELECT DIFFICULTY'), findsOneWidget);

    // Verify uppercase options render in the dialog.
    expect(find.text('BEGINNER'), findsOneWidget);
    expect(find.text('MEDIUM'), findsOneWidget);
    expect(find.text('HARD'), findsOneWidget);
    expect(find.text('EXPERT'), findsOneWidget);
  });
}
