import 'package:flutter/material.dart';
import 'package:wrench/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/app/router.dart';
import 'package:wrench/app/theme.dart';
import 'package:wrench/core/presentation/controllers/settings_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final router = ref.watch(routerProvider);
    final textTheme = createTextTheme(context, 'Inter', 'Inter');
    final theme = MaterialTheme(textTheme);

    return settingsAsync.when(
      data: (state) => MaterialApp.router(
        theme: theme.light(),
        darkTheme: theme.dark(),
        themeMode: state.themeMode,
        locale: state.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
      loading: () => const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (err, stack) => MaterialApp(
        home: Scaffold(body: Center(child: Text('Something went wrong: $err'))),
      ),
    );
  }
}
