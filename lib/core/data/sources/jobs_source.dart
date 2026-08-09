import 'package:wrench/core/data/models/job.dart';

abstract class JobsSource {
  Future<List<Job>> getAllJobs();
  Future<void> saveJob(Job job);
  Future<void> deleteJob(Job job);
}
