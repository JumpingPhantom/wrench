import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/l10n/app_localizations_en.dart';

import '../../../helpers/test_jobs.dart';

void main() {
  group('Job.status', () {
    test('maps each state to its display status', () {
      final l10n = AppLocalizationsEn();

      expect(buildJob(state: const JobState.draft()).status, 'Draft');
      expect(
        buildJob(
          state: JobState.inProgress(
            startedBy: 'u1',
            startedAt: DateTime(2026),
          ),
        ).status,
        'In Progress',
      );
      expect(
        buildJob(state: JobState.staged(stagedAt: DateTime(2026))).status,
        'Staged',
      );
      expect(
        buildJob(
          state: JobState.finished(
            approvedBy: 'u1',
            finishedAt: DateTime(2026),
          ),
        ).status,
        'Finished',
      );
      expect(
        buildJob(
          state: JobState.cancelled(
            reason: 'duplicate',
            cancelledAt: DateTime(2026),
            cancelledBy: 'u1',
          ),
        ).status,
        'Cancelled',
      );

      expect(
        buildJob(state: const JobState.draft()).statusLabel(l10n),
        'Draft',
      );
    });
  });

  group('Job JSON round-trip', () {
    Map<String, dynamic> toJsonMap(Job job) {
      final json = job.toJson();
      json['state'] = job.state.toJson();
      return json;
    }

    test('preserves all fields for a draft job', () {
      final job = buildJob(
        state: const JobState.draft(),
        mediaUrl: 'https://example.com/photo.jpg',
      );

      final decoded = Job.fromJson(toJsonMap(job));

      expect(decoded, job);
    });

    test('preserves an in-progress state with workers', () {
      final job = buildJob(
        state: JobState.inProgress(
          startedBy: 'u2',
          startedAt: DateTime(2026, 8, 2, 9, 30),
          workers: const ['w1', 'w2'],
        ),
      );

      expect(Job.fromJson(toJsonMap(job)), job);
    });

    test('preserves staged, finished and cancelled states', () {
      final staged = buildJob(
        state: JobState.staged(stagedAt: DateTime(2026, 8, 2)),
      );
      final finished = buildJob(
        state: JobState.finished(
          approvedBy: 'u3',
          finishedAt: DateTime(2026, 8, 3),
        ),
      );
      final cancelled = buildJob(
        state: JobState.cancelled(
          reason: 'no longer needed',
          cancelledAt: DateTime(2026, 8, 4),
          cancelledBy: 'u4',
        ),
      );

      expect(Job.fromJson(toJsonMap(staged)), staged);
      expect(Job.fromJson(toJsonMap(finished)), finished);
      expect(Job.fromJson(toJsonMap(cancelled)), cancelled);
    });

    test('mediaUrl defaults to null when absent', () {
      final json = toJsonMap(buildJob())..remove('mediaUrl');

      final decoded = Job.fromJson(json);

      expect(decoded.mediaUrl, isNull);
    });
  });

  group('Job.copyWith', () {
    test('overrides only the provided fields', () {
      final job = buildJob();

      final updated = job.copyWith(title: 'New title', mediaUrl: 'x');

      expect(updated.id, job.id);
      expect(updated.title, 'New title');
      expect(updated.mediaUrl, 'x');
    });
  });
}
