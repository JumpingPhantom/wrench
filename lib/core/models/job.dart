import 'package:freezed_annotation/freezed_annotation.dart';

part "job.freezed.dart";
part "job.g.dart";

@freezed
sealed class Job with _$Job {
  Job._();

  factory Job({
    required String id,
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
