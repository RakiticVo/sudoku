import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:sudoku/features/sudoku/domain/repositories/sudoku_repository.dart';
import 'package:sudoku/features/sudoku/domain/models/game_state.dart';
import 'package:sudoku/features/sudoku/presentation/cubit/settings_cubit.dart';
import 'package:sudoku/features/sudoku/presentation/cubit/economy_cubit.dart';
import 'package:sudoku/features/sudoku/presentation/cubit/campaign_cubit.dart';
import 'package:sudoku/features/sudoku/presentation/cubit/daily_challenge_cubit.dart';
import 'package:sudoku/features/sudoku/presentation/pages/home_page.dart';

class MockSudokuRepository extends Mock implements SudokuRepository {}
class MockSettingsCubit extends MockCubit<SettingsState> implements SettingsCubit {}
class MockEconomyCubit extends MockCubit<EconomyState> implements EconomyCubit {}
class MockCampaignCubit extends MockCubit<CampaignState> implements CampaignCubit {}
class MockDailyChallengeCubit extends MockCubit<DailyChallengeState> implements DailyChallengeCubit {}

void main() {
  late MockSudokuRepository mockRepository;
  late MockSettingsCubit mockSettingsCubit;
  late MockEconomyCubit mockEconomyCubit;
  late MockCampaignCubit mockCampaignCubit;
  late MockDailyChallengeCubit mockDailyChallengeCubit;

  setUpAll(() {
    registerFallbackValue(SettingsState.initial());
    registerFallbackValue(EconomyState.initial());
  });

  setUp(() {
    mockRepository = MockSudokuRepository();
    mockSettingsCubit = MockSettingsCubit();
    mockEconomyCubit = MockEconomyCubit();
    mockCampaignCubit = MockCampaignCubit();
    mockDailyChallengeCubit = MockDailyChallengeCubit();

    // Default stubbing
    when(() => mockRepository.hasSavedGame()).thenAnswer((_) async => false);
    when(() => mockRepository.loadGameState()).thenAnswer((_) async => null);

    final sl = GetIt.instance;
    sl.allowReassignment = true;
    sl.registerSingleton<SudokuRepository>(mockRepository);
    sl.registerSingleton<SettingsCubit>(mockSettingsCubit);
    sl.registerSingleton<EconomyCubit>(mockEconomyCubit);
    sl.registerSingleton<CampaignCubit>(mockCampaignCubit);
    sl.registerSingleton<DailyChallengeCubit>(mockDailyChallengeCubit);
  });

  Widget createTestWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>.value(value: mockSettingsCubit),
        BlocProvider<EconomyCubit>.value(value: mockEconomyCubit),
        BlocProvider<CampaignCubit>.value(value: mockCampaignCubit),
        BlocProvider<DailyChallengeCubit>.value(value: mockDailyChallengeCubit),
      ],
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
  }

  testWidgets('renders personalized greeting from settings cubit', (WidgetTester tester) async {
    when(() => mockSettingsCubit.state).thenReturn(
      SettingsState.initial().copyWith(username: 'Sudoku Expert'),
    );
    when(() => mockEconomyCubit.state).thenReturn(EconomyState.initial());
    when(() => mockCampaignCubit.state).thenReturn(const CampaignState(volumes: [], completionStatus: {}));
    when(() => mockDailyChallengeCubit.state).thenReturn(const DailyChallengeState(completedChallenges: {}));

    await tester.pumpWidget(createTestWidget());

    expect(find.text('Hello Sudoku Expert'), findsOneWidget);
  });

  testWidgets('decluttered homepage does not show redundant newsstand card', (WidgetTester tester) async {
    when(() => mockSettingsCubit.state).thenReturn(SettingsState.initial());
    when(() => mockEconomyCubit.state).thenReturn(EconomyState.initial());
    when(() => mockCampaignCubit.state).thenReturn(const CampaignState(volumes: [], completionStatus: {}));
    when(() => mockDailyChallengeCubit.state).thenReturn(const DailyChallengeState(completedChallenges: {}));

    await tester.pumpWidget(createTestWidget());

    // The shop button / droplet badge might have text, but the redundant card is removed
    expect(find.text('THE NEWSSTAND'), findsNothing);
  });

  testWidgets('clicking quick play card opens the select difficulty dialog', (WidgetTester tester) async {
    when(() => mockSettingsCubit.state).thenReturn(SettingsState.initial());
    when(() => mockEconomyCubit.state).thenReturn(EconomyState.initial());
    when(() => mockCampaignCubit.state).thenReturn(const CampaignState(volumes: [], completionStatus: {}));
    when(() => mockDailyChallengeCubit.state).thenReturn(const DailyChallengeState(completedChallenges: {}));

    await tester.pumpWidget(createTestWidget());

    // Tap the quick play card
    await tester.tap(find.byKey(const Key('quick_play_card')));
    await tester.pumpAndSettle();

    // Dialog is visible
    expect(find.text('SELECT DIFFICULTY'), findsOneWidget);
    expect(find.text('BEGINNER'), findsOneWidget);
    expect(find.text('MEDIUM'), findsOneWidget);
    expect(find.text('HARD'), findsOneWidget);
    expect(find.text('EXPERT'), findsOneWidget);
  });
}
