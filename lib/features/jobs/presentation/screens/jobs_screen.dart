import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/l10n/app_localizations.dart';

class JobsScreen extends ConsumerWidget {
  const JobsScreen({super.key});

  void _openCreateJob(BuildContext context) async {
    //TODO: this should open a bottom sheet with a form to create a job
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateJob(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.createJob),
      ),
    );
  }
}
