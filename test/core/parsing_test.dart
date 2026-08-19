import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/models/user.dart';
import 'package:wrench/core/data/parsing.dart';
import 'package:wrench/core/errors/exceptions.dart';

/// A row shaped the way the app expects `profiles` to be.
Map<String, dynamic> profileRow({
  String id = "user-1",
  String? fullName = "Amina Yusuf",
  String role = "worker",
}) {
  return {
    "id": id,
    "full_name": fullName,
    "role": role,
    "avatar_url": null,
    "created_at": "2026-01-01T00:00:00.000Z",
    "updated_at": "2026-01-02T00:00:00.000Z",
  };
}

/// A row shaped the way the app expects `jobs` to be.
///
/// Only draft states are built here: every other state carries a payload of its
/// own, which is a different parsing concern from the one under test.
Map<String, dynamic> jobRow({int id = 1, String status = "draft"}) {
  return {
    "id": id,
    "title": "Fix the pump",
    "description": "Leaking at the seal",
    "location": "Zone 4",
    "created_at": "2026-01-01T00:00:00.000Z",
    "created_by": "user-1",
    "state": {"status": status, "payload": <String, dynamic>{}},
    "media_url": null,
  };
}

void main() {
  group("parseRows", () {
    test("reads the rows it understands", () {
      final users = parseRows("profiles", [
        profileRow(id: "user-1"),
        profileRow(id: "user-2", fullName: "Omar Said", role: "supervisor"),
      ], User.fromJson);

      expect(users, hasLength(2));
      expect(users.first.fullName, "Amina Yusuf");
      expect(users.last.role, UserRole.supervisor);
    });

    test("keeps the good rows when one is unreadable", () {
      // The whole point: one broken record used to cost every name in the app,
      // because a single map().toList() threw on the first row it hit.
      final users = parseRows("profiles", [
        profileRow(id: "user-1"),
        profileRow(id: "broken", fullName: null),
        profileRow(id: "user-3", fullName: "Omar Said"),
      ], User.fromJson);

      expect(users.map((user) => user.id), ["user-1", "user-3"]);
    });

    test("treats a value outside its enum as unreadable", () {
      // The row that started this: a profile added by hand with a role the app
      // has never heard of. `$enumDecode` raises an ArgumentError, which is an
      // Error rather than an Exception and so passed every catch in the app.
      final users = parseRows("profiles", [
        profileRow(id: "odd", role: "subordinate"),
        profileRow(id: "ok"),
      ], User.fromJson);

      expect(users.single.id, "ok");
    });

    test("treats a column the model requires as unreadable", () {
      final missingUpdatedAt = profileRow()..remove("updated_at");

      expect(
        parseRows("profiles", [
          missingUpdatedAt,
          profileRow(id: "ok"),
        ], User.fromJson),
        [isA<User>().having((user) => user.id, "id", "ok")],
      );
    });

    test("raises when no row at all can be read", () {
      // Every row failing is a schema that has drifted, not one bad record.
      // Returned as an empty list it would read as "unknown" everywhere and
      // explain nothing.
      expect(
        () => parseRows("profiles", [
          profileRow(id: "a", fullName: null),
          profileRow(id: "b", fullName: null),
        ], User.fromJson),
        throwsA(
          isA<ParsingException>()
              .having((e) => e.source, "source", "profiles")
              .having((e) => e.cause, "cause", isNotNull),
        ),
      );
    });

    test("accepts an empty table without raising", () {
      // Nothing readable because there is nothing there — row-level security
      // hiding every row looks like this, and it is not a parse failure.
      expect(parseRows("profiles", const [], User.fromJson), isEmpty);
    });

    test("guards the jobs table the same way", () {
      final jobs = parseRows("jobs", [
        jobRow(id: 1),
        jobRow(id: 2, status: "on_hold"),
        jobRow(id: 3),
      ], Job.fromJson);

      expect(jobs.map((job) => job.id), [1, 3]);
    });
  });

  group("parsePayload", () {
    test("returns what the parser read", () {
      expect(parsePayload("jobs", () => Job.fromJson(jobRow())).id, 1);
    });

    test("reports a parser failure as a ParsingException", () {
      expect(
        () =>
            parsePayload("jobs", () => Job.fromJson(jobRow()..remove("title"))),
        throwsA(
          isA<ParsingException>()
              .having((e) => e.source, "source", "jobs")
              .having((e) => e.cause, "cause", isA<TypeError>()),
        ),
      );
    });

    test("says what it could not read", () {
      try {
        parsePayload("profiles", () => User.fromJson(profileRow(role: "boss")));
        fail("expected a ParsingException");
      } on ParsingException catch (e) {
        expect(e.toString(), contains("profiles"));
        expect(e.toString(), contains("boss"));
      }
    });

    test("leaves an AppException alone", () {
      // Already says what it means; wrapping it would bury the reason.
      expect(
        () => parsePayload(
          "jobs",
          () => throw NetworkException(message: "no route to host"),
        ),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
