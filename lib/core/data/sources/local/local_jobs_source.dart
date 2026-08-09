import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/sources/jobs_source.dart';

class LocalJobsSource implements JobsSource {
  @override
  Future<void> deleteJob(Job job) {
    // TODO: implement deleteJob
    throw UnimplementedError();
  }

  @override
  Future<List<Job>> getAllJobs() {
    // TODO: implement getAllJobs
    throw UnimplementedError();
  }

  @override
  Future<void> saveJob(Job job) {
    // TODO: implement saveJob
    throw UnimplementedError();
  }
}
