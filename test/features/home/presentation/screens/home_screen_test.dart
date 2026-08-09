import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/features/home/presentation/controllers/home_provider.dart';
import 'package:wrench/features/home/presentation/screens/home_screen.dart';
import 'package:wrench/features/home/presentation/widgets/job_item.dart';
import 'package:wrench/features/home/presentation/widgets/overview_title.dart';
import 'package:wrench/features/home/presentation/widgets/recent_jobs_header.dart';
import 'package:wrench/features/home/presentation/widgets/jobs_count.dart';
import 'package:wrench/l10n/app_localizations.dart';

import '../../../../helpers/test_jobs.dart';
import '../../../../helpers/widget_test_utils.dart';

void main() {
  testWidgets('shows a loading indicator before data arrives', (tester) async {
    await pumpWidgetWithProviders(
      tester,
      const HomeScreen(),
      recentJobs: buildJobs(),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders the overview and recent jobs sections', (tester) async {
    final l10n = testL10n();
    final jobs = buildJobs();

    await pumpWidgetWithProviders(tester, const HomeScreen(), recentJobs: jobs);
    await tester.pump();

    expect(find.byType(OverviewTitle), findsOneWidget);
    expect(find.text(l10n.overview), findsOneWidget);
    expect(find.byType(RecentJobsHeader), findsOneWidget);
    expect(find.byType(JobsCount), findsOneWidget);
    expect(find.byType(JobItem), findsNWidgets(jobs.length));
  });

  testWidgets('shows an error message when loading fails', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeProvider.overrideWithValue(
            AsyncError<List<Job>>(Exception('boom'), StackTrace.empty),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HomeScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Error'), findsOneWidget);
  });
}
