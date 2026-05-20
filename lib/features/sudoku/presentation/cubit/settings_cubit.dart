import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final bool isDarkNewsprint;
  final String activeFontFamily;
  final String activeInkColorName;
  final String activeStampStyle;
  final String username;

  const SettingsState({
    required this.isDarkNewsprint,
    required this.activeFontFamily,
    required this.activeInkColorName,
    required this.activeStampStyle,
    required this.username,
  });

  factory SettingsState.initial() {
    return const SettingsState(
      isDarkNewsprint: false,
      activeFontFamily: 'Georgia',
      activeInkColorName: 'Charcoal',
      activeStampStyle: 'Approved',
      username: 'User',
    );
  }

  SettingsState copyWith({
    bool? isDarkNewsprint,
    String? activeFontFamily,
    String? activeInkColorName,
    String? activeStampStyle,
    String? username,
  }) {
    return SettingsState(
      isDarkNewsprint: isDarkNewsprint ?? this.isDarkNewsprint,
      activeFontFamily: activeFontFamily ?? this.activeFontFamily,
      activeInkColorName: activeInkColorName ?? this.activeInkColorName,
      activeStampStyle: activeStampStyle ?? this.activeStampStyle,
      username: username ?? this.username,
    );
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences _prefs;

  static const String _keyDarkNewsprint = 'settings_dark_newsprint';
  static const String _keyFontFamily = 'settings_font_family';
  static const String _keyInkColor = 'settings_ink_color';
  static const String _keyStampStyle = 'settings_stamp_style';
  static const String _keyUsername = 'settings_username';

  SettingsCubit(this._prefs) : super(SettingsState.initial()) {
    _loadSettings();
  }

  void _loadSettings() {
    final isDark = _prefs.getBool(_keyDarkNewsprint) ?? false;
    final font = _prefs.getString(_keyFontFamily) ?? 'Georgia';
    final ink = _prefs.getString(_keyInkColor) ?? 'Charcoal';
    final stamp = _prefs.getString(_keyStampStyle) ?? 'Approved';
    final name = _prefs.getString(_keyUsername) ?? 'User';

    emit(SettingsState(
      isDarkNewsprint: isDark,
      activeFontFamily: font,
      activeInkColorName: ink,
      activeStampStyle: stamp,
      username: name,
    ));
  }

  Future<void> toggleDarkNewsprint(bool value) async {
    await _prefs.setBool(_keyDarkNewsprint, value);
    emit(state.copyWith(isDarkNewsprint: value));
  }

  Future<void> setFontFamily(String font) async {
    await _prefs.setString(_keyFontFamily, font);
    emit(state.copyWith(activeFontFamily: font));
  }

  Future<void> setInkColor(String ink) async {
    await _prefs.setString(_keyInkColor, ink);
    emit(state.copyWith(activeInkColorName: ink));
  }

  Future<void> setStampStyle(String stamp) async {
    await _prefs.setString(_keyStampStyle, stamp);
    emit(state.copyWith(activeStampStyle: stamp));
  }

  Future<void> setUsername(String name) async {
    await _prefs.setString(_keyUsername, name);
    emit(state.copyWith(username: name));
  }
}
