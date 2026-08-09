import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/presentation/controllers/settings_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferencesAsync prefs;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    prefs = SharedPreferencesAsync();
  });

  ProviderContainer buildContainer() {
    return ProviderContainer(
      overrides: [
        settingsProvider.overrideWith(() => SettingsNotifier(prefs: prefs)),
      ],
    );
  }

  test('builds with system defaults', () async {
    final container = buildContainer();
    addTearDown(container.dispose);

    final state = await container.read(settingsProvider.future);

    expect(state.themeMode, ThemeMode.system);
    expect(state.localeCode, 'system');
    expect(state.locale, isNull);
  });

  test('setThemeMode updates state and persists', () async {
    final container = buildContainer();
    addTearDown(container.dispose);

    await container.read(settingsProvider.future);
    await container
        .read(settingsProvider.notifier)
        .setThemeMode(ThemeMode.dark);

    final state = container.read(settingsProvider).value!;
    expect(state.themeMode, ThemeMode.dark);
    expect(await prefs.getString('theme_mode'), 'dark');
  });

  test('setLocaleCode updates state and persists', () async {
    final container = buildContainer();
    addTearDown(container.dispose);

    await container.read(settingsProvider.future);
    await container.read(settingsProvider.notifier).setLocaleCode('ar');

    final state = container.read(settingsProvider).value!;
    expect(state.localeCode, 'ar');
    expect(state.locale, const Locale('ar'));
    expect(await prefs.getString('locale_code'), 'ar');
  });

  test('builds from persisted preferences', () async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData({
          'theme_mode': 'dark',
          'locale_code': 'ar',
        });
    prefs = SharedPreferencesAsync();

    final container = buildContainer();
    addTearDown(container.dispose);

    final state = await container.read(settingsProvider.future);

    expect(state.themeMode, ThemeMode.dark);
    expect(state.localeCode, 'ar');
    expect(state.locale, const Locale('ar'));
  });

  test('throws ConfigurationException when no state exists', () async {
    final container = buildContainer();
    addTearDown(container.dispose);

    await expectLater(
      container.read(settingsProvider.notifier).setThemeMode(ThemeMode.light),
      throwsA(isA<ConfigurationException>()),
    );
  });
}
