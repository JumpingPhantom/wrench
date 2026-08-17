import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wrench/l10n/app_localizations.dart';

part "job.freezed.dart";
part "job.g.dart";

/// Discriminator for [JobState], for code that needs to compare or group jobs
/// without unpacking each state's payload.
enum JobStatus { draft, inProgress, staged, finished, cancelled }

/// A move from one [JobState] to the next.
///
/// Separate from [JobStatus] because a status says where a job is while an
/// action says how it leaves: [cancel] is reachable from three statuses and
/// lands in one, so the two do not map one to one.
enum JobAction { start, stage, approve, cancel }

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

  String statusLabel(AppLocalizations l10n) => status.label(l10n);

  /// When the job entered its current [state], or null for a draft, which is
  /// where every job starts and so records no move of its own.
  ///
  /// Only the current state carries a timestamp — a job is a state, not an
  /// event log — so this cannot be used to reconstruct earlier steps.
  DateTime? get stateChangedAt => switch (state) {
    _Draft() => null,
    _InProgress(:final startedAt) => startedAt,
    _Staged(:final stagedAt) => stagedAt,
    _Finished(:final finishedAt) => finishedAt,
    _Cancelled(:final cancelledAt) => cancelledAt,
  };

  /// Whoever put the job into its current state, when that state records it.
  ///
  /// Exposed here because the [JobState] variants are private, so no caller
  /// outside this library can destructure them for the id.
  String? get actorId => switch (state) {
    _Draft() || _Staged() => null,
    _InProgress(:final startedBy) => startedBy,
    _Finished(:final approvedBy) => approvedBy,
    _Cancelled(:final cancelledBy) => cancelledBy,
  };

  /// Why the job was cancelled, or null when it was not.
  String? get cancellationReason => switch (state) {
    _Cancelled(:final reason) => reason,
    _ => null,
  };

  /// Transitions legal from the current [status], in the order they should be
  /// offered to a user. Finished and cancelled are terminal, so both yield an
  /// empty set and any screen driven by this shows no actions at all.
  Set<JobAction> get availableActions => switch (status) {
    JobStatus.draft => const {JobAction.start, JobAction.cancel},
    JobStatus.inProgress => const {JobAction.stage, JobAction.cancel},
    JobStatus.staged => const {JobAction.approve, JobAction.cancel},
    JobStatus.finished || JobStatus.cancelled => const {},
  };

  /// A copy of this job advanced by [action].
  ///
  /// [actorId] is recorded as whoever made the move, and [reason] is required
  /// by [JobAction.cancel] alone. An action outside [availableActions] throws
  /// [StateError] rather than producing a job in a state the lifecycle does
  /// not allow — the write is stopped here instead of in the database.
  Job apply(
    JobAction action, {
    required String actorId,
    String? reason,
    DateTime? at,
  }) {
    if (!availableActions.contains(action)) {
      throw StateError("Cannot ${action.name} a job that is ${status.name}");
    }

    if (action == JobAction.cancel && (reason == null || reason.isEmpty)) {
      throw ArgumentError.value(
        reason,
        "reason",
        "Cancelling a job requires a reason",
      );
    }

    final now = at ?? DateTime.now();

    return copyWith(
      state: switch (action) {
        JobAction.start => JobState.inProgress(
          startedBy: actorId,
          startedAt: now,
        ),
        JobAction.stage => JobState.staged(stagedAt: now),
        JobAction.approve => JobState.finished(
          approvedBy: actorId,
          finishedAt: now,
        ),
        JobAction.cancel => JobState.cancelled(
          reason: reason!,
          cancelledAt: now,
          cancelledBy: actorId,
        ),
      },
    );
  }

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
}

extension JobStatusColumn on JobStatus {
  /// The value this status is stored under, in `state->>status`.
  ///
  /// Shared by the converter below and by any query that filters on status, so
  /// the wire format is written down once. Changing one of these renames a
  /// column value and needs a migration, not just an edit here.
  String get storedName => switch (this) {
    JobStatus.draft => "draft",
    JobStatus.inProgress => "in_progress",
    JobStatus.staged => "staged",
    JobStatus.finished => "finished",
    JobStatus.cancelled => "cancelled",
  };

  /// Parses a stored value back, or null if it names no status the app knows.
  static JobStatus? fromStored(String? stored) {
    for (final status in JobStatus.values) {
      if (status.storedName == stored) return status;
    }
    return null;
  }
}

extension JobStatusLabel on JobStatus {
  String label(AppLocalizations l10n) => switch (this) {
    JobStatus.draft => l10n.draft,
    JobStatus.inProgress => l10n.inProgress,
    JobStatus.staged => l10n.staged,
    JobStatus.finished => l10n.finished,
    JobStatus.cancelled => l10n.cancelled,
  };
}

extension JobActionLabel on JobAction {
  String label(AppLocalizations l10n) => switch (this) {
    JobAction.start => l10n.startJob,
    JobAction.stage => l10n.submitForApproval,
    JobAction.approve => l10n.approveJob,
    JobAction.cancel => l10n.cancelJob,
  };

  /// The status a job lands in once this action is applied.
  ///
  /// Kept beside [Job.apply], which is what actually performs the move, so the
  /// two cannot drift: a screen offering an action can name and colour it after
  /// the state it produces without repeating the transition table.
  JobStatus get outcome => switch (this) {
    JobAction.start => JobStatus.inProgress,
    JobAction.stage => JobStatus.staged,
    JobAction.approve => JobStatus.finished,
    JobAction.cancel => JobStatus.cancelled,
  };
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

    return switch (JobStatusColumn.fromStored(status)) {
      JobStatus.draft => const JobState.draft(),
      JobStatus.inProgress => JobState.inProgress(
        startedBy: payload['started_by'] as String,
        startedAt: DateTime.parse(payload['started_at'] as String),
        workers: (payload['workers'] as List<dynamic>?)?.cast<String>(),
      ),
      JobStatus.staged => JobState.staged(
        stagedAt: DateTime.parse(payload['staged_at'] as String),
      ),
      JobStatus.finished => JobState.finished(
        approvedBy: payload['approved_by'] as String,
        finishedAt: DateTime.parse(payload['finished_at'] as String),
      ),
      JobStatus.cancelled => JobState.cancelled(
        reason: payload['reason'] as String,
        cancelledAt: DateTime.parse(payload['cancelled_at'] as String),
        cancelledBy: payload['cancelled_by'] as String,
      ),
      null => throw FormatException('Unknown job status: $status'),
    };
  }

  @override
  Map<String, dynamic> toJson(JobState state) {
    final body = switch (state) {
      _Draft() => {
        'status': JobStatus.draft.storedName,
        'payload': <String, dynamic>{},
      },
      _InProgress(:final startedBy, :final startedAt, :final workers) => {
        'status': JobStatus.inProgress.storedName,
        'payload': {
          'started_by': startedBy,
          'started_at': startedAt.toIso8601String(),
          'workers': ?workers,
        },
      },
      _Staged(:final stagedAt) => {
        'status': JobStatus.staged.storedName,
        'payload': {'staged_at': stagedAt.toIso8601String()},
      },
      _Finished(:final approvedBy, :final finishedAt) => {
        'status': JobStatus.finished.storedName,
        'payload': {
          'approved_by': approvedBy,
          'finished_at': finishedAt.toIso8601String(),
        },
      },
      _Cancelled(:final reason, :final cancelledAt, :final cancelledBy) => {
        'status': JobStatus.cancelled.storedName,
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
