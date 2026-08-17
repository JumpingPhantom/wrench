import 'package:flutter/material.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/presentation/theme/job_status_style.dart';

/// A tally wearing its status's colour and icon — "3 Pending", "5 Finished".
///
/// Used by the overview counters and the profile's own totals, so a number
/// about a status is recognisable as that status wherever it turns up.
class JobStatusPill extends StatelessWidget {
  const JobStatusPill({
    super.key,
    required this.status,
    required this.label,
    this.onTap,
  });

  final JobStatus status;

  /// The whole phrase, count included: which side the number sits on is a
  /// question for the translation, not for this widget.
  final String label;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final style = JobStatusStyle.from(context, status);

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 16, color: style.onContainer),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: style.onContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    return Material(
      color: style.container,
      borderRadius: BorderRadius.circular(999),
      clipBehavior: Clip.antiAlias,
      child: onTap == null
          ? content
          : InkWell(onTap: onTap, child: content),
    );
  }
}
