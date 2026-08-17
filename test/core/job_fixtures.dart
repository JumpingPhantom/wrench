import 'package:wrench/core/data/models/job.dart';

/// A job that differs from every other fixture only in its state, so a test
/// comparing two of them is comparing the lifecycle and nothing else.
Job jobWith(JobState state) => Job(
  id: 1,
  title: "test",
  description: "test",
  location: "test",
  createdAt: DateTime.utc(2026, 1, 1),
  createdBy: "user-1",
  state: state,
);

const draft = JobState.draft();

final inProgress = JobState.inProgress(
  startedBy: "user-1",
  startedAt: DateTime.utc(2026, 1, 2),
);

final staged = JobState.staged(stagedAt: DateTime.utc(2026, 1, 3));

final finished = JobState.finished(
  approvedBy: "user-2",
  finishedAt: DateTime.utc(2026, 1, 4),
);

final cancelled = JobState.cancelled(
  reason: "duplicate",
  cancelledAt: DateTime.utc(2026, 1, 5),
  cancelledBy: "user-2",
);

/// Every state, in lifecycle order.
List<JobState> get allStates => [
  draft,
  inProgress,
  staged,
  finished,
  cancelled,
];
