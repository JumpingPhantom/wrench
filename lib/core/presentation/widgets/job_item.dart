import 'package:flutter/material.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/presentation/theme/job_status_style.dart';
import 'package:wrench/core/presentation/widgets/job_image.dart';
import 'package:wrench/core/presentation/widgets/job_status_chip.dart';
import 'package:wrench/core/utils.dart';
import 'package:wrench/l10n/app_localizations.dart';

/// One job in a list, shared by the home overview and the jobs screen.
///
/// The card leads with a status-coloured edge, so a list can be read by colour
/// before any of the text is: the same colour the status chip, the filter chip
/// and the detail header use for that status.
class JobItem extends StatelessWidget {
  const JobItem({super.key, required this.job, this.onTap});

  final Job job;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final style = JobStatusStyle.from(context, job.status);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: colors.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 5, color: style.accent),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      _Thumbnail(path: job.mediaUrl, style: style),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job.title,
                                  style: textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 14,
                                      color: colors.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        job.location,
                                        style: textTheme.bodySmall?.copyWith(
                                          color: colors.onSurfaceVariant,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                JobStatusChip(status: job.status, dense: true),
                                const Spacer(),
                                Text(
                                  job.createdAt.toRelativeTime(l10n),
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The job photo, or a status-tinted stand-in when the job has none.
class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.path, required this.style});

  static const _size = 84.0;

  final String? path;
  final JobStatusStyle style;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: path == null
          // Neutral fill with the status only in the icon's colour. Filling the
          // whole tile instead would put a third copy of the status on one card
          // — after the edge and the chip — and a cancelled job would arrive as
          // a block of red before its title was read.
          ? Container(
              width: _size,
              height: _size,
              color: colors.surfaceContainerHighest,
              child: Icon(
                Icons.handyman_outlined,
                color: style.accent,
                size: 28,
              ),
            )
          : JobImage(path: path, width: _size, height: _size),
    );
  }
}
