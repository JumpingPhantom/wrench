import 'package:wrench/core/models/in_progress_job_model.dart';
import 'package:wrench/core/models/job_model.dart';
import 'package:wrench/features/jobs/data/sources/in_progress_job_source.dart';
import 'package:wrench/features/jobs/data/sources/job_source.dart';

class InProgressJobRepository {
  final InProgressJobSource source;
  final JobSource jobSource;

  InProgressJobRepository({
    required this.source,
    required this.jobSource,
  });

  Future<List<InProgressJobModel>> getAll() => source.getAllInProgressJobs();
  Future<void> delete(InProgressJobModel job) =>
      source.deleteInProgressJob(job);

  Future<void> approve(
    JobModel job,
    String approvedBy,
    List<String> workers,
  ) async {
    final inProgress = InProgressJobModel(
      job: job,
      approvedBy: approvedBy,
      createdAt: DateTime.now(),
      workers: workers,
    );
    await source.saveInProgressJob(inProgress);
    await jobSource.deleteJob(job);
  }
}
