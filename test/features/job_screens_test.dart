import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/app/theme.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/models/user.dart';
import 'package:wrench/core/data/repositories/jobs_repository.dart';
import 'package:wrench/core/presentation/controllers/jobs_provider.dart';
import 'package:wrench/core/presentation/controllers/settings_provider.dart';
import 'package:wrench/core/presentation/controllers/users_provider.dart';
import 'package:wrench/core/presentation/widgets/job_item.dart';
import 'package:wrench/features/jobs/presentation/screens/job_detail_screen.dart';
import 'package:wrench/features/jobs/presentation/screens/jobs_screen.dart';
import 'package:wrench/features/profile/presentation/screens/profile_screen.dart';
import 'package:wrench/features/settings/presentation/screens/main_settings_screen.dart';
import 'package:wrench/l10n/app_localizations.dart';

import '../core/fake_jobs_source.dart';
import '../core/job_fixtures.dart';

/// Reads the settings state without going near the platform channel.
class _FakeSettings extends SettingsNotifier {
  @override
  Future<SettingsState> build() async => const SettingsState();
}

/// The shared fixture gives every field the same value, which is fine for model
/// tests but makes `find.text` ambiguous once a screen shows several of them.
Job _job(JobState state) => jobWith(state).copyWith(
  title: "Fix the pump",
  description: "Leaking at the seal",
  location: "Zone 4",
);

Widget _app(
  Widget home,
  List<Job> jobs, {
  Brightness brightness = Brightness.light,
}) {
  return ProviderScope(
    // The real notifier over a fake source, so paging, filtering and counting
    // are the app's own code rather than a stand-in for it.
    overrides: [
      jobsRepositoryProvider.overrideWithValue(
        JobsRepository(source: FakeJobsSource(jobs)),
      ),
      currentUserIdProvider.overrideWithValue("user-1"),
      usersProvider.overrideWith(
        (ref) async => [
          User(
            id: "user-1",
            fullName: "Amina Yusuf",
            role: UserRole.worker,
            createdAt: DateTime(2026),
            updatedAt: DateTime(2026),
          ),
        ],
      ),
      settingsProvider.overrideWith(_FakeSettings.new),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        brightness: brightness,
        colorScheme: brightness == Brightness.light
            ? MaterialTheme.lightScheme()
            : MaterialTheme.darkScheme(),
      ),
      home: home,
    ),
  );
}

Future<AppLocalizations> _l10n() =>
    AppLocalizations.delegate.load(const Locale("en"));

void main() {
  final jobs = allStates.map(_job).toList();

  group("JobsScreen", () {
    testWidgets("lays out a card per job without overflowing", (tester) async {
      await tester.pumpWidget(_app(const JobsScreen(), jobs));
      await tester.pumpAndSettle();

      expect(find.byType(JobItem), findsNWidgets(jobs.length));
      expect(tester.takeException(), isNull);
    });

    testWidgets("opens on the filter the route asked for", (tester) async {
      await tester.pumpWidget(
        _app(const JobsScreen(initialFilter: "staged"), jobs),
      );
      await tester.pumpAndSettle();

      // One job per status in the fixtures, so a status filter leaves one card.
      expect(find.byType(JobItem), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets("closes the list once every page has loaded", (tester) async {
      await tester.pumpWidget(_app(const JobsScreen(), jobs));
      await tester.pumpAndSettle();

      final l10n = await _l10n();

      // The footer sits below the fold on a test-sized screen. The jobs list is
      // named explicitly because the filter chips are a scrollable too.
      await tester.scrollUntilVisible(
        find.text(l10n.endOfList),
        200,
        scrollable: find.descendant(
          of: find.byType(RefreshIndicator),
          matching: find.byType(Scrollable),
        ),
      );

      expect(find.text(l10n.endOfList), findsOneWidget);
    });

    testWidgets("explains itself when there is nothing to show", (
      tester,
    ) async {
      await tester.pumpWidget(_app(const JobsScreen(), const []));
      await tester.pumpAndSettle();

      final l10n = await _l10n();

      expect(find.text(l10n.noJobsFound), findsOneWidget);
      expect(find.text(l10n.noJobsFoundHint), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group("JobDetailScreen", () {
    for (final state in allStates) {
      final job = _job(state);

      testWidgets("renders a ${job.status.name} job", (tester) async {
        await tester.pumpWidget(
          _app(JobDetailScreen(jobId: job.id, job: job), [job]),
        );
        await tester.pumpAndSettle();

        final l10n = await _l10n();

        expect(find.text(job.title), findsOneWidget);
        expect(find.text(job.status.label(l10n)), findsWidgets);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets("renders in the dark scheme too", (tester) async {
      final job = _job(inProgress);

      await tester.pumpWidget(
        _app(
          JobDetailScreen(jobId: job.id, job: job),
          [job],
          brightness: Brightness.dark,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets("offers the advancing move as the next step", (tester) async {
      final job = _job(staged);

      await tester.pumpWidget(
        _app(JobDetailScreen(jobId: job.id, job: job), [job]),
      );
      await tester.pumpAndSettle();

      final l10n = await _l10n();

      expect(find.text(l10n.nextStep), findsOneWidget);
      expect(find.text(l10n.approveJob), findsOneWidget);
      expect(find.text(l10n.startJob), findsNothing);
    });

    testWidgets("keeps cancelling out of the menu, not beside it", (
      tester,
    ) async {
      final job = _job(staged);

      await tester.pumpWidget(
        _app(JobDetailScreen(jobId: job.id, job: job), [job]),
      );
      await tester.pumpAndSettle();

      final l10n = await _l10n();

      // Only reachable through the overflow, so it cannot be hit by mistake.
      expect(find.text(l10n.cancelJob), findsNothing);
      expect(find.byType(PopupMenuButton<void>), findsOneWidget);

      await tester.tap(find.byType(PopupMenuButton<void>));
      await tester.pumpAndSettle();

      expect(find.text(l10n.cancelJob), findsOneWidget);
    });

    testWidgets("a finished job offers no moves at all", (tester) async {
      final job = _job(finished);

      await tester.pumpWidget(
        _app(JobDetailScreen(jobId: job.id, job: job), [job]),
      );
      await tester.pumpAndSettle();

      final l10n = await _l10n();

      expect(find.text(l10n.nextStep), findsNothing);
      expect(find.byType(PopupMenuButton<void>), findsNothing);
    });
  });

  group("ProfileScreen", () {
    testWidgets("shows the user, their totals and the account actions", (
      tester,
    ) async {
      await tester.pumpWidget(_app(const ProfileScreen(), jobs));
      await tester.pumpAndSettle();

      final l10n = await _l10n();

      expect(find.text("Amina Yusuf"), findsOneWidget);
      expect(find.text(l10n.yourJobs), findsOneWidget);
      expect(find.text(l10n.signOut), findsOneWidget);
      // One job per status in the fixtures, and all of them are this user's.
      expect(find.text("1 ${JobStatus.finished.label(l10n)}"), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group("MainSettingsScreen", () {
    testWidgets("states the current language rather than hiding it", (
      tester,
    ) async {
      await tester.pumpWidget(_app(const MainSettingsScreen(), jobs));
      await tester.pumpAndSettle();

      final l10n = await _l10n();

      expect(find.text(l10n.appearance), findsOneWidget);
      expect(find.text(l10n.language), findsOneWidget);
      // "System" is both the default language answer and a theme segment.
      expect(find.text(l10n.system), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });
  });
}
