import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wrench/core/constants/job_locations.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/repositories/jobs_repository.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/presentation/controllers/jobs_provider.dart';
import 'package:wrench/core/presentation/controllers/users_provider.dart';
import 'package:wrench/features/jobs/presentation/screens/create_job_screen.dart';
import 'package:wrench/l10n/app_localizations.dart';

import '../core/fake_jobs_source.dart';

/// The wizard is pushed rather than mounted directly, because finishing it pops
/// a result: a screen with nothing under it could not report that it was done.
Widget _app(
  FakeJobsSource source, {
  String? currentUser = "user-1",
  Locale? locale,
}) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => Scaffold(
          body: Center(
            child: FilledButton(
              onPressed: () => context.push<bool>("/jobs/new"),
              child: const Text("open"),
            ),
          ),
        ),
      ),
      GoRoute(
        path: "/jobs/new",
        builder: (context, state) => const CreateJobScreen(),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      jobsRepositoryProvider.overrideWithValue(JobsRepository(source: source)),
      currentUserIdProvider.overrideWithValue(currentUser),
    ],
    child: MaterialApp.router(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(useMaterial3: true),
      routerConfig: router,
    ),
  );
}

Future<AppLocalizations> _l10n() =>
    AppLocalizations.delegate.load(const Locale("en"));

void main() {
  group("CreateJobScreen", () {
    testWidgets("will not leave the first step without a description", (
      tester,
    ) async {
      final source = FakeJobsSource([]);
      final l10n = await _l10n();

      await tester.pumpWidget(_app(source));
      await tester.tap(find.text("open"));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, "Fix the pump");
      await tester.tap(find.text(l10n.next));
      await tester.pumpAndSettle();

      // The description used to be required for submit while being the one
      // field that could not say so, which made the button look broken.
      expect(find.text(l10n.requiredField), findsOneWidget);
      expect(find.text(l10n.whatNeedsDoing), findsOneWidget);
      expect(find.text(l10n.whereIsIt), findsNothing);
    });

    testWidgets("offers the locations as chips instead of a text field", (
      tester,
    ) async {
      final source = FakeJobsSource([]);
      final l10n = await _l10n();

      await tester.pumpWidget(_app(source));
      await tester.tap(find.text("open"));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, "Fix the pump");
      await tester.enterText(
        find.byType(TextField).last,
        "Leaking at the seal",
      );
      await tester.tap(find.text(l10n.next));
      await tester.pumpAndSettle();

      expect(find.text(l10n.whereIsIt), findsOneWidget);
      for (final location in jobLocations) {
        expect(find.widgetWithText(ChoiceChip, location), findsOneWidget);
      }

      // Nothing picked yet, so the step holds.
      await tester.tap(find.text(l10n.next));
      await tester.pumpAndSettle();
      expect(find.text(l10n.requiredField), findsOneWidget);
      expect(find.text(l10n.whereIsIt), findsOneWidget);
    });

    testWidgets("back returns to the previous step rather than leaving", (
      tester,
    ) async {
      final source = FakeJobsSource([]);
      final l10n = await _l10n();

      await tester.pumpWidget(_app(source));
      await tester.tap(find.text("open"));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, "Fix the pump");
      await tester.enterText(
        find.byType(TextField).last,
        "Leaking at the seal",
      );
      await tester.tap(find.text(l10n.next));
      await tester.pumpAndSettle();
      expect(find.text(l10n.whereIsIt), findsOneWidget);

      await tester.tap(find.text(l10n.back));
      await tester.pumpAndSettle();

      expect(find.text(l10n.whatNeedsDoing), findsOneWidget);
      // Still on the wizard, and what was typed is still there.
      expect(find.text("Fix the pump"), findsOneWidget);
    });

    testWidgets("files the job the three steps describe", (tester) async {
      final source = FakeJobsSource([]);
      final l10n = await _l10n();

      await tester.pumpWidget(_app(source));
      await tester.tap(find.text("open"));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, "Fix the pump");
      await tester.enterText(
        find.byType(TextField).last,
        "Leaking at the seal",
      );
      await tester.tap(find.text(l10n.next));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ChoiceChip, "Zone 4"));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.next));
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.createJobAction));
      await tester.pumpAndSettle();

      expect(source.jobs, hasLength(1));
      final job = source.jobs.single;
      expect(job.title, "Fix the pump");
      expect(job.description, "Leaking at the seal");
      expect(job.location, "Zone 4");
      expect(job.status, JobStatus.draft);
      expect(job.createdBy, "user-1");
      expect(job.mediaUrl, isNull);

      // Finished means gone: the wizard pops back to what pushed it.
      expect(find.text("open"), findsOneWidget);
    });

    testWidgets("lays out on a narrow screen in Arabic without overflowing", (
      tester,
    ) async {
      // Narrower than any phone the app targets, in the locale that mirrors the
      // whole layout: the step track, the chip wrap and the footer all have to
      // survive both at once.
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final source = FakeJobsSource([]);
      final l10n = await AppLocalizations.delegate.load(const Locale("ar"));

      await tester.pumpWidget(_app(source, locale: const Locale("ar")));
      await tester.tap(find.text("open"));
      await tester.pumpAndSettle();

      expect(find.text(l10n.whatNeedsDoing), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, "إصلاح المضخة");
      await tester.enterText(find.byType(TextField).last, "تسرب عند الحشية");
      await tester.tap(find.text(l10n.next));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ChoiceChip, "Building A"));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.next));
      await tester.pumpAndSettle();

      expect(find.text(l10n.createJobAction), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets("keeps the draft on screen when the save fails", (
      tester,
    ) async {
      final source = FakeJobsSource([])
        ..saveError = OperationException(message: "bucket is on fire");
      final l10n = await _l10n();

      await tester.pumpWidget(_app(source));
      await tester.tap(find.text("open"));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, "Fix the pump");
      await tester.enterText(
        find.byType(TextField).last,
        "Leaking at the seal",
      );
      await tester.tap(find.text(l10n.next));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ChoiceChip, "Zone 4"));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.next));
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.createJobAction));
      await tester.pumpAndSettle();

      expect(find.text(l10n.photoUploadFailed), findsOneWidget);
      expect(find.text(l10n.createJobAction), findsOneWidget);
      expect(source.jobs, isEmpty);

      // The same button retries, and the entered answers are still behind it.
      source.saveError = null;
      await tester.tap(find.text(l10n.createJobAction));
      await tester.pumpAndSettle();

      expect(source.jobs.single.location, "Zone 4");
      expect(find.text("open"), findsOneWidget);
    });
  });
}
