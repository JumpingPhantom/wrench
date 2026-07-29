import 'package:flutter/material.dart';
import 'package:wrench/l10n/app_localizations.dart';

class OverviewTitle extends StatelessWidget {
  const OverviewTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        l10n.overview,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
