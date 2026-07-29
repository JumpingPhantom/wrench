import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kThemeKey = 'theme_mode';
const _kLocaleKey = 'locale_code';

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    _load();
    return const SettingsState();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_kThemeKey) ?? 2;
    final localeCode = prefs.getString(_kLocaleKey) ?? 'system';

    state = SettingsState(
      themeMode: ThemeMode.values[themeIndex],
      localeCode: localeCode,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kThemeKey, mode.index);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setLocaleCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocaleKey, code);
    state = state.copyWith(localeCode: code);
  }
}

class SettingsState {
  final ThemeMode themeMode;
  final String localeCode;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.localeCode = 'system',
  });

  SettingsState copyWith({ThemeMode? themeMode, String? localeCode}) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      localeCode: localeCode ?? this.localeCode,
    );
  }

  Locale? get locale {
    if (localeCode == 'system') return null;
    return Locale(localeCode);
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
