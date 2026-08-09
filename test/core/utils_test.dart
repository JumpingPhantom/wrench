import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/utils.dart';
import 'package:wrench/l10n/app_localizations_en.dart';

void main() {
  final l10n = AppLocalizationsEn();

  Map<String, dynamic> baseRow({
    String id = 'job-1',
    String title = 'Fix leaking pipe',
    String description = 'Replace pipe section',
    String location = 'Zone 4, Building A',
    String createdBy = 'user-1',
    String? mediaUrl,
    Object? createdAt = '2026-08-01T10:00:00.000Z',
    String currentState = 'draft',
    Object? stateData,
  }) {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'created_by': createdBy,
      'media_url': mediaUrl,
      'created_at': createdAt,
      'current_state': currentState,
      'state_data': stateData,
    };
  }

  group('jobFromDB', () {
    test('parses a draft row', () {
      final job = jobFromDB(baseRow());

      expect(job.id, 'job-1');
      expect(job.title, 'Fix leaking pipe');
      expect(job.location, 'Zone 4, Building A');
      expect(job.createdBy, 'user-1');
      expect(job.mediaUrl, isNull);
      expect(job.createdAt, DateTime.parse('2026-08-01T10:00:00.000Z'));
      expect(job.state, const JobState.draft());
    });

    test('parses createdAt from a DateTime value', () {
      final when = DateTime(2026, 8, 2);
      final job = jobFromDB(baseRow(createdAt: when));

      expect(job.createdAt, when);
    });

    test('throws FormatException for an invalid createdAt', () {
      expect(
        () => jobFromDB(baseRow(createdAt: 'not-a-date')),
        throwsFormatException,
      );
    });

    test('parses an in_progress state from a Map state_data', () {
      final job = jobFromDB(
        baseRow(
          currentState: 'in_progress',
          stateData: {
            'started_by': 'user-2',
            'started_at': '2026-08-01T11:00:00.000Z',
            'workers': ['w1', 'w2'],
          },
        ),
      );

      expect(
        job.state,
        JobState.inProgress(
          startedBy: 'user-2',
          startedAt: DateTime.utc(2026, 8, 1, 11),
          workers: ['w1', 'w2'],
        ),
      );
    });

    test('parses an inProgress state from a JSON string state_data', () {
      final job = jobFromDB(
        baseRow(
          currentState: 'inProgress',
          stateData:
              '{"started_by":"user-2","started_at":"2026-08-01T11:00:00.000Z"}',
        ),
      );

      expect(
        job.state,
        JobState.inProgress(
          startedBy: 'user-2',
          startedAt: DateTime.utc(2026, 8, 1, 11),
        ),
      );
    });

    test('parses staged, finished and cancelled states', () {
      final staged = jobFromDB(
        baseRow(
          currentState: 'staged',
          stateData: {'staged_at': '2026-08-01T12:00:00.000Z'},
        ),
      );
      final finished = jobFromDB(
        baseRow(
          currentState: 'finished',
          stateData: {
            'approved_by': 'user-3',
            'finished_at': '2026-08-01T13:00:00.000Z',
          },
        ),
      );
      final cancelled = jobFromDB(
        baseRow(
          currentState: 'cancelled',
          stateData: {
            'reason': 'duplicate',
            'cancelled_at': '2026-08-01T14:00:00.000Z',
            'cancelled_by': 'user-4',
          },
        ),
      );

      expect(
        staged.state,
        JobState.staged(stagedAt: DateTime.utc(2026, 8, 1, 12)),
      );
      expect(
        finished.state,
        JobState.finished(
          approvedBy: 'user-3',
          finishedAt: DateTime.utc(2026, 8, 1, 13),
        ),
      );
      expect(
        cancelled.state,
        JobState.cancelled(
          reason: 'duplicate',
          cancelledAt: DateTime.utc(2026, 8, 1, 14),
          cancelledBy: 'user-4',
        ),
      );
    });

    test('treats null and empty state_data as an empty map', () {
      final nullState = jobFromDB(baseRow(currentState: 'draft'));
      final emptyState = jobFromDB(
        baseRow(currentState: 'draft', stateData: '  '),
      );

      expect(nullState.state, const JobState.draft());
      expect(emptyState.state, const JobState.draft());
    });

    test('throws FormatException for unknown states', () {
      expect(
        () => jobFromDB(baseRow(currentState: 'unknown')),
        throwsFormatException,
      );
    });

    test('throws FormatException for invalid state_data', () {
      expect(
        () => jobFromDB(baseRow(currentState: 'draft', stateData: 'not-json')),
        throwsFormatException,
      );
      expect(
        () => jobFromDB(baseRow(currentState: 'draft', stateData: 42)),
        throwsFormatException,
      );
    });
  });

  group('jobsFromDB', () {
    test('maps every row', () {
      final jobs = jobsFromDB([
        baseRow(id: 'a'),
        baseRow(
          id: 'b',
          currentState: 'finished',
          stateData: {
            'approved_by': 'u',
            'finished_at': '2026-08-01T13:00:00.000Z',
          },
        ),
      ]);

      expect(jobs, hasLength(2));
      expect(jobs[0].id, 'a');
      expect(jobs[1].id, 'b');
      expect(jobs[1].state, isA<JobState>());
    });

    test('returns an empty list for no rows', () {
      expect(jobsFromDB(const []), isEmpty);
    });
  });

  group('DateTimeExt.toRelativeTime', () {
    test('returns justNow for less than a minute', () {
      final when = DateTime.now().subtract(const Duration(seconds: 30));

      expect(when.toRelativeTime(l10n), l10n.justNow);
    });

    test('returns minutes ago', () {
      final when = DateTime.now().subtract(const Duration(minutes: 5));

      expect(when.toRelativeTime(l10n), l10n.minutesAgo(5));
    });

    test('returns hours ago', () {
      final when = DateTime.now().subtract(const Duration(hours: 3));

      expect(when.toRelativeTime(l10n), l10n.hoursAgo(3));
    });

    test('returns days ago', () {
      final when = DateTime.now().subtract(const Duration(days: 2));

      expect(when.toRelativeTime(l10n), l10n.daysAgo(2));
    });

    test('returns weeks ago', () {
      final when = DateTime.now().subtract(const Duration(days: 14));

      expect(when.toRelativeTime(l10n), l10n.weeksAgo(2));
    });

    test('returns months ago', () {
      final when = DateTime.now().subtract(const Duration(days: 60));

      expect(when.toRelativeTime(l10n), l10n.monthsAgo(2));
    });
  });
}
