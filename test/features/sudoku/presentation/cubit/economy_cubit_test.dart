import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/features/sudoku/presentation/cubit/economy_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EconomyCubit', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        'economy_balance': 100,
        'economy_unlocked_fonts': ['Georgia'],
        'economy_unlocked_inks': ['Charcoal'],
        'economy_unlocked_stamps': ['Approved'],
      });
      prefs = await SharedPreferences.getInstance();
    });

    test('initial state has default values', () async {
      SharedPreferences.setMockInitialValues({});
      final freshPrefs = await SharedPreferences.getInstance();
      final cubit = EconomyCubit(freshPrefs);

      expect(cubit.state.balance, 100);
      expect(cubit.state.unlockedFonts, ['Georgia']);
      expect(cubit.state.unlockedInks, ['Charcoal']);
      expect(cubit.state.unlockedStamps, ['Approved']);
    });

    test('loads saved economy state correctly', () async {
      SharedPreferences.setMockInitialValues({
        'economy_balance': 250,
        'economy_unlocked_fonts': ['Georgia', 'Outfit'],
        'economy_unlocked_inks': ['Charcoal', 'Prussian Blue'],
        'economy_unlocked_stamps': ['Approved', 'Verified'],
      });
      final customPrefs = await SharedPreferences.getInstance();
      final cubit = EconomyCubit(customPrefs);

      expect(cubit.state.balance, 250);
      expect(cubit.state.unlockedFonts, ['Georgia', 'Outfit']);
      expect(cubit.state.unlockedInks, ['Charcoal', 'Prussian Blue']);
      expect(cubit.state.unlockedStamps, ['Approved', 'Verified']);
    });

    blocTest<EconomyCubit, EconomyState>(
      'addDroplets increases balance and saves to preferences',
      build: () => EconomyCubit(prefs),
      act: (cubit) => cubit.addDroplets(50),
      expect: () => [
        isA<EconomyState>()
            .having((s) => s.balance, 'balance', 150)
      ],
      verify: (cubit) {
        expect(prefs.getInt('economy_balance'), 150);
      },
    );

    blocTest<EconomyCubit, EconomyState>(
      'spendDroplets decreases balance and saves to preferences when affordable',
      build: () => EconomyCubit(prefs),
      act: (cubit) async {
        final success = await cubit.spendDroplets(40);
        expect(success, isTrue);
      },
      expect: () => [
        isA<EconomyState>()
            .having((s) => s.balance, 'balance', 60)
      ],
      verify: (cubit) {
        expect(prefs.getInt('economy_balance'), 60);
      },
    );

    test('spendDroplets returns false and does not change balance if unaffordable', () async {
      final cubit = EconomyCubit(prefs);
      final success = await cubit.spendDroplets(150);
      
      expect(success, isFalse);
      expect(cubit.state.balance, 100);
      expect(prefs.getInt('economy_balance'), 100);
    });

    blocTest<EconomyCubit, EconomyState>(
      'unlockFont unlocks new font and reduces balance',
      build: () => EconomyCubit(prefs),
      act: (cubit) async {
        final success = await cubit.unlockFont('Outfit', 50);
        expect(success, isTrue);
      },
      expect: () => [
        isA<EconomyState>()
            .having((s) => s.balance, 'balance', 50),
        isA<EconomyState>()
            .having((s) => s.balance, 'balance', 50)
            .having((s) => s.unlockedFonts, 'unlockedFonts', ['Georgia', 'Outfit'])
      ],
      verify: (cubit) {
        expect(prefs.getInt('economy_balance'), 50);
        expect(prefs.getStringList('economy_unlocked_fonts'), ['Georgia', 'Outfit']);
      },
    );

    test('unlockFont returns true immediately if font is already unlocked without cost', () async {
      final cubit = EconomyCubit(prefs);
      final success = await cubit.unlockFont('Georgia', 50);

      expect(success, isTrue);
      expect(cubit.state.balance, 100);
      expect(cubit.state.unlockedFonts, ['Georgia']);
    });

    test('unlockFont returns false if affordable cost is too high', () async {
      final cubit = EconomyCubit(prefs);
      final success = await cubit.unlockFont('Outfit', 150);

      expect(success, isFalse);
      expect(cubit.state.balance, 100);
      expect(cubit.state.unlockedFonts, ['Georgia']);
    });

    blocTest<EconomyCubit, EconomyState>(
      'unlockInk unlocks new ink and reduces balance',
      build: () => EconomyCubit(prefs),
      act: (cubit) async {
        final success = await cubit.unlockInk('Prussian Blue', 80);
        expect(success, isTrue);
      },
      expect: () => [
        isA<EconomyState>()
            .having((s) => s.balance, 'balance', 20),
        isA<EconomyState>()
            .having((s) => s.balance, 'balance', 20)
            .having((s) => s.unlockedInks, 'unlockedInks', ['Charcoal', 'Prussian Blue'])
      ],
      verify: (cubit) {
        expect(prefs.getInt('economy_balance'), 20);
        expect(prefs.getStringList('economy_unlocked_inks'), ['Charcoal', 'Prussian Blue']);
      },
    );

    blocTest<EconomyCubit, EconomyState>(
      'unlockStamp unlocks new stamp and reduces balance',
      build: () => EconomyCubit(prefs),
      act: (cubit) async {
        final success = await cubit.unlockStamp('Verified', 90);
        expect(success, isTrue);
      },
      expect: () => [
        isA<EconomyState>()
            .having((s) => s.balance, 'balance', 10),
        isA<EconomyState>()
            .having((s) => s.balance, 'balance', 10)
            .having((s) => s.unlockedStamps, 'unlockedStamps', ['Approved', 'Verified'])
      ],
      verify: (cubit) {
        expect(prefs.getInt('economy_balance'), 10);
        expect(prefs.getStringList('economy_unlocked_stamps'), ['Approved', 'Verified']);
      },
    );
  });
}
