import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wrench/features/jobs/presentation/screens/create_job_screen.dart';
import 'package:wrench/l10n/app_localizations.dart';

import '../../../../helpers/widget_test_utils.dart';

Future<void> _pumpCreateJob(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: GoRouter(
        initialLocation: '/create',
        routes: [
          GoRoute(
            path: '/create',
            builder: (context, state) => const CreateJobScreen(),
          ),
        ],
      ),
    ),
  );
}

void main() {
  testWidgets('renders the create job form', (tester) async {
    final l10n = testL10n();

    await _pumpCreateJob(tester);

    expect(find.text(l10n.jobTitle), findsOneWidget);
    expect(find.text(l10n.description), findsOneWidget);
    expect(find.text(l10n.location), findsOneWidget);
    expect(find.text(l10n.addPhoto), findsOneWidget);
    expect(find.text(l10n.submit), findsOneWidget);
  });

  testWidgets('shows required-field errors on empty submit', (tester) async {
    final l10n = testL10n();

    await _pumpCreateJob(tester);

    await tester.tap(find.widgetWithText(FilledButton, l10n.submit));
    await tester.pump();

    expect(find.text(l10n.requiredField), findsNWidgets(2));
  });

  testWidgets('pops with the job data on submit', (tester) async {
    final l10n = testL10n();
    final results = <Map<String, dynamic>>[];

    await tester.pumpWidget(
      MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => Scaffold(
                body: Builder(
                  builder: (context) => TextButton(
                    onPressed: () async {
                      final result = await context.push<Map<String, dynamic>>(
                        '/create',
                      );
                      if (result != null) results.add(result);
                    },
                    child: const Text('open'),
                  ),
                ),
              ),
            ),
            GoRoute(
              path: '/create',
              builder: (context, state) => const CreateJobScreen(),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Fix the door');
    await tester.enterText(find.byType(TextField).at(1), 'Hinge is broken');
    await tester.enterText(find.byType(TextField).at(2), 'Zone 1');
    await tester.tap(find.widgetWithText(FilledButton, l10n.submit));
    await tester.pumpAndSettle();

    expect(results, hasLength(1));
    expect(results.single['title'], 'Fix the door');
    expect(results.single['description'], 'Hinge is broken');
    expect(results.single['location'], 'Zone 1');
  });

  testWidgets('shows a discard dialog when closing with unsaved data', (
    tester,
  ) async {
    final l10n = testL10n();

    await _pumpCreateJob(tester);

    await tester.enterText(find.byType(TextField).at(0), 'Fix the door');
    await tester.enterText(find.byType(TextField).at(1), 'Hinge is broken');
    await tester.enterText(find.byType(TextField).at(2), 'Zone 1');
    await tester.pump();

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.text(l10n.unsavedChanges), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, l10n.cancel));
    await tester.pumpAndSettle();

    expect(find.text(l10n.unsavedChanges), findsNothing);
    expect(find.text('Fix the door'), findsOneWidget);
  });
}
