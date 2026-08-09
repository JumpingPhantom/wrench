import 'dart:convert';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/l10n/app_localizations.dart';

Job jobFromDB(Map<String, dynamic> row) => Job(
  id: row['id'] as String,
  title: row['title'] as String,
  description: row['description'] as String,
  location: row['location'] as String,
  mediaUrl: row['media_url'] as String?,
  createdBy: row['created_by'] as String,
  createdAt: _timestamp(row['created_at'], 'created_at'),
  state: jobStateFromDB(row['current_state'] as String, row['state_data']),
);

List<Job> jobsFromDB(Iterable<dynamic> rows) => rows
    .map((row) => jobFromDB(Map<String, dynamic>.from(row as Map)))
    .toList();

JobState jobStateFromDB(String currentState, Object? stateData) {
  final data = _stateData(stateData);

  return switch (currentState) {
    'draft' => const JobState.draft(),
    'in_progress' || 'inProgress' => JobState.inProgress(
      startedBy: data['started_by'] as String,
      startedAt: _timestamp(data['started_at'], 'started_at'),
      workers: (data['workers'] as List?)?.map((e) => e as String).toList(),
    ),
    'staged' => JobState.staged(
      stagedAt: _timestamp(data['staged_at'], 'staged_at'),
    ),
    'finished' => JobState.finished(
      approvedBy: data['approved_by'] as String,
      finishedAt: _timestamp(data['finished_at'], 'finished_at'),
    ),
    'cancelled' => JobState.cancelled(
      reason: data['reason'] as String,
      cancelledAt: _timestamp(data['cancelled_at'], 'cancelled_at'),
      cancelledBy: data['cancelled_by'] as String,
    ),
    _ => throw FormatException('Unknown job state: $currentState'),
  };
}

Map<String, dynamic> _stateData(Object? raw) {
  switch (raw) {
    case null:
      return const {};
    case final Map map:
      return Map<String, dynamic>.from(map);
    case final String s when s.trim().isEmpty:
      return const {};
    case final String s:
      final decoded = jsonDecode(s);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
      throw FormatException('state_data is not a JSON object: $s');
    default:
      throw FormatException('Unsupported state_data type: ${raw.runtimeType}');
  }
}

DateTime _timestamp(Object? raw, String field) => switch (raw) {
  final DateTime value => value,
  final String value => DateTime.parse(value),
  _ => throw FormatException('Expected a timestamp for $field, got: $raw'),
};

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
