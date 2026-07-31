import 'package:flutter/material.dart';
import 'package:wrench/l10n/app_localizations.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(child: Text(l10n.analytics));
  }
}
