import 'package:wrench/core/models/in_progress_job_model.dart';
import 'package:wrench/core/models/staged_job_model.dart';
import 'package:wrench/features/jobs/data/sources/in_progress_job_source.dart';
import 'package:wrench/features/jobs/data/sources/staged_job_source.dart';

class StagedJobRepository {
  final StagedJobSource source;
  final InProgressJobSource inProgressSource;

  StagedJobRepository({required this.source, required this.inProgressSource});

  Future<List<StagedJobModel>> getAll() => source.getAllStagedJobs();
  Future<void> delete(StagedJobModel job) => source.deleteStagedJob(job);

  Future<void> stage(InProgressJobModel job, String stagedBy) async {
    final staged = StagedJobModel(
      job: job,
      stagedBy: stagedBy,
      stagedAt: DateTime.now(),
    );
    await source.saveStagedJob(staged);
    await inProgressSource.deleteInProgressJob(job);
  }
}
