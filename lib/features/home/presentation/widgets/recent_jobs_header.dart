import 'package:flutter/material.dart';
import 'package:wrench/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class RecentJobsHeader extends StatelessWidget {
  const RecentJobsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.recentJobs,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              context.go('/jobs');
            },
            child: Text(l10n.viewAll),
          ),
        ],
      ),
    );
  }
}
