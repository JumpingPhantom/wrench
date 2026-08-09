import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/features/home/presentation/widgets/jobs_count.dart';

import '../../../../helpers/test_jobs.dart';
import '../../../../helpers/widget_test_utils.dart';

void main() {
  testWidgets('shows pending, in progress and completed counts', (
    tester,
  ) async {
    final l10n = testL10n();

    await pumpWidgetWithProviders(
      tester,
      const Scaffold(body: JobsCount()),
      jobs: buildJobs(),
    );
    await tester.pump();

    expect(find.text(l10n.pendingCount(1)), findsOneWidget);
    expect(find.text(l10n.inProgressCount(1)), findsOneWidget);
    expect(find.text(l10n.completedCount(1)), findsOneWidget);
  });

  testWidgets('shows zero counts for an empty job list', (tester) async {
    final l10n = testL10n();

    await pumpWidgetWithProviders(
      tester,
      const Scaffold(body: JobsCount()),
      jobs: [],
    );
    await tester.pump();

    expect(find.text(l10n.pendingCount(0)), findsOneWidget);
    expect(find.text(l10n.inProgressCount(0)), findsOneWidget);
    expect(find.text(l10n.completedCount(0)), findsOneWidget);
  });

  testWidgets('shows nothing while loading', (tester) async {
    final l10n = testL10n();

    await pumpWidgetWithProviders(
      tester,
      const Scaffold(body: JobsCount()),
      jobs: buildJobs(),
    );

    expect(find.text(l10n.pendingCount(1)), findsNothing);
  });
}
