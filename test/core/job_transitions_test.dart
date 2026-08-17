import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/core/data/models/job.dart';

import 'job_fixtures.dart';

const actor = "user-9";
final at = DateTime.utc(2026, 6, 1, 12);

void main() {
  group("Job.availableActions", () {
    test("offers the lifecycle's next step and cancel", () {
      expect(jobWith(draft).availableActions, {
        JobAction.start,
        JobAction.cancel,
      });
      expect(jobWith(inProgress).availableActions, {
        JobAction.stage,
        JobAction.cancel,
      });
      expect(jobWith(staged).availableActions, {
        JobAction.approve,
        JobAction.cancel,
      });
    });

    test("offers nothing once the job is terminal", () {
      expect(jobWith(finished).availableActions, isEmpty);
      expect(jobWith(cancelled).availableActions, isEmpty);
    });
  });

  group("Job.apply", () {
    test("walks draft to finished one step at a time", () {
      final started = jobWith(
        draft,
      ).apply(JobAction.start, actorId: actor, at: at);
      expect(started.status, JobStatus.inProgress);
      expect(started.actorId, actor);

      final stagedJob = started.apply(JobAction.stage, actorId: actor, at: at);
      expect(stagedJob.status, JobStatus.staged);

      final approved = stagedJob.apply(
        JobAction.approve,
        actorId: "user-2",
        at: at,
      );
      expect(approved.status, JobStatus.finished);
      expect(approved.actorId, "user-2");
    });

    test("records who cancelled and why", () {
      final job = jobWith(inProgress).apply(
        JobAction.cancel,
        actorId: actor,
        reason: "access denied",
        at: at,
      );

      expect(job.status, JobStatus.cancelled);
      expect(job.actorId, actor);
      expect(job.cancellationReason, "access denied");
    });

    test("rejects a transition the current state does not allow", () {
      expect(
        () => jobWith(staged).apply(JobAction.start, actorId: actor),
        throwsStateError,
      );
      expect(
        () => jobWith(finished).apply(JobAction.approve, actorId: actor),
        throwsStateError,
      );
      expect(
        () => jobWith(
          cancelled,
        ).apply(JobAction.cancel, actorId: actor, reason: "again"),
        throwsStateError,
      );
    });

    test("refuses to cancel without a reason", () {
      expect(
        () => jobWith(draft).apply(JobAction.cancel, actorId: actor),
        throwsArgumentError,
      );
      expect(
        () =>
            jobWith(draft).apply(JobAction.cancel, actorId: actor, reason: ""),
        throwsArgumentError,
      );
    });

    test("leaves every field but state untouched", () {
      final before = jobWith(draft);
      final after = before.apply(JobAction.start, actorId: actor, at: at);

      expect(after, before.copyWith(state: after.state));
    });

    test("survives a round trip through JSON", () {
      final job = jobWith(draft)
          .apply(JobAction.start, actorId: actor, at: at)
          .apply(JobAction.stage, actorId: actor, at: at);

      expect(Job.fromJson(job.toJson()), job);
    });
  });

  group("state accessors", () {
    test("actorId is null for states that record no actor", () {
      expect(jobWith(draft).actorId, isNull);
      expect(jobWith(staged).actorId, isNull);
      expect(jobWith(finished).actorId, "user-2");
    });

    test("cancellationReason is null unless the job was cancelled", () {
      expect(jobWith(draft).cancellationReason, isNull);
      expect(jobWith(finished).cancellationReason, isNull);
      expect(jobWith(cancelled).cancellationReason, "duplicate");
    });
  });
}
