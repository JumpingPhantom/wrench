import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/errors/exceptions.dart';

/// Where jobs are read from and written to.
///
/// Implementations own the transport, not the rules: they translate their own
/// failures into an [AppException] so callers never have to know whether a job
/// came from the network or a cache.
abstract class JobsSource {
  /// Every job visible to the signed-in user, newest first.
  ///
  /// Throws [NetworkException] if the jobs cannot be read.
  Future<List<Job>> getAllJobs();

  /// The newest jobs, capped to a handful for overview surfaces.
  ///
  /// Separate from [getAllJobs] so the cap can be applied at the source rather
  /// than after transferring a list the caller will discard most of.
  ///
  /// Throws [NetworkException] if the jobs cannot be read.
  Future<List<Job>> getRecentJobs();

  /// Stores [job] as a new entry, uploading its media first if it has any.
  ///
  /// The id is assigned by the store, so the [Job] passed in is expected to
  /// have none and nothing is handed back.
  ///
  /// Throws [OperationException] if the media could not be uploaded, or
  /// [NetworkException] if the job itself could not be stored.
  Future<void> saveJob(Job job);

  /// Persists changes to an existing job and returns the stored row.
  ///
  /// The row is returned rather than discarded so callers can refresh a single
  /// entry instead of reloading the whole list after a state transition.
  ///
  /// Throws [OperationException] if [job] has never been saved, or
  /// [NetworkException] if the update is rejected.
  Future<Job> updateJob(Job job);

  /// Removes [job] from the store.
  ///
  /// Throws [NetworkException] if the deletion is rejected.
  Future<void> deleteJob(Job job);
}
