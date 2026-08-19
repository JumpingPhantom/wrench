import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/core/data/models/instant.dart';
import 'package:wrench/core/data/models/job.dart';

import 'job_fixtures.dart';

void main() {
  group("instantToJson", () {
    test("writes a zone, whichever zone the value was in", () {
      // The bug: a local DateTime serialised with no zone at all, which the
      // backend then read in its own timezone.
      final local = DateTime(2026, 8, 19, 19, 50);

      expect(instantToJson(local), endsWith("Z"));
      expect(instantToJson(local.toUtc()), endsWith("Z"));
      expect(
        instantToJson(local),
        instantToJson(local.toUtc()),
        reason: "the same instant, written the same way",
      );
    });
  });

  group("instantFromJson", () {
    final instant = DateTime.utc(2026, 8, 19, 16, 50);

    test("reads a UTC string", () {
      expect(instantFromJson("2026-08-19T16:50:00.000Z"), instant);
    });

    test("reads an offset string as the instant it names", () {
      // Same moment, written from Riyadh. Parsing must not shift it.
      expect(instantFromJson("2026-08-19T19:50:00.000+03:00"), instant);
      expect(instantFromJson("2026-08-19T11:50:00.000-05:00"), instant);
    });

    test("reads a zoneless string as UTC rather than as local time", () {
      // What the jsonb state payload holds. Read as local it would land three
      // hours out on this machine, which is the "created just now, started two
      // hours ago" the detail screen was showing.
      final read = instantFromJson("2026-08-19T16:50:00.000");

      expect(read, instant);
      expect(read.isUtc, isTrue);
    });

    test("reads what the realtime feed sends, not just what REST does", () {
      // A `timestamptz` reaches the change feed as Postgres prints it rather
      // than as PostgREST does: a space for the `T`, and an offset of hours
      // alone. Both are read here for the first time now that jobs arrive over
      // realtime, and both have to name the same instant REST does.
      expect(instantFromJson("2026-08-19 16:50:00+00"), instant);
      expect(instantFromJson("2026-08-19 19:50:00+03"), instant);
      expect(instantFromJson("2026-08-19 11:50:00-05"), instant);
      expect(instantFromJson("2026-08-19 16:50:00.123456+00").isUtc, isTrue);
    });

    test("reads a zoneless time as UTC whichever way it is written", () {
      // A `timestamp` column comes off the feed with the `T` put back and no
      // zone at all, which is this app's own convention: UTC.
      expect(instantFromJson("2026-08-19 16:50:00"), instant);
      expect(instantFromJson("2026-08-19T16:50:00"), instant);
    });

    test("round-trips whatever it wrote", () {
      final now = DateTime.now();

      expect(
        instantFromJson(instantToJson(now)),
        now.toUtc(),
        reason: "a stored instant must come back as the instant stored",
      );
    });
  });

  group("Job", () {
    test("sends created_at with a zone", () {
      final job = jobWith(draft).copyWith(createdAt: DateTime(2026, 8, 19, 19));

      expect(job.toJson()["created_at"], endsWith("Z"));
    });

    test("survives a round trip through the wire format", () {
      final job = jobWith(draft).copyWith(createdAt: DateTime.now());
      final restored = Job.fromJson(job.toJson());

      expect(restored.createdAt.isAtSameMomentAs(job.createdAt), isTrue);
    });

    test("keeps a state timestamp at the same moment", () {
      // The state payload is jsonb, so these go through _JobStateConverter
      // rather than the generated code — the path that used to write a bare
      // local wall clock.
      final startedAt = DateTime.now();
      final job = jobWith(
        JobState.inProgress(startedBy: "user-1", startedAt: startedAt),
      );
      final restored = Job.fromJson(job.toJson());

      expect(restored.stateChangedAt!.isAtSameMomentAs(startedAt), isTrue);
    });

    test("timestamps a transition in UTC", () {
      final started = jobWith(draft).apply(JobAction.start, actorId: "user-1");

      expect(started.stateChangedAt!.isUtc, isTrue);
    });
  });
}
