import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/features/sudoku/presentation/cubit/settings_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsCubit', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        'settings_dark_newsprint': false,
        'settings_font_family': 'Georgia',
        'settings_ink_color': 'Charcoal',
        'settings_stamp_style': 'Approved',
        'settings_username': 'User',
      });
      prefs = await SharedPreferences.getInstance();
    });

    test('initial state has default values when no preferences are saved', () async {
      SharedPreferences.setMockInitialValues({});
      final freshPrefs = await SharedPreferences.getInstance();
      final cubit = SettingsCubit(freshPrefs);
      
      expect(cubit.state.isDarkNewsprint, false);
      expect(cubit.state.activeFontFamily, 'Georgia');
      expect(cubit.state.activeInkColorName, 'Charcoal');
      expect(cubit.state.activeStampStyle, 'Approved');
      expect(cubit.state.username, 'User');
    });

    test('loads saved preferences correctly on startup', () async {
      SharedPreferences.setMockInitialValues({
        'settings_dark_newsprint': true,
        'settings_font_family': 'Roboto',
        'settings_ink_color': 'Teal Cyan',
        'settings_stamp_style': 'Rejected',
        'settings_username': 'Grandmaster',
      });
      final customPrefs = await SharedPreferences.getInstance();
      final cubit = SettingsCubit(customPrefs);

      expect(cubit.state.isDarkNewsprint, true);
      expect(cubit.state.activeFontFamily, 'Roboto');
      expect(cubit.state.activeInkColorName, 'Teal Cyan');
      expect(cubit.state.activeStampStyle, 'Rejected');
      expect(cubit.state.username, 'Grandmaster');
    });

    blocTest<SettingsCubit, SettingsState>(
      'toggleDarkNewsprint updates state and SharedPreferences',
      build: () => SettingsCubit(prefs),
      act: (cubit) => cubit.toggleDarkNewsprint(true),
      expect: () => [
        isA<SettingsState>()
            .having((s) => s.isDarkNewsprint, 'isDarkNewsprint', true)
      ],
      verify: (cubit) {
        expect(prefs.getBool('settings_dark_newsprint'), true);
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'setFontFamily updates state and SharedPreferences',
      build: () => SettingsCubit(prefs),
      act: (cubit) => cubit.setFontFamily('Outfit'),
      expect: () => [
        isA<SettingsState>()
            .having((s) => s.activeFontFamily, 'activeFontFamily', 'Outfit')
      ],
      verify: (cubit) {
        expect(prefs.getString('settings_font_family'), 'Outfit');
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'setInkColor updates state and SharedPreferences',
      build: () => SettingsCubit(prefs),
      act: (cubit) => cubit.setInkColor('Prussian Blue'),
      expect: () => [
        isA<SettingsState>()
            .having((s) => s.activeInkColorName, 'activeInkColorName', 'Prussian Blue')
      ],
      verify: (cubit) {
        expect(prefs.getString('settings_ink_color'), 'Prussian Blue');
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'setStampStyle updates state and SharedPreferences',
      build: () => SettingsCubit(prefs),
      act: (cubit) => cubit.setStampStyle('Verified'),
      expect: () => [
        isA<SettingsState>()
            .having((s) => s.activeStampStyle, 'activeStampStyle', 'Verified')
      ],
      verify: (cubit) {
        expect(prefs.getString('settings_stamp_style'), 'Verified');
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'setUsername updates state and SharedPreferences',
      build: () => SettingsCubit(prefs),
      act: (cubit) => cubit.setUsername('SudokuMaster'),
      expect: () => [
        isA<SettingsState>()
            .having((s) => s.username, 'username', 'SudokuMaster')
      ],
      verify: (cubit) {
        expect(prefs.getString('settings_username'), 'SudokuMaster');
      },
    );
  });
}
