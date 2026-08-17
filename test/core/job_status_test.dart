import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/features/jobs/presentation/widgets/job_filter_bar.dart';

Job jobWith(JobState state) => Job(
  id: 1,
  title: "test",
  description: "test",
  location: "test",
  createdAt: DateTime.utc(2026, 1, 1),
  createdBy: "user-1",
  state: state,
);

final draft = const JobState.draft();
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

void main() {
  group("Job.status", () {
    test("maps every state to its status", () {
      expect(jobWith(draft).status, JobStatus.draft);
      expect(jobWith(inProgress).status, JobStatus.inProgress);
      expect(jobWith(staged).status, JobStatus.staged);
      expect(jobWith(finished).status, JobStatus.finished);
      expect(jobWith(cancelled).status, JobStatus.cancelled);
    });
  });

  group("JobFilter.matches", () {
    test("'all' admits every status", () {
      for (final state in [draft, inProgress, staged, finished, cancelled]) {
        expect(JobFilter.all.matches(jobWith(state)), isTrue);
      }
    });

    test("each single-status filter admits only its own status", () {
      const pairs = {
        JobFilter.draft: JobStatus.draft,
        JobFilter.inProgress: JobStatus.inProgress,
        JobFilter.staged: JobStatus.staged,
        JobFilter.finished: JobStatus.finished,
        JobFilter.cancelled: JobStatus.cancelled,
      };

      final jobs = [
        draft,
        inProgress,
        staged,
        finished,
        cancelled,
      ].map(jobWith).toList();

      pairs.forEach((filter, status) {
        final matched = jobs.where(filter.matches).toList();

        expect(matched, hasLength(1), reason: "$filter matched $matched");
        expect(matched.single.status, status);
      });
    });

    test("'pending' means staged and awaiting approval", () {
      expect(JobFilter.pending.matches(jobWith(staged)), isTrue);
      expect(JobFilter.pending.matches(jobWith(draft)), isFalse);
      expect(JobFilter.pending.matches(jobWith(inProgress)), isFalse);
      expect(JobFilter.pending.matches(jobWith(finished)), isFalse);
    });
  });

  group("JobState serialisation", () {
    test("round-trips every state through JSON", () {
      for (final state in [draft, inProgress, staged, finished, cancelled]) {
        final job = jobWith(state);
        expect(Job.fromJson(job.toJson()), job, reason: "$state");
      }
    });

    test("omits a null id so the database can assign one", () {
      final json = jobWith(draft).copyWith(id: null).toJson();

      expect(json.containsKey("id"), isFalse);
    });

    test("rejects an unrecognised status", () {
      final json = jobWith(draft).toJson();
      json["state"] = {"status": "exploded", "payload": <String, dynamic>{}};

      expect(() => Job.fromJson(json), throwsFormatException);
    });
  });
}
