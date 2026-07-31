import 'package:flutter/material.dart';
import 'package:wrench/core/models/job.dart';
import 'package:wrench/features/home/presentation/widgets/job_item.dart';

class RecentJobsBody extends StatelessWidget {
  const RecentJobsBody({super.key, required this.jobs});

  final List<Job> jobs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: JobItem(job: job),
        );
      },
    );
  }
}
