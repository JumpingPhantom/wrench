import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/utils.dart';
import 'package:wrench/l10n/app_localizations.dart';

class JobItem extends StatelessWidget {
  const JobItem({super.key, required this.job, this.onTap});

  final Job job;
  final VoidCallback? onTap;

  Widget _placeholderImage(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Icon(Icons.image),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: InkWell(
          onTap: onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 4.0,
                color: Theme.of(context).colorScheme.primary,
              ),
              CachedNetworkImage(
                imageUrl: job.mediaUrl ?? "",
                width: 100.0,
                height: 100.0,
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    _placeholderImage(context),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14.0,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4.0),
                              Expanded(
                                child: Text(
                                  job.location,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Chip(
                            label: Text(
                              job.statusLabel(l10n),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          Text(
                            job.createdAt.toRelativeTime(l10n),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
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
