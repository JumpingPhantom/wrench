import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/features/settings/presentation/screens/main_settings_screen.dart';

import '../../../../helpers/widget_test_utils.dart';

void main() {
  testWidgets('renders appearance, language and about sections', (
    tester,
  ) async {
    final l10n = testL10n();

    await pumpSettingsWidget(tester, const MainSettingsScreen());
    await tester.pump();

    expect(find.text(l10n.appearance), findsOneWidget);
    expect(find.text(l10n.language), findsOneWidget);
    expect(find.text(l10n.about), findsOneWidget);
    expect(find.text('0.1.0'), findsOneWidget);
    expect(find.text(l10n.light), findsOneWidget);
    expect(find.text(l10n.dark), findsOneWidget);
    expect(find.text(l10n.system), findsOneWidget);
  });

  testWidgets('switches the theme mode when a segment is selected', (
    tester,
  ) async {
    final l10n = testL10n();

    await pumpSettingsWidget(tester, const MainSettingsScreen());
    await tester.pump();

    await tester.tap(find.text(l10n.dark));
    await tester.pumpAndSettle();

    final segmented = tester.widget<SegmentedButton<ThemeMode>>(
      find.byType(SegmentedButton<ThemeMode>),
    );
    expect(segmented.selected, {ThemeMode.dark});
  });

  testWidgets('opens the language picker from the language tile', (
    tester,
  ) async {
    final l10n = testL10n();

    await pumpSettingsWidget(tester, const MainSettingsScreen());
    await tester.pump();

    await tester.tap(find.text(l10n.language));
    await tester.pumpAndSettle();

    expect(find.text(l10n.selectLanguage), findsOneWidget);
    expect(find.text('English (English)'), findsOneWidget);
    expect(find.text('Arabic (العربية)'), findsOneWidget);
  });
}
