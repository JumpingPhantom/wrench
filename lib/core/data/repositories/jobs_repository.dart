import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/sources/jobs_source.dart';

/// The app's entry point for job data.
///
/// Everything that reads or writes a job goes through here, so where jobs live
/// stays a decision of [source] alone. Exceptions from the source are left to
/// propagate: the presentation layer turns them into user-facing copy.
class JobsRepository {
  final JobsSource source;

  JobsRepository({required this.source});

  /// Every job visible to the signed-in user, newest first.
  Future<List<Job>> getAll() => source.getAllJobs();

  /// The newest jobs only, for overview surfaces that show a short list.
  Future<List<Job>> getRecent() => source.getRecentJobs();

  /// Stores [job] as a new entry, media included.
  Future<void> save(Job job) => source.saveJob(job);

  /// Persists changes to an existing [job] and returns the stored row.
  Future<Job> update(Job job) => source.updateJob(job);

  /// Removes [job].
  Future<void> delete(Job job) => source.deleteJob(job);
}
