import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/features/home/presentation/widgets/recent_jobs_header.dart';

import '../../../../helpers/widget_test_utils.dart';

void main() {
  testWidgets('renders the section title and view all button', (tester) async {
    final l10n = testL10n();

    await pumpWidgetWithProviders(
      tester,
      const Scaffold(body: RecentJobsHeader()),
    );

    expect(find.text(l10n.recentJobs), findsOneWidget);
    expect(find.text(l10n.viewAll), findsOneWidget);
  });
}
