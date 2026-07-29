import 'package:flutter/material.dart';
import 'package:wrench/l10n/app_localizations.dart';
import 'package:wrench/features/home/presentation/widgets/overview_title.dart';
import 'package:wrench/features/home/presentation/widgets/recent_jobs_body.dart';
import 'package:wrench/features/home/presentation/widgets/recent_jobs_header.dart';
import 'package:wrench/features/home/presentation/widgets/jobs_count.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final List<Map<String, String>> jobs = [
      {
        'title': 'Broken Pipe - Main Line',
        'location': 'Zone 4 • Sector B',
        'status': l10n.proposed,
        'time': '2h ago',
      },
      {
        'title': 'Leaking HVAC - Branc...',
        'location': 'Zone 2 • Roof',
        'status': l10n.inProgress,
        'time': '5h ago',
      },
      {
        'title': 'Electrical Panel Spark',
        'location': 'Zone 1 • Lobby',
        'status': l10n.finished,
        'time': '1d ago',
      },
      {
        'title': 'Conveyor Belt Seized',
        'location': 'Zone 5 • Assembly',
        'status': l10n.proposed,
        'time': 'Just Now',
      },
    ];

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: [
          OverviewTitle(),
          JobsCount(),
          const SizedBox(height: 16.0),
          RecentJobsHeader(),
          const SizedBox(height: 8.0),
          RecentJobsBody(jobs: jobs),
        ],
      ),
    );
  }
}
