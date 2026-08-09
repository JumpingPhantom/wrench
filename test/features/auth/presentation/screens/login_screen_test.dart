import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/features/auth/presentation/screens/login_screen.dart';

import '../../../../helpers/widget_test_utils.dart';

void main() {
  testWidgets('renders the login form', (tester) async {
    final l10n = testL10n();

    await pumpWidgetWithProviders(tester, const LoginScreen());

    expect(find.text(l10n.appTitle), findsOneWidget);
    expect(find.text(l10n.loginSubtitle), findsOneWidget);
    expect(find.text(l10n.email), findsOneWidget);
    expect(find.text(l10n.password), findsOneWidget);
    expect(find.widgetWithText(FilledButton, l10n.login), findsOneWidget);
  });

  testWidgets('shows required-field errors on empty submit', (tester) async {
    final l10n = testL10n();

    await pumpWidgetWithProviders(tester, const LoginScreen());

    await tester.tap(find.widgetWithText(FilledButton, l10n.login));
    await tester.pump();

    expect(find.text(l10n.requiredField), findsNWidgets(2));
  });

  testWidgets('shows an invalid email error for a malformed email', (
    tester,
  ) async {
    final l10n = testL10n();

    await pumpWidgetWithProviders(tester, const LoginScreen());

    await tester.enterText(find.byType(TextFormField).at(0), 'not-an-email');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret');
    await tester.tap(find.widgetWithText(FilledButton, l10n.login));
    await tester.pump();

    expect(find.text(l10n.invalidEmail), findsOneWidget);
  });
}
