import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:sudoku/core/database/sudoku_database.dart';
import 'package:sudoku/features/sudoku/presentation/cubit/settings_cubit.dart';
import 'package:sudoku/features/sudoku/presentation/cubit/economy_cubit.dart';
import 'package:sudoku/features/sudoku/presentation/pages/settings_page.dart';

class MockSudokuDatabase extends Mock implements SudokuDatabase {}
class MockSettingsCubit extends MockCubit<SettingsState> implements SettingsCubit {}
class MockEconomyCubit extends MockCubit<EconomyState> implements EconomyCubit {}

void main() {
  late MockSudokuDatabase mockDatabase;
  late MockSettingsCubit mockSettingsCubit;
  late MockEconomyCubit mockEconomyCubit;

  setUpAll(() {
    registerFallbackValue(SettingsState.initial());
    registerFallbackValue(EconomyState.initial());
  });

  setUp(() {
    mockDatabase = MockSudokuDatabase();
    mockSettingsCubit = MockSettingsCubit();
    mockEconomyCubit = MockEconomyCubit();

    // Setup mocks
    when(() => mockDatabase.getAllReplays()).thenAnswer((_) async => []);

    final sl = GetIt.instance;
    sl.allowReassignment = true;
    sl.registerSingleton<SudokuDatabase>(mockDatabase);
    sl.registerSingleton<SettingsCubit>(mockSettingsCubit);
    sl.registerSingleton<EconomyCubit>(mockEconomyCubit);
  });

  Widget createTestWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>.value(value: mockSettingsCubit),
        BlocProvider<EconomyCubit>.value(value: mockEconomyCubit),
      ],
      child: const MaterialApp(
        home: SettingsPage(),
      ),
    );
  }

  testWidgets('renders publisher name field with correct initial username', (WidgetTester tester) async {
    when(() => mockSettingsCubit.state).thenReturn(
      SettingsState.initial().copyWith(username: 'Alice'),
    );
    when(() => mockEconomyCubit.state).thenReturn(EconomyState.initial());

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Verify the textfield exists and has Alice inside
    final nameFinder = find.byKey(const Key('username_field'));
    expect(nameFinder, findsOneWidget);
    
    final nameTextField = tester.widget<TextFormField>(nameFinder);
    expect(nameTextField.controller?.text, 'Alice');
  });

  testWidgets('typing a new username triggers setUsername on SettingsCubit', (WidgetTester tester) async {
    when(() => mockSettingsCubit.state).thenReturn(SettingsState.initial());
    when(() => mockEconomyCubit.state).thenReturn(EconomyState.initial());
    when(() => mockSettingsCubit.setUsername(any())).thenAnswer((_) async => {});

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    final nameFinder = find.byKey(const Key('username_field'));
    await tester.enterText(nameFinder, 'Bob');
    await tester.pump();

    verify(() => mockSettingsCubit.setUsername('Bob')).called(1);
  });

  testWidgets('renders locked items with padlock and disables selection, and allows unlocked ones', (WidgetTester tester) async {
    when(() => mockSettingsCubit.state).thenReturn(SettingsState.initial());
    // Teal Cyan is locked (not in unlockedInks), Vintage Sepia is unlocked (in unlockedInks)
    when(() => mockEconomyCubit.state).thenReturn(
      EconomyState.initial().copyWith(
        unlockedInks: ['Charcoal', 'Vintage Sepia'],
      ),
    );

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Teal Cyan should have padlock
    expect(find.text('Sleek premium cyan ink 🔒'), findsOneWidget);
    
    // Vintage Sepia should not have padlock
    expect(find.text('Warm sepia photo dye'), findsOneWidget);

    // Verify RadioListTile onChanged states
    final tealFinder = find.widgetWithText(RadioListTile<String>, 'Sleek premium cyan ink 🔒');
    final tealRadio = tester.widget<RadioListTile<String>>(tealFinder);
    expect(tealRadio.onChanged, isNull); // disabled!

    final sepiaFinder = find.widgetWithText(RadioListTile<String>, 'Warm sepia photo dye');
    final sepiaRadio = tester.widget<RadioListTile<String>>(sepiaFinder);
    expect(sepiaRadio.onChanged, isNotNull); // enabled!
  });
}
