import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/features/jobs/presentation/widgets/job_filter_bar.dart';
import 'package:wrench/l10n/app_localizations_en.dart';

void main() {
  final l10n = AppLocalizationsEn();

  group('JobFilter.label', () {
    test('maps every filter to its label', () {
      expect(JobFilter.all.label(l10n), 'All');
      expect(JobFilter.pending.label(l10n), 'Pending');
      expect(JobFilter.draft.label(l10n), 'Draft');
      expect(JobFilter.inProgress.label(l10n), 'In Progress');
      expect(JobFilter.staged.label(l10n), 'Staged');
      expect(JobFilter.finished.label(l10n), 'Finished');
      expect(JobFilter.cancelled.label(l10n), 'Cancelled');
    });
  });

  group('JobFilter.statusCode', () {
    test('returns the status code used for filtering', () {
      expect(JobFilter.all.statusCode, isNull);
      expect(JobFilter.pending.statusCode, isNull);
      expect(JobFilter.draft.statusCode, 'Draft');
      expect(JobFilter.inProgress.statusCode, 'In Progress');
      expect(JobFilter.staged.statusCode, 'Staged');
      expect(JobFilter.finished.statusCode, 'Finished');
      expect(JobFilter.cancelled.statusCode, 'Cancelled');
    });
  });
}
