import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/repositories/jobs_repository.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/presentation/controllers/jobs_provider.dart';
import 'package:wrench/core/presentation/controllers/users_provider.dart';
import 'package:wrench/core/presentation/widgets/empty_state.dart';
import 'package:wrench/core/presentation/widgets/job_item.dart';
import 'package:wrench/features/home/presentation/screens/home_screen.dart';
import 'package:wrench/features/jobs/presentation/screens/create_job_screen.dart';
import 'package:wrench/l10n/app_localizations.dart';

import '../core/fake_jobs_source.dart';
import '../core/job_fixtures.dart';

/// The create route is wired up for real, so the empty state's button is tested
/// against where it actually lands rather than against a stub.
Widget _app(List<Job> jobs, {FakeJobsSource? source}) {
  final router = GoRouter(
    routes: [
      GoRoute(path: "/", builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: "/jobs/new",
        builder: (context, state) => const CreateJobScreen(),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      jobsRepositoryProvider.overrideWithValue(
        JobsRepository(source: source ?? FakeJobsSource(jobs)),
      ),
      currentUserIdProvider.overrideWithValue("user-1"),
    ],
    child: MaterialApp.router(
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
  group("HomeScreen", () {
    testWidgets("says the list is empty rather than showing blank space", (
      tester,
    ) async {
      final l10n = await _l10n();

      await tester.pumpWidget(_app([]));
      await tester.pumpAndSettle();

      expect(find.text(l10n.noJobsYet), findsOneWidget);
      expect(find.text(l10n.noJobsYetHint), findsOneWidget);
      expect(find.text(l10n.createJobAction), findsOneWidget);

      // The overview stands down entirely: a tally of zeroes and a link into an
      // empty list are worse than nothing on a first run.
      expect(find.byType(JobItem), findsNothing);
      expect(find.text(l10n.overview), findsNothing);
      expect(find.text(l10n.viewAll), findsNothing);
    });

    testWidgets("its button opens the create wizard", (tester) async {
      final l10n = await _l10n();

      await tester.pumpWidget(_app([]));
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.createJobAction));
      await tester.pumpAndSettle();

      expect(find.text(l10n.whatNeedsDoing), findsOneWidget);
    });

    testWidgets(
      "offers a retry instead of a spinner when the network is down",
      (tester) async {
        final l10n = await _l10n();
        final source = FakeJobsSource([jobWith(draft)])
          ..readError = NetworkException(message: "No route to host");

        await tester.pumpWidget(_app(const [], source: source));
        await tester.pumpAndSettle();

        // The screen has stopped waiting, and says why rather than spinning on.
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text(l10n.noConnection), findsOneWidget);
        expect(find.text(l10n.noConnectionHint), findsOneWidget);
        expect(find.text(l10n.retry), findsOneWidget);

        // Back on the network, the same button loads the screen it failed on.
        source.readError = null;
        await tester.tap(find.text(l10n.retry));
        await tester.pumpAndSettle();

        expect(find.text(l10n.noConnection), findsNothing);
        expect(find.byType(JobItem), findsOneWidget);
      },
    );

    testWidgets("shows the overview once there is a job to show", (
      tester,
    ) async {
      final l10n = await _l10n();

      await tester.pumpWidget(_app([jobWith(draft)]));
      await tester.pumpAndSettle();

      expect(find.byType(JobItem), findsOneWidget);
      expect(find.text(l10n.overview), findsOneWidget);
      expect(find.byType(EmptyState), findsNothing);
    });
  });
}
