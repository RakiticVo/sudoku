import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EconomyState {
  final int balance;
  final List<String> unlockedFonts;
  final List<String> unlockedInks;
  final List<String> unlockedStamps;
  final int hints;
  final int revives;

  const EconomyState({
    required this.balance,
    required this.unlockedFonts,
    required this.unlockedInks,
    required this.unlockedStamps,
    required this.hints,
    required this.revives,
  });

  factory EconomyState.initial() {
    return const EconomyState(
      balance: 100, // Starting capital for vintage purchases
      unlockedFonts: ['Georgia'],
      unlockedInks: ['Charcoal'],
      unlockedStamps: ['Approved'],
      hints: 0,
      revives: 0,
    );
  }

  EconomyState copyWith({
    int? balance,
    List<String>? unlockedFonts,
    List<String>? unlockedInks,
    List<String>? unlockedStamps,
    int? hints,
    int? revives,
  }) {
    return EconomyState(
      balance: balance ?? this.balance,
      unlockedFonts: unlockedFonts ?? this.unlockedFonts,
      unlockedInks: unlockedInks ?? this.unlockedInks,
      unlockedStamps: unlockedStamps ?? this.unlockedStamps,
      hints: hints ?? this.hints,
      revives: revives ?? this.revives,
    );
  }
}

class EconomyCubit extends Cubit<EconomyState> {
  final SharedPreferences _prefs;

  static const String _keyBalance = 'economy_balance';
  static const String _keyUnlockedFonts = 'economy_unlocked_fonts';
  static const String _keyUnlockedInks = 'economy_unlocked_inks';
  static const String _keyUnlockedStamps = 'economy_unlocked_stamps';
  static const String _keyHints = 'economy_hints';
  static const String _keyRevives = 'economy_revives';

  EconomyCubit(this._prefs) : super(EconomyState.initial()) {
    _loadEconomy();
  }

  void _loadEconomy() {
    final balance = _prefs.getInt(_keyBalance) ?? 100;
    final fonts = _prefs.getStringList(_keyUnlockedFonts) ?? ['Georgia'];
    final inks = _prefs.getStringList(_keyUnlockedInks) ?? ['Charcoal'];
    final stamps = _prefs.getStringList(_keyUnlockedStamps) ?? ['Approved'];
    final hintsCount = _prefs.getInt(_keyHints) ?? 0;
    final revivesCount = _prefs.getInt(_keyRevives) ?? 0;

    emit(EconomyState(
      balance: balance,
      unlockedFonts: fonts,
      unlockedInks: inks,
      unlockedStamps: stamps,
      hints: hintsCount,
      revives: revivesCount,
    ));
  }

  Future<void> addDroplets(int amount) async {
    final newBalance = state.balance + amount;
    await _prefs.setInt(_keyBalance, newBalance);
    emit(state.copyWith(balance: newBalance));
  }

  Future<bool> spendDroplets(int amount) async {
    if (state.balance < amount) return false;
    final newBalance = state.balance - amount;
    await _prefs.setInt(_keyBalance, newBalance);
    emit(state.copyWith(balance: newBalance));
    return true;
  }

  Future<bool> buyHint(int cost) async {
    if (state.hints >= 50) return false;
    final success = await spendDroplets(cost);
    if (success) {
      final newHints = state.hints + 1;
      await _prefs.setInt(_keyHints, newHints);
      emit(state.copyWith(hints: newHints));
      return true;
    }
    return false;
  }

  Future<void> useHintToken() async {
    if (state.hints <= 0) return;
    final newHints = state.hints - 1;
    await _prefs.setInt(_keyHints, newHints);
    emit(state.copyWith(hints: newHints));
  }

  Future<bool> buyRevive(int cost) async {
    final success = await spendDroplets(cost);
    if (success) {
      final newRevives = state.revives + 1;
      await _prefs.setInt(_keyRevives, newRevives);
      emit(state.copyWith(revives: newRevives));
      return true;
    }
    return false;
  }

  Future<void> useReviveToken() async {
    if (state.revives <= 0) return;
    final newRevives = state.revives - 1;
    await _prefs.setInt(_keyRevives, newRevives);
    emit(state.copyWith(revives: newRevives));
  }

  Future<bool> unlockFont(String font, int cost) async {
    if (state.unlockedFonts.contains(font)) return true;
    final success = await spendDroplets(cost);
    if (success) {
      final updatedFonts = List<String>.from(state.unlockedFonts)..add(font);
      await _prefs.setStringList(_keyUnlockedFonts, updatedFonts);
      emit(state.copyWith(unlockedFonts: updatedFonts));
      return true;
    }
    return false;
  }

  Future<bool> unlockInk(String ink, int cost) async {
    if (state.unlockedInks.contains(ink)) return true;
    final success = await spendDroplets(cost);
    if (success) {
      final updatedInks = List<String>.from(state.unlockedInks)..add(ink);
      await _prefs.setStringList(_keyUnlockedInks, updatedInks);
      emit(state.copyWith(unlockedInks: updatedInks));
      return true;
    }
    return false;
  }

  Future<bool> unlockStamp(String stamp, int cost) async {
    if (state.unlockedStamps.contains(stamp)) return true;
    final success = await spendDroplets(cost);
    if (success) {
      final updatedStamps = List<String>.from(state.unlockedStamps)..add(stamp);
      await _prefs.setStringList(_keyUnlockedStamps, updatedStamps);
      emit(state.copyWith(unlockedStamps: updatedStamps));
      return true;
    }
    return false;
  }
}
