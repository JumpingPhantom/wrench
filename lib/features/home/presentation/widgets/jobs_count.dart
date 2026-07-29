import 'package:flutter/material.dart';
import 'package:wrench/l10n/app_localizations.dart';

class JobsCount extends StatelessWidget {
  const JobsCount({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.assignment_outlined),
            label: Text(l10n.pendingCount(3)),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.sync),
            label: Text(l10n.inProgressCount(2)),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.check_circle_outline),
            label: Text(l10n.completedCount(5)),
          ),
        ],
      ),
    );
  }
}
