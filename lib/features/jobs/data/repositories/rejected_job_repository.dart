import 'package:wrench/core/models/job_model.dart';
import 'package:wrench/core/models/rejected_job_model.dart';
import 'package:wrench/features/jobs/data/sources/job_source.dart';
import 'package:wrench/features/jobs/data/sources/rejected_job_source.dart';

class RejectedJobRepository {
  final RejectedJobSource source;
  final JobSource jobSource;

  RejectedJobRepository({required this.source, required this.jobSource});

  Future<List<RejectedJobModel>> getAll() => source.getAllRejectedJobs();
  Future<void> delete(RejectedJobModel job) => source.deleteRejectedJob(job);

  Future<void> reject(
    JobModel job,
    String rejectedBy,
    String reason,
  ) async {
    final rejected = RejectedJobModel(
      job: job,
      rejectedBy: rejectedBy,
      rejectedAt: DateTime.now(),
      reason: reason,
    );
    await source.saveRejectedJob(rejected);
    await jobSource.deleteJob(job);
  }
}
