import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/features/home/presentation/widgets/job_item.dart';

import '../../../../helpers/test_jobs.dart';
import '../../../../helpers/widget_test_utils.dart';

void main() {
  testWidgets('renders title, location and status chip', (tester) async {
    final job = buildJob();

    await pumpWidgetWithProviders(tester, Scaffold(body: JobItem(job: job)));
    await tester.pump();

    expect(find.text(job.title), findsOneWidget);
    expect(find.text(job.location), findsOneWidget);
    expect(find.text(job.statusLabel(testL10n())), findsOneWidget);
  });

  testWidgets('invokes onTap when tapped', (tester) async {
    final job = buildJob();
    var tapped = false;

    await pumpWidgetWithProviders(
      tester,
      Scaffold(
        body: JobItem(job: job, onTap: () => tapped = true),
      ),
    );
    await tester.pump();

    await tester.tap(find.byType(JobItem));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
