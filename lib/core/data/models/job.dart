import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wrench/l10n/app_localizations.dart';

part "job.freezed.dart";
part "job.g.dart";

@freezed
sealed class Job with _$Job {
  Job._();

  factory Job({
    @JsonKey(includeIfNull: false) String? id,
    required String title,
    required String description,
    required String location,
    required DateTime createdAt,
    required String createdBy,
    required JobState state,
    String? mediaUrl,
  }) = _Job;

  String get status => switch (state) {
    _Draft() => "Draft",
    _InProgress() => "In Progress",
    _Staged() => "Staged",
    _Finished() => "Finished",
    _Cancelled() => "Cancelled",
  };

  String statusLabel(AppLocalizations l10n) => switch (state) {
    _Draft() => l10n.draft,
    _InProgress() => l10n.inProgress,
    _Staged() => l10n.staged,
    _Finished() => l10n.finished,
    _Cancelled() => l10n.cancelled,
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
