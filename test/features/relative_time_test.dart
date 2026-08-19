import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/core/presentation/controllers/clock_provider.dart';
import 'package:wrench/core/presentation/widgets/relative_time.dart';
import 'package:wrench/l10n/app_localizations.dart';

/// Moves the shared clock and lets the rebuild it causes settle: Riverpod
/// delivers the stream event before the frame that reads it, so one pump is not
/// enough to see the new label.
Future<void> _tick(
  WidgetTester tester,
  StreamController<DateTime> clock,
  DateTime at,
) async {
  clock.add(at);
  await tester.pump();
  await tester.pump();
}

Widget _app(Widget child, {required Stream<DateTime> clock}) {
  return ProviderScope(
    overrides: [nowProvider.overrideWith((ref) => clock)],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group("RelativeTime", () {
    testWidgets("keeps counting while it is on screen", (tester) async {
      final l10n = await AppLocalizations.delegate.load(const Locale("en"));
      final start = DateTime.utc(2026, 8, 19, 16, 50);
      final clock = StreamController<DateTime>();
      addTearDown(clock.close);

      await tester.pumpWidget(
        _app(RelativeTime(timestamp: start), clock: clock.stream),
      );
      // Nothing has ticked yet, so the label is whatever the real clock says
      // about a timestamp far in the past — it just must not be empty.
      await tester.pump();

      await _tick(tester, clock, start);
      expect(find.text(l10n.justNow), findsOneWidget);

      // A minute passes with nothing else in the app changing: the label used
      // to hold whatever it said when the screen was built.
      await _tick(tester, clock, start.add(const Duration(minutes: 1)));

      expect(find.text(l10n.justNow), findsNothing);
      expect(find.text(l10n.minutesAgo(1)), findsOneWidget);

      await _tick(tester, clock, start.add(const Duration(hours: 2)));

      expect(find.text(l10n.hoursAgo(2)), findsOneWidget);
    });

    testWidgets("puts a prefix in front of the time", (tester) async {
      final l10n = await AppLocalizations.delegate.load(const Locale("en"));
      final start = DateTime.utc(2026, 8, 19, 16, 50);
      final clock = StreamController<DateTime>();
      addTearDown(clock.close);

      await tester.pumpWidget(
        _app(
          RelativeTime(timestamp: start, prefix: l10n.created),
          clock: clock.stream,
        ),
      );

      await _tick(tester, clock, start.add(const Duration(hours: 3)));

      expect(
        find.text("${l10n.created} · ${l10n.hoursAgo(3)}"),
        findsOneWidget,
      );
    });
  });
}
