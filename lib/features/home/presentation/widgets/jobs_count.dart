import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/presentation/controllers/jobs_provider.dart';
import 'package:wrench/l10n/app_localizations.dart';

class JobsCount extends ConsumerWidget {
  const JobsCount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return ref
        .watch(jobsProvider)
        .when(
          data: (jobs) {
            final pendingCount = jobs
                .where((j) => j.status == JobStatus.staged)
                .length;
            final inProgressCount = jobs
                .where((j) => j.status == JobStatus.inProgress)
                .length;
            final finishedCount = jobs
                .where((j) => j.status == JobStatus.finished)
                .length;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () => context.go('/jobs?filter=pending'),
                    icon: const Icon(Icons.assignment_outlined),
                    label: Text(l10n.pendingCount(pendingCount)),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => context.go('/jobs?filter=inProgress'),
                    icon: const Icon(Icons.sync),
                    label: Text(l10n.inProgressCount(inProgressCount)),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => context.go('/jobs?filter=finished'),
                    icon: const Icon(Icons.check_circle_outline),
                    label: Text(l10n.completedCount(finishedCount)),
                  ),
                ],
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (error, stack) => const SizedBox.shrink(),
        );
  }
}
