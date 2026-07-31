import 'package:wrench/core/models/job.dart';

abstract class Source {
  Future<List<Job>> getAllJobs();
  Future<void> saveJob(Job job);
  Future<void> deleteJob(Job job);
}
