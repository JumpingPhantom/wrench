import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrench/core/errors/exceptions.dart';

const _kThemeKey = 'theme_mode';
const _kLocaleKey = 'locale_code';

/// The store settings are kept in.
///
/// A provider rather than a constructor argument so a test can stand in for it
/// without building a [SharedPreferencesAsync], whose constructor asserts that
/// a platform implementation is registered.
final sharedPreferencesProvider = Provider<SharedPreferencesAsync>((ref) {
  return SharedPreferencesAsync();
});

class SettingsNotifier extends AsyncNotifier<SettingsState> {
  SharedPreferencesAsync get prefs => ref.read(sharedPreferencesProvider);

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
  SettingsNotifier.new,
);
