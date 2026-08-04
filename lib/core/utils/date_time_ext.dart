import 'package:wrench/l10n/app_localizations.dart';

extension DateTimeExt on DateTime {
  String toRelativeTime(AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = now.difference(this);

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
