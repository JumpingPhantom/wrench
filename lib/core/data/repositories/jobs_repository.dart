import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/sources/jobs_source.dart';

class JobsRepository {
  final JobsSource source;

  JobsRepository({required this.source});

  Future<List<Job>> getAll() => source.getAllJobs();
  Future<List<Job>> getRecent() => source.getRecentJobs();
  Future<void> save(Job job) => source.saveJob(job);
  Future<Job> update(Job job) => source.updateJob(job);
  Future<void> delete(Job job) => source.deleteJob(job);
}
