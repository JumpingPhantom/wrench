import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wrench/core/presentation/screens/main_scaffold.dart';
import 'package:wrench/l10n/app_localizations.dart';

import '../../../helpers/widget_test_utils.dart';

GoRouter _buildRouter(String initialLocation) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const SizedBox()),
          GoRoute(path: '/jobs', builder: (context, state) => const SizedBox()),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SizedBox(),
          ),
        ],
      ),
    ],
  );
}

Future<void> _pumpScaffold(WidgetTester tester, String location) async {
  await tester.pumpWidget(
    MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _buildRouter(location),
    ),
  );
}

void main() {
  testWidgets('renders the app bar and navigation destinations', (
    tester,
  ) async {
    final l10n = testL10n();

    await _pumpScaffold(tester, '/');

    expect(find.text(l10n.appTitle), findsOneWidget);
    expect(find.text(l10n.home), findsOneWidget);
    expect(find.text(l10n.jobs), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });

  testWidgets('highlights the selected destination', (tester) async {
    await _pumpScaffold(tester, '/');

    final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(navBar.selectedIndex, 0);

    await tester.tap(find.text(testL10n().jobs));
    await tester.pumpAndSettle();

    final updated = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(updated.selectedIndex, 1);
  });

  testWidgets('selects the jobs index when on the jobs route', (tester) async {
    await _pumpScaffold(tester, '/jobs');

    final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(navBar.selectedIndex, 1);
  });
}
