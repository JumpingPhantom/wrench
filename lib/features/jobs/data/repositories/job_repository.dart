import 'package:wrench/core/models/job_model.dart';
import 'package:wrench/features/jobs/data/sources/job_source.dart';

class JobRepository {
  final JobSource source;

  JobRepository({required this.source});

  Future<List<JobModel>> getAll() => source.getAllJobs();
  Future<void> save(JobModel job) => source.saveJob(job);
  Future<void> delete(JobModel job) => source.deleteJob(job);
}
