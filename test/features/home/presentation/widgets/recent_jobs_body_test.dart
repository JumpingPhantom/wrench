import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/features/home/presentation/widgets/job_item.dart';
import 'package:wrench/features/home/presentation/widgets/recent_jobs_body.dart';

import '../../../../helpers/test_jobs.dart';
import '../../../../helpers/widget_test_utils.dart';

void main() {
  testWidgets('renders a JobItem per job', (tester) async {
    final jobs = buildJobs();

    await pumpWidgetWithProviders(
      tester,
      Scaffold(body: RecentJobsBody(jobs: jobs)),
    );
    await tester.pump();

    expect(find.byType(JobItem), findsNWidgets(jobs.length));
    for (final job in jobs) {
      expect(find.text(job.title), findsOneWidget);
    }
  });

  testWidgets('renders nothing for an empty list', (tester) async {
    await pumpWidgetWithProviders(
      tester,
      const Scaffold(body: RecentJobsBody(jobs: [])),
    );

    expect(find.byType(JobItem), findsNothing);
  });
}
