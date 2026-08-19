import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/presentation/controllers/jobs_provider.dart';
import 'package:wrench/core/presentation/widgets/empty_state.dart';
import 'package:wrench/features/home/presentation/widgets/overview_title.dart';
import 'package:wrench/features/home/presentation/widgets/recent_jobs_body.dart';
import 'package:wrench/features/home/presentation/widgets/recent_jobs_header.dart';
import 'package:wrench/features/home/presentation/widgets/jobs_count.dart';
import 'package:wrench/l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    AsyncValue<List<Job>> jobs = ref.watch(recentJobsProvider);

    return switch (jobs) {
      // The recent list is the newest few jobs, unfiltered, so an empty one
      // means there are no jobs at all — nothing a tally of zeroes or a link to
      // an empty list would help with. The whole overview stands down and hands
      // the screen to the one move worth making.
      AsyncData(value: final jobs) when jobs.isEmpty => Scaffold(
        body: EmptyState(
          icon: Icons.handyman_outlined,
          title: l10n.noJobsYet,
          message: l10n.noJobsYetHint,
          action: FilledButton.icon(
            onPressed: () => context.push('/jobs/new'),
            icon: const Icon(Icons.add),
            label: Text(l10n.createJobAction),
            style: FilledButton.styleFrom(
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ),
      ),
      AsyncData(:final value) => Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          children: [
            OverviewTitle(),
            JobsCount(),
            const SizedBox(height: 16.0),
            RecentJobsHeader(),
            const SizedBox(height: 8.0),
            RecentJobsBody(jobs: value),
          ],
        ),
      ),
      AsyncError() => Scaffold(
        body: Center(child: Text(l10n.somethingWentWrong)),
      ),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}
