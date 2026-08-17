import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/repositories/jobs_repository.dart';
import 'package:wrench/core/data/sources/remote/remote_jobs_source.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/presentation/controllers/users_provider.dart';

/// Where every job read and write in the app goes.
///
/// Public so tests can substitute a repository over a fake source: the
/// notifier below is worth exercising for real, and it has no other seam.
final jobsRepositoryProvider = Provider((ref) {
  return JobsRepository(source: RemoteJobsSource());
});

/// What the jobs list is currently asking for.
///
/// Both fields are applied by the database rather than to the loaded pages, so
/// changing either means starting the list again from the first page.
class JobsQuery {
  const JobsQuery({this.status, this.search = ""});

  final JobStatus? status;
  final String search;

  @override
  bool operator ==(Object other) =>
      other is JobsQuery && other.status == status && other.search == search;

  @override
  int get hashCode => Object.hash(status, search);
}

/// The slice of the jobs list that has been loaded so far.
class JobsPage {
  const JobsPage({
    required this.jobs,
    required this.hasMore,
    this.loadingMore = false,
    this.reloading = false,
    this.query = const JobsQuery(),
  });

  final List<Job> jobs;

  /// Whether the source might still have jobs after [jobs].
  final bool hasMore;

  /// True while the next page is in flight, so the list can show a footer
  /// instead of the whole screen dropping back to a spinner.
  final bool loadingMore;

  /// True while a new query's first page is in flight. The jobs above are the
  /// previous query's, kept on screen so changing a filter does not blank it.
  final bool reloading;

  final JobsQuery query;

  JobsPage copyWith({
    List<Job>? jobs,
    bool? hasMore,
    bool? loadingMore,
    bool? reloading,
    JobsQuery? query,
  }) => JobsPage(
    jobs: jobs ?? this.jobs,
    hasMore: hasMore ?? this.hasMore,
    loadingMore: loadingMore ?? this.loadingMore,
    reloading: reloading ?? this.reloading,
    query: query ?? this.query,
  );
}

class JobsNotifier extends AsyncNotifier<JobsPage> {
  /// Large enough that the first screenful is rarely the whole page, small
  /// enough that changing a filter is cheap to re-run.
  static const pageSize = 20;

  // Resolved per call rather than cached in a field. Riverpod keeps the same
  // notifier instance across rebuilds, so `build` runs more than once on this
  // object — anything assigned there has to tolerate being assigned again.
  JobsRepository get _jobsRepository => ref.read(jobsRepositoryProvider);

  JobsQuery _query = const JobsQuery();

  @override
  Future<JobsPage> build() => _firstPage(_query);

  Future<JobsPage> _firstPage(JobsQuery query) async {
    final jobs = await _jobsRepository.getPage(
      offset: 0,
      limit: pageSize,
      status: query.status,
      search: query.search,
    );

    return JobsPage(
      jobs: jobs,
      // A full page might still be the last one; the only way to know is to ask
      // for the next and get nothing back. Claiming one more page than there is
      // costs a request, while claiming one fewer hides jobs.
      hasMore: jobs.length == pageSize,
      query: query,
    );
  }

  /// Narrows the list, starting again from the first page.
  ///
  /// The previous list stays on screen while the new one loads, so changing a
  /// filter does not blank the screen in between.
  Future<void> setQuery(JobsQuery query) async {
    if (query == _query) return;

    _query = query;

    final current = state.value;

    if (current != null) {
      state = AsyncData(current.copyWith(reloading: true));
    }

    state = await AsyncValue.guard(() => _firstPage(query));
  }

