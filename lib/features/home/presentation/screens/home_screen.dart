import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/models/job.dart';
import 'package:wrench/features/home/presentation/controllers/home_provider.dart';
import 'package:wrench/features/home/presentation/widgets/overview_title.dart';
import 'package:wrench/features/home/presentation/widgets/recent_jobs_body.dart';
import 'package:wrench/features/home/presentation/widgets/recent_jobs_header.dart';
import 'package:wrench/features/home/presentation/widgets/jobs_count.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Job>> jobs = ref.watch(homeProvider);

    return switch (jobs) {
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
      AsyncError() => const Scaffold(body: Center(child: Text('Error'))),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}
