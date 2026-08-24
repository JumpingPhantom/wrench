import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/core/data/models/app_notification.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/parsing.dart';

void main() {
  test("parse job model correctly", () {
    final String json =
        '{"id":2,"title":"test","description":"test","media_url":"images/test_image.png","location":"test","created_at":"2026-08-13 03:28:47.125944+00","created_by":"bbc82789-f7c9-4125-af10-4faa8bbe75aa","state":{"status": "draft", "payload": {}}}';

    Job matcher = Job(
      id: 2,
      title: "test",
      description: "test",
      mediaUrl: "images/test_image.png",
      location: "test",
      createdAt: DateTime.parse("2026-08-13 03:28:47.125944+00"),
      createdBy: "bbc82789-f7c9-4125-af10-4faa8bbe75aa",
      state: JobState.draft(),
    );

    Job job = Job.fromJson(jsonDecode(json));

    expect(job, matcher);
  });

  group("AppNotification", () {
    Map<String, dynamic> row({
      String kind = "job_created",
      String? readAt,
    }) => jsonDecode(
      '{"id":7,"recipient_id":"supervisor-1","actor_id":"worker-1",'
      '"job_id":42,"kind":"$kind","created_at":"2026-08-13T03:28:47.125944Z",'
      '"read_at":${readAt == null ? "null" : '"$readAt"'}}',
    );

    test("reads a row the trigger wrote", () {
      expect(
        AppNotification.fromJson(row()),
        AppNotification(
          id: 7,
          recipientId: "supervisor-1",
          actorId: "worker-1",
          jobId: 42,
          kind: NotificationKind.jobCreated,
          createdAt: DateTime.utc(2026, 8, 13, 3, 28, 47, 125, 944),
        ),
      );
    });

    test("maps every kind the table can hold", () {
      expect(
        AppNotification.fromJson(row(kind: "job_created")).kind,
        NotificationKind.jobCreated,
      );
      expect(
        AppNotification.fromJson(row(kind: "job_submitted")).kind,
        NotificationKind.jobSubmitted,
      );
    });

    test("a null read_at is what unread means", () {
      expect(AppNotification.fromJson(row()).isRead, isFalse);
      expect(
        AppNotification.fromJson(row(readAt: "2026-08-14T09:00:00Z")).isRead,
        isTrue,
      );
    });

    test("a timestamp carrying no zone is read as UTC, not local time", () {
      final parsed = AppNotification.fromJson(
        jsonDecode(
          '{"id":7,"recipient_id":"s","actor_id":null,"job_id":42,'
          '"kind":"job_created","created_at":"2026-08-13 03:28:47.125944",'
          '"read_at":null}',
        ),
      );

      expect(parsed.createdAt.isUtc, isTrue);
      expect(parsed.createdAt.hour, 3);
    });

    test("a kind the app does not know costs one row, not the list", () {
      final rows = [
        row(),
        jsonDecode(
              '{"id":8,"recipient_id":"s","actor_id":null,"job_id":43,'
              '"kind":"job_incinerated","created_at":"2026-08-13T03:28:47Z",'
              '"read_at":null}',
            )
            as Map<String, dynamic>,
      ];

      expect(
        parseRows("notifications", rows, AppNotification.fromJson),
        hasLength(1),
      );
    });
  });
}
