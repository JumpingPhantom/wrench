import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/presentation/controllers/media_provider.dart';
import 'package:wrench/core/presentation/controllers/users_provider.dart';
import 'package:wrench/core/utils.dart';
import 'package:wrench/l10n/app_localizations.dart';

class JobDetailScreen extends ConsumerWidget {
  const JobDetailScreen({super.key, required this.job});

  final Job job;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final mediaUrl = ref.watch(mediaUrlProvider(job.mediaUrl));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.jobDetails)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (job.mediaUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: mediaUrl.when(
                  data: (data) {
                    if (data != null) {
                      return Image.network(
                        data,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  loading: () => CircularProgressIndicator(),
                  error: (e, st) => const SizedBox.shrink(),
                ),
              ),
            if (job.mediaUrl != null) const SizedBox(height: 16),
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
              label: ref
                  .watch(usersProvider)
                  .when(
                    data: (users) {
                      return users
                          .firstWhere((u) => u.id == job.createdBy)
                          .fullName;
                    },
                    loading: () => "loading",
                    error: (e, st) => "error",
                  ),
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
