import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/presentation/controllers/jobs_provider.dart';
import 'package:wrench/core/presentation/controllers/settings_provider.dart';
import 'package:wrench/features/home/presentation/controllers/home_provider.dart';
import 'package:wrench/l10n/app_localizations.dart';
import 'package:wrench/l10n/app_localizations_en.dart';

Future<void> pumpWidgetWithProviders(
  WidgetTester tester,
  Widget child, {
  List<Job>? jobs,
  List<Job>? recentJobs,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        if (jobs != null) jobsProvider.overrideWith((ref) async => jobs),
        if (recentJobs != null)
          homeProvider.overrideWith((ref) async => recentJobs),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    ),
  );
}

AppLocalizations testL10n() => AppLocalizationsEn();

Future<void> pumpSettingsWidget(WidgetTester tester, Widget child) async {
  SharedPreferencesAsyncPlatform.instance =
      InMemorySharedPreferencesAsync.empty();
  final prefs = SharedPreferencesAsync();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        settingsProvider.overrideWith(() => SettingsNotifier(prefs: prefs)),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    ),
  );
}
