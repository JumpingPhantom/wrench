import 'package:wrench/l10n/app_localizations.dart';

extension DateTimeExt on DateTime {
  /// How long ago this was, in the coarsest unit that still says something.
  ///
  /// [now] is injectable so a caller can drive it from a ticking clock, and so
  /// a test can ask about a boundary without waiting for one.
  String toRelativeTime(AppLocalizations l10n, {DateTime? now}) {
    final diff = (now ?? DateTime.now()).difference(this);

    // A timestamp in the future is a clock a little out of step — the phone's
    // against the server's — and the honest answer for a few seconds of skew is
    // "just now". Said out loud rather than left to `inSeconds < 60`, which
    // answered every negative difference the same way and so reported a job
    // stored three hours ahead as having just been filed.
    if (diff.isNegative) return l10n.justNow;

    if (diff.inSeconds < 60) return l10n.justNow;
    if (diff.inMinutes < 60) return l10n.minutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.hoursAgo(diff.inHours);
    if (diff.inDays < 7) return l10n.daysAgo(diff.inDays);
    if (diff.inDays < 30) {
      return l10n.weeksAgo((diff.inDays / 7).floor());
    }
    return l10n.monthsAgo((diff.inDays / 30).floor());
  }
}
