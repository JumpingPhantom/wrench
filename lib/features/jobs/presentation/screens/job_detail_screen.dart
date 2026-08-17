import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/presentation/controllers/jobs_provider.dart';
import 'package:wrench/core/presentation/controllers/users_provider.dart';
import 'package:wrench/core/presentation/widgets/job_image.dart';
import 'package:wrench/core/utils.dart';
import 'package:wrench/l10n/app_localizations.dart';

/// Resolves which job to show before handing off to [_JobDetailView].
///
/// Navigating from a list passes the job directly, but the route can also be
/// entered without one (a restored route, a deep link), so the id from the path
/// is used to look the job up in the already-loaded list.
class JobDetailScreen extends ConsumerWidget {
  const JobDetailScreen({super.key, required this.jobId, this.job});

  final int? jobId;
  final Job? job;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    if (job != null) return _JobDetailView(job: job!);

    if (jobId == null) return _Message(text: l10n.jobNotFound, l10n: l10n);

    return ref
        .watch(jobsProvider)
        .when(
          data: (jobs) {
            final matches = jobs.where((j) => j.id == jobId);

            return matches.isEmpty
                ? _Message(text: l10n.jobNotFound, l10n: l10n)
                : _JobDetailView(job: matches.first);
          },
          loading: () =>
              _Message(l10n: l10n, child: const CircularProgressIndicator()),
          error: (_, _) => _Message(text: l10n.jobNotFound, l10n: l10n),
        );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.l10n, this.text, this.child});

  final AppLocalizations l10n;
  final String? text;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.jobDetails)),
      body: Center(child: child ?? Text(text!)),
    );
  }
}

class _JobDetailView extends ConsumerWidget {
  const _JobDetailView({required this.job});

  final Job job;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.jobDetails)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (job.mediaUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: JobImage(path: job.mediaUrl, height: 200),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              job.title,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(
                    job.statusLabel(l10n),
                    style: textTheme.labelSmall,
                  ),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(width: 8),
                Text(
                  job.createdAt.toRelativeTime(l10n),
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _DetailRow(icon: Icons.location_on_outlined, label: job.location),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.person_outline,
              label: l10n.createdBy(_creatorName(ref, l10n)),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.description,
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(job.description, style: textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }

  /// The creator's display name, falling back to a placeholder when the
  /// profile is still loading or cannot be resolved at all.
  String _creatorName(WidgetRef ref, AppLocalizations l10n) {
    return ref
        .watch(userByIdProvider(job.createdBy))
        .when(
          data: (user) => user?.fullName ?? l10n.unknownUser,
          loading: () => "…",
          error: (_, _) => l10n.unknownUser,
        );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
