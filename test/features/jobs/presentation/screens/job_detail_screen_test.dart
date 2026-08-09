import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/features/jobs/presentation/screens/job_detail_screen.dart';

import '../../../../helpers/test_jobs.dart';
import '../../../../helpers/widget_test_utils.dart';

void main() {
  testWidgets('renders job details', (tester) async {
    final l10n = testL10n();
    final job = buildJob(
      state: JobState.staged(stagedAt: DateTime(2026, 8, 1)),
      mediaUrl: null,
    );

    await pumpWidgetWithProviders(tester, JobDetailScreen(job: job));

    expect(find.text(l10n.jobDetails), findsOneWidget);
    expect(find.text(job.title), findsOneWidget);
    expect(find.text(job.statusLabel(l10n)), findsOneWidget);
    expect(find.text(job.location), findsOneWidget);
    expect(find.text(l10n.createdBy(job.createdBy)), findsOneWidget);
    expect(find.text(l10n.description), findsOneWidget);
    expect(find.text(job.description), findsOneWidget);
  });

  testWidgets('renders the media image when a mediaUrl is present', (
    tester,
  ) async {
    final job = buildJob(mediaUrl: 'https://example.com/photo.jpg');

    await pumpWidgetWithProviders(tester, JobDetailScreen(job: job));
    await tester.pump();

    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('does not render a media image without a mediaUrl', (
    tester,
  ) async {
    final job = buildJob(mediaUrl: null);

    await pumpWidgetWithProviders(tester, JobDetailScreen(job: job));

    expect(find.byType(Image), findsNothing);
  });
}
