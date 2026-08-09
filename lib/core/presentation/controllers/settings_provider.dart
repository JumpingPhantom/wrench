import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrench/core/errors/exceptions.dart';

const _kThemeKey = 'theme_mode';
const _kLocaleKey = 'locale_code';

class SettingsNotifier extends AsyncNotifier<SettingsState> {
  SharedPreferencesAsync prefs;

  SettingsNotifier({required this.prefs});

  @override
  Future<SettingsState> build() async {
    final currentTheme = await prefs.getString(_kThemeKey);
    final localeCode = await prefs.getString(_kLocaleKey) ?? 'system';

    return SettingsState(
      themeMode: ThemeMode.values.byName(currentTheme ?? 'system'),
      localeCode: localeCode,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final currentState = state.value;

    if (currentState == null) {
      throw ConfigurationException(message: "no state exists.");
    }

    await prefs.setString(_kThemeKey, mode.name);
    state = AsyncData(currentState.copyWith(themeMode: mode));
  }

  Future<void> setLocaleCode(String code) async {
    final currentState = state.value;

    if (currentState == null) {
      throw ConfigurationException(message: "no state exists.");
    }

    await prefs.setString(_kLocaleKey, code);
    state = AsyncData(currentState.copyWith(localeCode: code));
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

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, SettingsState>(
  () => SettingsNotifier(prefs: SharedPreferencesAsync()),
);
