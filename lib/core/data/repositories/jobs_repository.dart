import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/models/job_change.dart';
import 'package:wrench/core/data/sources/jobs_source.dart';

/// The app's entry point for job data.
///
/// Everything that reads or writes a job goes through here, so where jobs live
/// stays a decision of [source] alone. Exceptions from the source are left to
/// propagate: the presentation layer turns them into user-facing copy.
class JobsRepository {
  final JobsSource source;

  JobsRepository({required this.source});

  /// One page of jobs, newest first, narrowed by [status] and [search] before
  /// it leaves the source. A short page means the end of the list.
  Future<List<Job>> getPage({
    required int offset,
    required int limit,
    JobStatus? status,
    String? search,
  }) => source.getJobsPage(
    offset: offset,
    limit: limit,
    status: status,
    search: search,
  );

  /// The newest jobs only, for overview surfaces that show a short list.
  Future<List<Job>> getRecent() => source.getRecentJobs();

  /// A single job by id, for one that no loaded page holds.
  Future<Job?> getById(int id) => source.getJob(id);

  /// How many jobs sit in each status, across the whole table or just one
  /// user's.
  Future<Map<JobStatus, int>> statusCounts({String? createdBy}) =>
      source.getStatusCounts(createdBy: createdBy);

  /// A feed of changes to the stored jobs, so callers can keep what they have
  /// fetched in step with the source rather than asking again.
  Stream<JobChange> watch() => source.watchJobs();

  /// Stores [job] as a new entry, media included.
  Future<void> save(Job job) => source.saveJob(job);

  /// Persists changes to an existing [job] and returns the stored row.
  Future<Job> update(Job job) => source.updateJob(job);

  /// Removes [job].
  Future<void> delete(Job job) => source.deleteJob(job);
}
