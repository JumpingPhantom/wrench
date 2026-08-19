import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/core/utils.dart';
import 'package:wrench/l10n/app_localizations.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale("en"));
  });

  /// The label for something that happened [ago] before a fixed now.
  String label(Duration ago) {
    final now = DateTime.utc(2026, 8, 19, 16, 50);
    return now.subtract(ago).toRelativeTime(l10n, now: now);
  }

  group("toRelativeTime", () {
    test("counts in the coarsest unit that still says something", () {
      expect(label(Duration.zero), l10n.justNow);
      expect(label(const Duration(seconds: 59)), l10n.justNow);
      expect(label(const Duration(seconds: 60)), l10n.minutesAgo(1));
      expect(label(const Duration(minutes: 59)), l10n.minutesAgo(59));
      expect(label(const Duration(minutes: 60)), l10n.hoursAgo(1));
      expect(label(const Duration(hours: 23)), l10n.hoursAgo(23));
      expect(label(const Duration(hours: 24)), l10n.daysAgo(1));
      expect(label(const Duration(days: 6)), l10n.daysAgo(6));
      expect(label(const Duration(days: 7)), l10n.weeksAgo(1));
      expect(label(const Duration(days: 29)), l10n.weeksAgo(4));
      expect(label(const Duration(days: 30)), l10n.monthsAgo(1));
      expect(label(const Duration(days: 365)), l10n.monthsAgo(12));
    });

    test("reads a timestamp in the future as just now", () {
      // The symptom of the storage bug: a job recorded three hours ahead of the
      // clock reading it. Every negative difference used to satisfy
      // `inSeconds < 60`, so the label sat on "Just now" for those three hours
      // and then ran three hours behind. Clock skew still lands here — that is
      // the point — but it is now a decision rather than an accident.
      expect(label(const Duration(hours: -3)), l10n.justNow);
      expect(label(const Duration(seconds: -5)), l10n.justNow);
    });

    test("does not care which zone either side is expressed in", () {
      // The case that was broken end to end: a UTC timestamp off the wire
      // against a local clock.
      final utc = DateTime.utc(2026, 8, 19, 14, 50);
      final localNow = utc.add(const Duration(hours: 2)).toLocal();

      expect(utc.toRelativeTime(l10n, now: localNow), l10n.hoursAgo(2));
      expect(
        utc.toLocal().toRelativeTime(l10n, now: localNow),
        l10n.hoursAgo(2),
        reason: "the same instant, whichever zone it is held in",
      );
    });
  });
}
