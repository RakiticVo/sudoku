import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:sudoku/features/sudoku/presentation/cubit/settings_cubit.dart';
import 'package:sudoku/features/sudoku/presentation/cubit/economy_cubit.dart';
import 'package:sudoku/features/sudoku/presentation/cubit/campaign_cubit.dart';
import 'package:sudoku/features/sudoku/presentation/pages/campaign_page.dart';
import 'package:sudoku/features/sudoku/presentation/widgets/control_pad.dart';

class MockSettingsCubit extends MockCubit<SettingsState> implements SettingsCubit {}
class MockEconomyCubit extends MockCubit<EconomyState> implements EconomyCubit {}
class MockCampaignCubit extends MockCubit<CampaignState> implements CampaignCubit {}

void main() {
  late MockSettingsCubit mockSettingsCubit;
  late MockEconomyCubit mockEconomyCubit;
  late MockCampaignCubit mockCampaignCubit;

  setUpAll(() {
    registerFallbackValue(SettingsState.initial());
    registerFallbackValue(EconomyState.initial());
    registerFallbackValue(const CampaignState(volumes: [], completionStatus: {}));
  });

  setUp(() {
    mockSettingsCubit = MockSettingsCubit();
    mockEconomyCubit = MockEconomyCubit();
    mockCampaignCubit = MockCampaignCubit();

    final sl = GetIt.instance;
    sl.allowReassignment = true;
    sl.registerSingleton<SettingsCubit>(mockSettingsCubit);
    sl.registerSingleton<EconomyCubit>(mockEconomyCubit);
    sl.registerSingleton<CampaignCubit>(mockCampaignCubit);

    // Default stubbing
    when(() => mockSettingsCubit.state).thenReturn(SettingsState.initial());
    when(() => mockEconomyCubit.state).thenReturn(EconomyState.initial());
  });

  Widget createTestWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>.value(value: mockSettingsCubit),
        BlocProvider<EconomyCubit>.value(value: mockEconomyCubit),
        BlocProvider<CampaignCubit>.value(value: mockCampaignCubit),
      ],
      child: const MaterialApp(
        home: CampaignPage(),
      ),
    );
  }

  // Preset mock volumes to load in CampaignCubit state
  final mockVolumes = [
    const CampaignVolume(
      id: 'vol_gutenberg',
      title: 'The Gutenberg Press',
      subtitle: 'dawn of movable print',
      year: '1456',
      dropletReward: 500,
      levels: [
        CampaignLevel(index: 0, seed: 100, difficulty: 'easy'),
        CampaignLevel(index: 1, seed: 101, difficulty: 'medium'),
      ],
      editorialTitle: 'THE GUTENBERG CHRONICLE',
      editorialContent: 'Johannes Gutenberg perfected typography.',
    ),
    const CampaignVolume(
      id: 'vol_pennypress',
      title: 'The Penny Press Era',
      subtitle: 'news for the common man',
      year: '1833',
      dropletReward: 800,
      levels: [
        CampaignLevel(index: 0, seed: 200, difficulty: 'easy'),
      ],
      editorialTitle: 'THE PENNY REGISTER',
      editorialContent: 'Cheap prints changed information.',
    ),
    const CampaignVolume(
      id: 'vol_times',
      title: 'The Times Revolution',
      subtitle: 'standardizing global broadsides',
      year: '1920',
      dropletReward: 1200,
      levels: [
        CampaignLevel(index: 0, seed: 300, difficulty: 'easy'),
      ],
      editorialTitle: 'THE TIMES DAILY',
      editorialContent: 'Georgia standardizes global broadsides.',
    ),
  ];

  group('CampaignPage Test Suite', () {
    testWidgets('TC_CAMPAIGN_001: TabBar renders Gutenberg, Penny Era, and Times tabs', (WidgetTester tester) async {
      when(() => mockCampaignCubit.state).thenReturn(CampaignState(
        volumes: mockVolumes,
        completionStatus: const {
          'vol_gutenberg': [false, false],
          'vol_pennypress': [false],
          'vol_times': [false],
        },
      ));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for Tab text
      expect(find.text('1456 GUTENBERG'), findsOneWidget);
      expect(find.text('1833 PENNY ERA'), findsOneWidget);
      expect(find.text('1920 TIMES'), findsOneWidget);
    });

    testWidgets('TC_CAMPAIGN_002: Volume swipe and tab switching functions correctly', (WidgetTester tester) async {
      when(() => mockCampaignCubit.state).thenReturn(CampaignState(
        volumes: mockVolumes,
        completionStatus: const {
          'vol_gutenberg': [false, false],
          'vol_pennypress': [false],
          'vol_times': [false],
        },
      ));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Initially on Gutenberg press
      expect(find.text('THE GUTENBERG PRESS'), findsOneWidget);
      expect(find.text('THE PENNY PRESS ERA'), findsNothing);

      // Tap Penny Era tab
      await tester.tap(find.text('1833 PENNY ERA'));
      await tester.pumpAndSettle();

      // Should now render Penny Press Era volume details
      expect(find.text('THE GUTENBERG PRESS'), findsNothing);
      expect(find.text('THE PENNY PRESS ERA'), findsOneWidget);
    });

    testWidgets('TC_CAMPAIGN_003: Locked broadside snackbar shows correct reward text', (WidgetTester tester) async {
      when(() => mockCampaignCubit.state).thenReturn(CampaignState(
        volumes: mockVolumes,
        completionStatus: const {
          'vol_gutenberg': [false, false],
          'vol_pennypress': [false],
          'vol_times': [false],
        },
      ));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tapping VOLUME LOCKED/Locked Historical Reader button should display the required SnackBar copy
      final lockedReaderBtn = find.text('VOLUME LOCKED');
      expect(lockedReaderBtn, findsOneWidget);

      await tester.tap(lockedReaderBtn);
      await tester.pump();

      // Assert SnackBar displays: "Complete all 100 editions to unlock the Historical Front Page broadsheet reward (+500💧)."
      expect(
        find.text('Complete all 100 editions to unlock the Historical Front Page broadsheet reward (+500💧).'),
        findsOneWidget,
      );
    });
  });
}
