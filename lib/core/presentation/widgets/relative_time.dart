import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/presentation/controllers/clock_provider.dart';
import 'package:wrench/core/utils.dart';
import 'package:wrench/l10n/app_localizations.dart';

/// How long ago [timestamp] was, kept true while it is on screen.
///
/// Reads the shared clock rather than calling `DateTime.now()` as it builds, so
/// "Just now" becomes "1m ago" on its own instead of holding whatever it said
/// when the screen was opened.
class RelativeTime extends ConsumerWidget {
  const RelativeTime({
    super.key,
    required this.timestamp,
    this.style,
    this.prefix,
  });

  final DateTime timestamp;
  final TextStyle? style;

  /// Put in front of the time, separated by a middot — "Created · 2h ago".
  final String? prefix;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Before the first tick there is nothing to read but the time right now,
    // which is what the label wants anyway.
    final now = ref.watch(nowProvider).value ?? DateTime.now();
    final relative = timestamp.toRelativeTime(l10n, now: now);
    final prefix = this.prefix;

    return Text(
      prefix == null ? relative : "$prefix · $relative",
      style: style,
    );
  }
}
