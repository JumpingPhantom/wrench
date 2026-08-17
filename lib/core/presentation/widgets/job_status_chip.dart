import 'package:flutter/material.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/presentation/theme/job_status_style.dart';
import 'package:wrench/l10n/app_localizations.dart';

/// The badge that names a job's status, on every surface that shows one.
///
/// Icon and colour come from [JobStatusStyle], so a status reads the same on a
/// list card as it does on the detail header.
class JobStatusChip extends StatelessWidget {
  const JobStatusChip({super.key, required this.status, this.dense = false});

  final JobStatus status;

  /// Trims the padding and drops the icon, for the tight bottom row of a list
  /// card where the label has to share the line with a timestamp.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final style = JobStatusStyle.from(context, status);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: dense
          ? const EdgeInsets.symmetric(horizontal: 8, vertical: 3)
          : const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: style.container,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!dense) ...[
            Icon(style.icon, size: 15, color: style.onContainer),
            const SizedBox(width: 6),
          ],
          Text(
            status.label(l10n),
            style: (dense ? textTheme.labelSmall : textTheme.labelMedium)
                ?.copyWith(
                  color: style.onContainer,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
