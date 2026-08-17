import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/errors/exceptions.dart';

/// Where jobs are read from and written to.
///
/// Implementations own the transport, not the rules: they translate their own
/// failures into an [AppException] so callers never have to know whether a job
/// came from the network or a cache.
abstract class JobsSource {
  /// One page of jobs, newest first.
  ///
  /// [status] and [search] narrow the query at the source rather than after it
  /// arrives: a filtered page that was sifted client-side would show a handful
  /// of matches from the first page and hide the rest behind a scroll that
  /// never reaches them.
  ///
  /// A page shorter than [limit] means there is nothing after it.
  ///
  /// Throws [NetworkException] if the page cannot be read.
  Future<List<Job>> getJobsPage({
    required int offset,
    required int limit,
    JobStatus? status,
    String? search,
  });

  /// The newest jobs, capped to a handful for overview surfaces.
  ///
  /// Throws [NetworkException] if the jobs cannot be read.
  Future<List<Job>> getRecentJobs();

  /// A single job by id, or null when no job has that id.
  ///
  /// Needed because a paged list is no longer a complete index: a job opened
  /// from a deep link may sit on a page nobody has loaded.
  ///
  /// Throws [NetworkException] if the lookup fails.
  Future<Job?> getJob(int id);

  /// How many jobs sit in each status, optionally only those [createdBy] one
  /// user.
  ///
  /// Counted at the source so the totals stay whole once the list is paged —
  /// counting loaded pages would report whatever the user had scrolled past.
  ///
  /// Throws [NetworkException] if the counts cannot be read.
  Future<Map<JobStatus, int>> getStatusCounts({String? createdBy});

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
