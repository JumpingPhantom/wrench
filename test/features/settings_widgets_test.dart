import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/features/settings/presentation/widgets/settings_widgets.dart';
import 'package:wrench/l10n/app_localizations.dart';

/// The settings card the tile really sits in: a list padded by 16 either side
/// holding a card padded by another 16, so the segments get the screen width
/// less 64.
Widget _app(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: ThemeData(useMaterial3: true),
    home: Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [Padding(padding: const EdgeInsets.all(16), child: child)],
      ),
    ),
  );
}

void main() {
  group("ThemeTile", () {
    testWidgets("keeps every segment label on one line when narrow", (
      tester,
    ) async {
      // Narrower than any phone the app targets, so a label that can wrap will.
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _app(ThemeTile(currentMode: ThemeMode.system, onChanged: (_) {})),
      );
      await tester.pumpAndSettle();

      final l10n = await AppLocalizations.delegate.load(const Locale("en"));

      // "Dark" is short enough that it can never wrap, which makes its height
      // the yardstick for a single line of this text style.
      final oneLine = tester.getSize(find.text(l10n.dark)).height;
      expect(tester.getSize(find.text(l10n.system)).height, oneLine);
      expect(tester.getSize(find.text(l10n.light)).height, oneLine);
      expect(tester.takeException(), isNull);
    });
  });
}