  /// Appends the next page, if there is one.
  ///
  /// Does nothing while a page is already in flight or once the end has been
  /// reached, so a scroll that keeps firing cannot stack up requests.
  Future<void> loadMore() async {
    final current = state.value;

    if (current == null || !current.hasMore || current.loadingMore) return;

    state = AsyncData(current.copyWith(loadingMore: true));

    try {
      final next = await _jobsRepository.getPage(
        offset: current.jobs.length,
        limit: pageSize,
        status: _query.status,
        search: _query.search,
      );

      // A job saved since the first page shifts every later row down by one,
      // which would otherwise hand back a row the list already holds.
      final seen = current.jobs.map((job) => job.id).toSet();
      final fresh = next.where((job) => !seen.contains(job.id)).toList();

      state = AsyncData(
        current.copyWith(
          jobs: [...current.jobs, ...fresh],
          hasMore: next.length == pageSize,
          loadingMore: false,
        ),
      );
    } catch (_) {
      // The pages already loaded are still good, so the list survives a failed
      // page: hasMore stays true and scrolling again retries.
      state = AsyncData(current.copyWith(loadingMore: false));
      rethrow;
    }
  }

  Future<void> saveJob(Job job) async {
    await _jobsRepository.save(job);
    // Back to the first page: the new job belongs at the top, and it shifts the
    // position of every page after it.
    state = await AsyncValue.guard(() => _firstPage(_query));
    _invalidateDerived();
  }

  /// Advances [job] through [action] and records who did it.
  ///
  /// The actor is read here rather than passed in so no screen can attribute a
  /// transition to anyone but the signed-in user.
  Future<Job> applyAction(Job job, JobAction action, {String? reason}) async {
    final actorId = ref.read(currentUserIdProvider);

    if (actorId == null) {
      throw OperationException(message: "No signed-in user for the transition");
    }

    final updated = await _jobsRepository.update(
      job.apply(action, actorId: actorId, reason: reason),
    );

    final current = state.value;

    if (current != null) {
      // A job that no longer answers the active filter leaves the list rather
      // than sitting in it wearing a status the filter excludes.
      final filteredOut =
          current.query.status != null &&
          current.query.status != updated.status;

      state = AsyncData(
        current.copyWith(
          jobs: [
            for (final existing in current.jobs)
              if (existing.id != updated.id)
                existing
              else if (!filteredOut)
                updated,
          ],
        ),
      );
    }

    _invalidateDerived();

    return updated;
  }

  Future<void> delete(Job job) async {
    await _jobsRepository.delete(job);

    final current = state.value;

    if (current != null) {
      state = AsyncData(
        current.copyWith(
          jobs: current.jobs
              .where((existing) => existing.id != job.id)
              .toList(),
        ),
      );
    }

    _invalidateDerived();
  }

  /// Drops the views computed from the same rows: the overview's recent list
  /// and the status totals behind the home counters, filter chips and profile.
  void _invalidateDerived() {
    ref.invalidate(recentJobsProvider);
    ref.invalidate(jobStatusCountsProvider);
  }
}

final jobsProvider = AsyncNotifierProvider<JobsNotifier, JobsPage>(
  () => JobsNotifier(),
);

/// The newest jobs, for overview surfaces that only show a short list.
///
/// This is a server-side limited query rather than a slice of [jobsProvider],
/// so it stays cheap on accounts with a long history. [JobsNotifier] refreshes
/// it after every mutation, which is why no screen has to.
final recentJobsProvider = FutureProvider<List<Job>>((ref) {
  return ref.watch(jobsRepositoryProvider).getRecent();
});

/// How many jobs sit in each status, across the table or one user's jobs.
///
/// Counted at the source rather than over [jobsProvider], whose list holds only
/// the pages loaded so far.
final jobStatusCountsProvider =
    FutureProvider.family<Map<JobStatus, int>, String?>((ref, createdBy) {
      return ref
          .watch(jobsRepositoryProvider)
          .statusCounts(createdBy: createdBy);
    });

/// A single job: from the loaded pages when it is there, from the source when
/// it is not.
///
/// A paged list is no longer a complete index, so a job opened from a deep link
/// or a restored route may live on a page nobody has scrolled to.
final jobByIdProvider = FutureProvider.family<Job?, int>((ref, id) async {
  final loaded = ref.watch(jobsProvider).value?.jobs;

  for (final job in loaded ?? const <Job>[]) {
    if (job.id == id) return job;
  }

  return ref.watch(jobsRepositoryProvider).getById(id);
});
