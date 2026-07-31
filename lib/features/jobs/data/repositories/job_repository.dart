import 'package:wrench/core/models/job.dart';
import 'package:wrench/features/jobs/data/sources/source.dart';

class JobRepository {
  final Source _source;

  JobRepository({required Source source}) : _source = source;

  Future<List<Job>> getAll() => _source.getAllJobs();
  Future<void> save(Job job) => _source.saveJob(job);
  Future<void> delete(Job job) => _source.deleteJob(job);
}
