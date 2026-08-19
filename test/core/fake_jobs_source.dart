import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/sources/jobs_source.dart';
import 'package:wrench/core/errors/exceptions.dart';

/// An in-memory [JobsSource] that pages, filters and searches the way the real
/// one is expected to, so a test can drive the notifier without a backend.
///
/// It also records what it was asked for, which is how a test tells a query
/// that reached the source from one the screen quietly answered itself.
class FakeJobsSource implements JobsSource {
  FakeJobsSource(this.jobs);

  List<Job> jobs;

  /// When set, every read throws it instead of answering, which is how a test
  /// drives a screen with the network down. Clearing it and retrying is how it
  /// drives the recovery.
  AppException? readError;

  /// When set, [saveJob] throws it instead of storing, which is how a test
  /// drives the failure a real save can hit (a photo that will not upload, a
  /// table that rejects the row) without a backend to break.
  AppException? saveError;

  /// One entry per page request, in order.
  final List<({int offset, int limit, JobStatus? status, String? search})>
  requests = [];

  int get reads => requests.length;

  @override
  Future<List<Job>> getJobsPage({
    required int offset,
    required int limit,
    JobStatus? status,
    String? search,
  }) async {
    _failIfAsked();
    requests.add((
      offset: offset,
      limit: limit,
      status: status,
      search: search,
    ));

    final term = search?.trim().toLowerCase() ?? "";

    final matching = jobs.where((job) {
      if (status != null && job.status != status) return false;
      if (term.isEmpty) return true;

      return job.title.toLowerCase().contains(term) ||
          job.location.toLowerCase().contains(term);
    }).toList();

    if (offset >= matching.length) return [];

    return matching.sublist(offset, (offset + limit).clamp(0, matching.length));
  }

  @override
  Future<List<Job>> getRecentJobs() async {
    _failIfAsked();
    return jobs.take(4).toList();
  }

  @override
  Future<Job?> getJob(int id) async {
    _failIfAsked();

    for (final job in jobs) {
      if (job.id == id) return job;
    }
    return null;
  }

  @override
  Future<Map<JobStatus, int>> getStatusCounts({String? createdBy}) async {
    _failIfAsked();
    final counts = {for (final status in JobStatus.values) status: 0};

    for (final job in jobs) {
      if (createdBy != null && job.createdBy != createdBy) continue;
      counts[job.status] = counts[job.status]! + 1;
    }

    return counts;
  }

  @override
  Future<void> saveJob(Job job) async {
    final error = saveError;
    if (error != null) throw error;

    jobs = [job, ...jobs];
  }

  @override
  Future<Job> updateJob(Job job) async {
    jobs = [
      for (final existing in jobs)
        if (existing.id == job.id) job else existing,
    ];
    return job;
  }

  @override
  Future<void> deleteJob(Job job) async =>
      jobs = jobs.where((existing) => existing.id != job.id).toList();

  void _failIfAsked() {
    final error = readError;
    if (error != null) throw error;
  }
}
