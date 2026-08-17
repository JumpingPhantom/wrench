import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wrench/l10n/app_localizations.dart';

part "job.freezed.dart";
part "job.g.dart";

/// Discriminator for [JobState], for code that needs to compare or group jobs
/// without unpacking each state's payload.
enum JobStatus { draft, inProgress, staged, finished, cancelled }

@freezed
sealed class Job with _$Job {
  Job._();

  factory Job({
    @JsonKey(includeIfNull: false) int? id,
    required String title,
    required String description,
    required String location,
    required DateTime createdAt,
    required String createdBy,
    @_JobStateConverter() required JobState state,
    String? mediaUrl,
  }) = _Job;

  /// The current [state] flattened to a value that can be compared and
  /// switched on. Callers filtering or counting jobs use this rather than
  /// [statusLabel], which returns translated text meant only for display.
  JobStatus get status => switch (state) {
    _Draft() => JobStatus.draft,
    _InProgress() => JobStatus.inProgress,
    _Staged() => JobStatus.staged,
    _Finished() => JobStatus.finished,
    _Cancelled() => JobStatus.cancelled,
  };

  String statusLabel(AppLocalizations l10n) => switch (status) {
    JobStatus.draft => l10n.draft,
    JobStatus.inProgress => l10n.inProgress,
    JobStatus.staged => l10n.staged,
    JobStatus.finished => l10n.finished,
    JobStatus.cancelled => l10n.cancelled,
  };

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
}

@freezed
sealed class JobState with _$JobState {
  const factory JobState.draft() = _Draft;

  const factory JobState.inProgress({
    required String startedBy,
    required DateTime startedAt,
    List<String>? workers,
  }) = _InProgress;

  const factory JobState.staged({required DateTime stagedAt}) = _Staged;

  const factory JobState.finished({
    required String approvedBy,
    required DateTime finishedAt,
  }) = _Finished;

  const factory JobState.cancelled({
    required String reason,
    required DateTime cancelledAt,
    required String cancelledBy,
  }) = _Cancelled;

  factory JobState.fromJson(Map<String, dynamic> json) =>
      _$JobStateFromJson(json);
}

class _JobStateConverter
    implements JsonConverter<JobState, Map<String, dynamic>> {
  const _JobStateConverter();

  @override
  JobState fromJson(dynamic json) {
    final status = json['status'] as String?;
    final payload = (json['payload'] as Map<String, dynamic>?) ?? const {};

    return switch (status) {
      'draft' => const JobState.draft(),
      'in_progress' => JobState.inProgress(
        startedBy: payload['started_by'] as String,
        startedAt: DateTime.parse(payload['started_at'] as String),
        workers: (payload['workers'] as List<dynamic>?)?.cast<String>(),
      ),
      'staged' => JobState.staged(
        stagedAt: DateTime.parse(payload['staged_at'] as String),
      ),
      'finished' => JobState.finished(
        approvedBy: payload['approved_by'] as String,
        finishedAt: DateTime.parse(payload['finished_at'] as String),
      ),
      'cancelled' => JobState.cancelled(
        reason: payload['reason'] as String,
        cancelledAt: DateTime.parse(payload['cancelled_at'] as String),
        cancelledBy: payload['cancelled_by'] as String,
      ),
      _ => throw FormatException('Unknown job status: $status'),
    };
  }

  @override
  Map<String, dynamic> toJson(JobState state) {
    final body = switch (state) {
      _Draft() => {'status': 'draft', 'payload': <String, dynamic>{}},
      _InProgress(:final startedBy, :final startedAt, :final workers) => {
        'status': 'in_progress',
        'payload': {
          'started_by': startedBy,
          'started_at': startedAt.toIso8601String(),
          'workers': ?workers,
        },
      },
      _Staged(:final stagedAt) => {
        'status': 'staged',
        'payload': {'staged_at': stagedAt.toIso8601String()},
      },
      _Finished(:final approvedBy, :final finishedAt) => {
        'status': 'finished',
        'payload': {
          'approved_by': approvedBy,
          'finished_at': finishedAt.toIso8601String(),
        },
      },
      _Cancelled(:final reason, :final cancelledAt, :final cancelledBy) => {
        'status': 'cancelled',
        'payload': {
          'reason': reason,
          'cancelled_at': cancelledAt.toIso8601String(),
          'cancelled_by': cancelledBy,
        },
      },
    };

    return body;
  }
}
