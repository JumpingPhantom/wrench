import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/core/data/models/job.dart';

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
}
