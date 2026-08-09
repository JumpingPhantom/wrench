import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/features/home/presentation/widgets/overview_title.dart';

import '../../../../helpers/widget_test_utils.dart';

void main() {
  testWidgets('renders the overview title', (tester) async {
    await pumpWidgetWithProviders(
      tester,
      const Scaffold(body: OverviewTitle()),
    );

    expect(find.text(testL10n().overview), findsOneWidget);
  });
}
