import 'package:wrench/core/models/finished_job_model.dart';
import 'package:wrench/core/models/staged_job_model.dart';
import 'package:wrench/features/jobs/data/sources/finished_job_source.dart';
import 'package:wrench/features/jobs/data/sources/staged_job_source.dart';

class FinishedJobRepository {
  final FinishedJobSource source;
  final StagedJobSource stagedSource;

  FinishedJobRepository({required this.source, required this.stagedSource});

  Future<List<FinishedJobModel>> getAll() => source.getAllFinishedJobs();
  Future<void> delete(FinishedJobModel job) => source.deleteFinishedJob(job);

  Future<void> finish(
    StagedJobModel job,
    String finishedBy,
    String reviewer,
    String comments,
  ) async {
    final finished = FinishedJobModel(
      job: job,
      finishedAt: DateTime.now(),
      finishedBy: finishedBy,
      reviewer: reviewer,
      comments: comments,
    );
    await source.saveFinishedJob(finished);
    await stagedSource.deleteStagedJob(job);
  }
}
