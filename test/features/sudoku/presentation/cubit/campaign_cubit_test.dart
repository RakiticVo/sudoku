import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/core/database/sudoku_database.dart';
import 'package:sudoku/features/sudoku/presentation/cubit/economy_cubit.dart';
import 'package:sudoku/features/sudoku/presentation/cubit/campaign_cubit.dart';

class MockSudokuDatabase extends Mock implements SudokuDatabase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CampaignCubit', () {
    late MockSudokuDatabase mockDatabase;
    late EconomyCubit economyCubit;
    late SharedPreferences prefs;

    setUp(() async {
      mockDatabase = MockSudokuDatabase();
      SharedPreferences.setMockInitialValues({
        'economy_balance': 100,
        'economy_unlocked_fonts': ['Georgia'],
      });
      prefs = await SharedPreferences.getInstance();
      economyCubit = EconomyCubit(prefs);

      // Default mock responses for getVolumeProgress
      when(() => mockDatabase.getVolumeProgress(any()))
          .thenAnswer((_) async => []);
    });

    test('initial state sets volumes and sets completion to false', () async {
      final cubit = CampaignCubit(mockDatabase, economyCubit);

      expect(cubit.state.volumes.length, 3);
      expect(cubit.state.volumes[0].id, 'vol_gutenberg');
      
      final completion = cubit.state.completionStatus['vol_gutenberg'];
      expect(completion, isNotNull);
      expect(completion!.every((completed) => !completed), isTrue);
    });

    test('loadProgress correctly populates completed levels from database', () async {
      // Mock db returns index 1 and index 3 as completed for vol_gutenberg
      when(() => mockDatabase.getVolumeProgress('vol_gutenberg'))
          .thenAnswer((_) async => [
                {'level_index': 1, 'is_completed': 1},
                {'level_index': 3, 'is_completed': 1},
              ]);
      when(() => mockDatabase.getVolumeProgress('vol_pennypress'))
          .thenAnswer((_) async => [
                {'level_index': 0, 'is_completed': 1},
              ]);
      when(() => mockDatabase.getVolumeProgress('vol_moderntimes'))
          .thenAnswer((_) async => []);

      final cubit = CampaignCubit(mockDatabase, economyCubit);
      await cubit.loadProgress();

      final gutenbergCompletion = cubit.state.completionStatus['vol_gutenberg'];
      expect(gutenbergCompletion!.sublist(0, 5), [false, true, false, true, false]);
      expect(gutenbergCompletion.length, 100);

      final pennyCompletion = cubit.state.completionStatus['vol_pennypress'];
      expect(pennyCompletion!.sublist(0, 5), [true, false, false, false, false]);
      expect(pennyCompletion.length, 100);
    });

    test('completeLevel saves to DB and updates completionStatus state', () async {
      when(() => mockDatabase.saveCampaignProgress(
            volumeId: 'vol_gutenberg',
            levelIndex: 2,
            isCompleted: true,
            bestTimeSeconds: 120,
          )).thenAnswer((_) async => {});

      final cubit = CampaignCubit(mockDatabase, economyCubit);
      await cubit.loadProgress();

      await cubit.completeLevel('vol_gutenberg', 2, 120);

      expect(cubit.state.completionStatus['vol_gutenberg']![2], isTrue);
      verify(() => mockDatabase.saveCampaignProgress(
            volumeId: 'vol_gutenberg',
            levelIndex: 2,
            isCompleted: true,
            bestTimeSeconds: 120,
          )).called(1);
    });

    test('completing the last unfinished level in a volume awards droplets', () async {
      // Setup Gutenberg: first 99 levels (0 to 98) are completed, index 99 is the last remaining level
      final completedLevels = List.generate(99, (i) => {'level_index': i, 'is_completed': 1});
      when(() => mockDatabase.getVolumeProgress('vol_gutenberg'))
          .thenAnswer((_) async => completedLevels);
      
      when(() => mockDatabase.saveCampaignProgress(
            volumeId: 'vol_gutenberg',
            levelIndex: 99,
            isCompleted: true,
            bestTimeSeconds: 240,
          )).thenAnswer((_) async => {});

      final cubit = CampaignCubit(mockDatabase, economyCubit);
      await cubit.loadProgress();

      expect(economyCubit.state.balance, 100);
      expect(cubit.isVolumeCompleted('vol_gutenberg'), isFalse);

      // Solve the final level
      await cubit.completeLevel('vol_gutenberg', 99, 240);

      expect(cubit.isVolumeCompleted('vol_gutenberg'), isTrue);
      // Gutenberg awards 500 droplets reward, so balance becomes 100 + 500 = 600
      expect(economyCubit.state.balance, 600);
      expect(prefs.getInt('economy_balance'), 600);
    });

    test('completing a level in an already fully completed volume does not re-award droplets', () async {
      // Gutenberg fully completed initially (all 100 levels)
      final completedLevels = List.generate(100, (i) => {'level_index': i, 'is_completed': 1});
      when(() => mockDatabase.getVolumeProgress('vol_gutenberg'))
          .thenAnswer((_) async => completedLevels);

      when(() => mockDatabase.saveCampaignProgress(
            volumeId: 'vol_gutenberg',
            levelIndex: 2,
            isCompleted: true,
            bestTimeSeconds: 90,
          )).thenAnswer((_) async => {});

      final cubit = CampaignCubit(mockDatabase, economyCubit);
      await cubit.loadProgress();

      expect(economyCubit.state.balance, 100);
      expect(cubit.isVolumeCompleted('vol_gutenberg'), isTrue);

      // Complete a level again (e.g. better time score)
      await cubit.completeLevel('vol_gutenberg', 2, 90);

      expect(cubit.isVolumeCompleted('vol_gutenberg'), isTrue);
      expect(economyCubit.state.balance, 100); // balance remains 100, no new reward
    });
  });
}
