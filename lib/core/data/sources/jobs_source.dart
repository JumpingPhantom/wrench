import 'package:wrench/core/data/models/job.dart';

abstract class JobsSource {
  Future<List<Job>> getAllJobs();

  /// Returns the newest jobs first, capped to a handful for overview surfaces.
  Future<List<Job>> getRecentJobs();

  Future<void> saveJob(Job job);

  /// Persists changes to an existing job and returns the stored row.
  ///
  /// The row is returned rather than discarded so callers can refresh a single
  /// entry instead of reloading the whole list after a state transition.
  Future<Job> updateJob(Job job);

  Future<void> deleteJob(Job job);
}
