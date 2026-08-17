import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/presentation/controllers/jobs_provider.dart';
import 'package:wrench/core/presentation/widgets/job_status_pill.dart';
import 'package:wrench/l10n/app_localizations.dart';

/// The overview's tally of jobs by status, each one a way into the filtered
/// list behind it.
///
/// The totals come from the source's own count rather than the jobs list, which
/// holds only the pages loaded so far.
class JobsCount extends ConsumerWidget {
  const JobsCount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final counts = ref.watch(jobStatusCountsProvider(null)).value;

    // Holds the row's height while the counts load, so the cards below do not
    // jump up and then back down.
    if (counts == null) return const SizedBox(height: 40);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        spacing: 8,
        children: [
          JobStatusPill(
            status: JobStatus.staged,
            label: l10n.pendingCount(counts[JobStatus.staged] ?? 0),
            onTap: () => context.go('/jobs?filter=${JobStatus.staged.name}'),
          ),
          JobStatusPill(
            status: JobStatus.inProgress,
            label: l10n.inProgressCount(counts[JobStatus.inProgress] ?? 0),
            onTap: () => context.go('/jobs?filter=${JobStatus.inProgress.name}'),
          ),
          JobStatusPill(
            status: JobStatus.finished,
            label: l10n.completedCount(counts[JobStatus.finished] ?? 0),
            onTap: () => context.go('/jobs?filter=${JobStatus.finished.name}'),
          ),
        ],
      ),
    );
  }
}
