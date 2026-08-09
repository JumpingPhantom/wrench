import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/features/home/presentation/widgets/job_item.dart';
import 'package:wrench/features/jobs/presentation/screens/jobs_screen.dart';

import '../../../../helpers/test_jobs.dart';
import '../../../../helpers/widget_test_utils.dart';

void main() {
  testWidgets('shows a loading indicator before data arrives', (tester) async {
    await pumpWidgetWithProviders(
      tester,
      const JobsScreen(),
      jobs: buildJobs(),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders all jobs', (tester) async {
    final jobs = buildJobs();

    await pumpWidgetWithProviders(tester, const JobsScreen(), jobs: jobs);
    await tester.pump();

    expect(find.byType(JobItem), findsNWidgets(jobs.length));
    for (final job in jobs) {
      expect(find.text(job.title), findsOneWidget);
    }
  });

  testWidgets('shows the empty state when no jobs match', (tester) async {
    await pumpWidgetWithProviders(tester, const JobsScreen(), jobs: []);
    await tester.pump();

    expect(find.text(testL10n().noJobsFound), findsOneWidget);
    expect(find.byType(JobItem), findsNothing);
  });

  testWidgets('filters the list when a chip is selected', (tester) async {
    final jobs = buildJobs();

    await pumpWidgetWithProviders(tester, const JobsScreen(), jobs: jobs);
    await tester.pump();

    await tester.tap(find.widgetWithText(FilterChip, 'Pending'));
    await tester.pump();

    expect(find.byType(JobItem), findsOneWidget);
    expect(find.text('Fix leaking pipe'), findsOneWidget);
    expect(find.text('Install new fuse box'), findsNothing);
  });

  testWidgets('searches jobs by title', (tester) async {
    await pumpWidgetWithProviders(
      tester,
      const JobsScreen(),
      jobs: buildJobs(),
    );
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'fuse');
    await tester.pump();

    expect(find.byType(JobItem), findsOneWidget);
    expect(find.text('Install new fuse box'), findsOneWidget);
    expect(find.text('Fix leaking pipe'), findsNothing);
  });
}
