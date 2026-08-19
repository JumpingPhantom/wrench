import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/models/job_change.dart';
import 'package:wrench/core/data/repositories/jobs_repository.dart';
import 'package:wrench/core/data/sources/remote/remote_jobs_source.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/logging/app_logger.dart';
import 'package:wrench/core/presentation/controllers/users_provider.dart';

/// Where every job read and write in the app goes.
///
/// Public so tests can substitute a repository over a fake source: the
/// notifier below is worth exercising for real, and it has no other seam.
final jobsRepositoryProvider = Provider((ref) {
  return JobsRepository(source: RemoteJobsSource());
});

/// Changes to the stored jobs, as they happen.
///
/// One feed for the whole app rather than one per screen: it is a socket, and
/// every view below wants the same events off it. Deliberately not auto-
/// disposed for the same reason — the channel should survive moving between
/// tabs. [AuthNotifier.logout] is what closes it.
final jobChangesProvider = StreamProvider<JobChange>((ref) {
  return ref.watch(jobsRepositoryProvider).watch();
});

/// Refetches this provider whenever the change feed reports anything.
///
/// For the views that are limited or counted at the source: there is nothing in
/// them to patch, since the only way to know the newest four jobs after an
/// insert is to ask for them again.
///
/// Each of them listens for itself rather than being driven from
/// [JobsNotifier], because the overview watches the recent list without ever
/// building the paged one — refreshing these from the jobs list would leave the
/// home screen frozen for anyone who does not open that tab.
extension _RefetchOnChange on Ref {
  void refetchOnJobChange() {
    listen(jobChangesProvider, (_, next) {
      // Only a delivered event counts. An [AsyncError] carries the last value
      // forward with it, and refetching over a feed that has just failed helps
      // nobody.
      if (next case AsyncData()) invalidateSelf();
    });
  }
}

/// What the jobs list is currently asking for.
///
/// Both fields are applied by the database rather than to the loaded pages, so
/// changing either means starting the list again from the first page.
class JobsQuery {
  const JobsQuery({this.status, this.search = ""});

  final JobStatus? status;
  final String search;

  /// Whether [job] belongs in a list narrowed by this query.
  ///
  /// The one place the app evaluates its own query, and it exists for the
  /// change feed alone: a job arriving on it has to be placed without a round
  /// trip to ask the database where it goes. A mirror of what
  /// [RemoteJobsSource.getJobsPage] asks for — `ilike '%term%'` is a
  /// case-insensitive substring match, which is what this is.
  ///
  /// The mirror is not exact. The source blanks the characters `or()` reads as
  /// syntax before the term reaches it, so a search containing one of them is
  /// matched slightly differently here than there. It costs one row sitting in
  /// or out of a filtered list until the next fetch, and the next fetch is what
  /// settles it.
  bool matches(Job job) {
    if (status != null && job.status != status) return false;

    final term = search.trim().toLowerCase();

    if (term.isEmpty) return true;

    return job.title.toLowerCase().contains(term) ||
        job.location.toLowerCase().contains(term);
  }

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
  Future<JobsPage> build() {
    // Listened to rather than watched: a change is reconciled into the pages
    // already loaded, and rebuilding the whole notifier for one row would throw
    // away the scroll position and every page after the first.
    //
    // Registered here, where Riverpod tears it down and sets it up again on
    // each rebuild, so repeated invalidation does not stack up subscriptions.
    ref.listen(jobChangesProvider, (_, next) {
      if (next case AsyncData(:final value)) _reconcile(value);
    });

    return _firstPage(_query);
  }

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

  /// Brings the loaded pages into line with one change from the feed.
  ///
  /// The derived views are left alone here: they refresh themselves off the
  /// same feed, and they have to, since this notifier is not built at all for a
  /// user who never opens the jobs list.
  void _reconcile(JobChange change) {
    final current = state.value;

    if (current == null) {
      // Nothing loaded to reconcile against. A feed that has just come back is
      // still worth acting on though: whatever failed to load may well load now
      // that there is a connection again.
      if (change is JobsDesynced) ref.invalidateSelf();
      return;
    }

    switch (change) {
      case JobUpserted(:final job):
        _upsert(current, job);
      case JobRemoved(:final id):
        state = AsyncData(
          current.copyWith(
            jobs: current.jobs.where((existing) => existing.id != id).toList(),
          ),
        );
      case JobsDesynced():
        unawaited(_resync(current));
    }
  }

  /// Places [job] in the loaded pages, wherever the next fetch would put it.
  void _upsert(JobsPage current, Job job) {
    final index = current.jobs.indexWhere((existing) => existing.id == job.id);

    if (index >= 0) {
      final jobs = [...current.jobs];

      // Its position cannot have moved: the list is ordered by `created_at`
      // and `id`, and an update changes neither. What can change is whether the
      // job still answers the active filter — one that no longer does leaves,
      // rather than sitting in the list wearing a status the filter excludes.
      if (current.query.matches(job)) {
        jobs[index] = job;
      } else {
        jobs.removeAt(index);
      }

      state = AsyncData(current.copyWith(jobs: jobs));
      return;
    }

    if (!current.query.matches(job)) return;

    final at = _insertionPoint(current.jobs, job);

    // A job that sorts past everything loaded belongs on a page nobody has
    // asked for. Appending it would show it directly below a row it may be
    // hundreds of jobs away from, so it is left for `loadMore` to fetch in
    // place.
    if (at == current.jobs.length && current.hasMore) return;

    state = AsyncData(
      current.copyWith(jobs: [...current.jobs]..insert(at, job)),
    );
  }

  /// Fetches the loaded window again, after the feed admits it missed something.
  ///
  /// The window rather than the first page: somebody scrolled a long way down
  /// did not ask to be sent back to the top, and the pages they have open are
  /// exactly the ones that need to be true again.
  Future<void> _resync(JobsPage current) async {
    final query = _query;
    final limit = math.max(pageSize, current.jobs.length);

    try {
      final jobs = await _jobsRepository.getPage(
        offset: 0,
        limit: limit,
        status: query.status,
        search: query.search,
      );

      final latest = state.value;

      // A query set while this was in flight has its own first page coming, and
      // these jobs answer the question it replaced.
      if (latest == null || latest.query != query) return;

      state = AsyncData(
        latest.copyWith(jobs: jobs, hasMore: jobs.length == limit),
      );
    } on AppException catch (e) {
      // Nobody asked for this fetch, so nobody is waiting on it to fail. Jobs
      // that are merely stale beat an error page over jobs that are still on
      // screen and mostly right; the next change, or a pull-to-refresh, retries.
      AppLogger.error("Could not resync the jobs list", e);
    }
  }

  /// Where [job] belongs in a list held newest first.
  int _insertionPoint(List<Job> jobs, Job job) {
    for (var i = 0; i < jobs.length; i++) {
      if (_newestFirst(job, jobs[i]) <= 0) return i;
    }

    return jobs.length;
  }

  /// The order [RemoteJobsSource.getJobsPage] asks the database for: newest
  /// first, with the id breaking ties. Mirrored here so a job placed by the
  /// feed lands where a fetch would have put it.
  int _newestFirst(Job a, Job b) {
    final byTime = b.createdAt.compareTo(a.createdAt);

    return byTime != 0 ? byTime : (b.id ?? 0).compareTo(a.id ?? 0);
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
      // which would otherwise hand back a row the list already holds. The feed
      // narrows this rather than widening it: a job it inserted here is one the
      // database gained too, so the offset above still counts to the same place.
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
    // position of every page after it. Not left to the feed, which would land
    // the same row a round trip later — the user who filed it should see it
    // now, and reconciling it twice puts it in the one place either way.
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

    // Patched here rather than left to the feed for the same reason as above:
    // the move was made on this device, and it should land before the socket
    // gets round to confirming it. The feed's copy arrives at the same row.
    if (current != null) _upsert(current, updated);

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
  ///
  /// Only for this app's own writes. A change that arrived on the feed is
  /// picked up by those views themselves.
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
/// so it stays cheap on accounts with a long history. It is refreshed after
/// every mutation this app makes and after every change the feed reports, which
/// is why no screen has to.
final recentJobsProvider = FutureProvider<List<Job>>((ref) {
  ref.refetchOnJobChange();
  return ref.watch(jobsRepositoryProvider).getRecent();
});

/// How many jobs sit in each status, across the table or one user's jobs.
///
/// Counted at the source rather than over [jobsProvider], whose list holds only
/// the pages loaded so far.
final jobStatusCountsProvider =
    FutureProvider.family<Map<JobStatus, int>, String?>((ref, createdBy) {
      ref.refetchOnJobChange();
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
  // The loaded pages reconcile themselves, and watching them below is enough
  // for a job on one. A job that is on none — the deep-linked one this provider
  // exists for — has nothing watching it, so the feed is followed directly.
  ref.listen(jobChangesProvider, (_, next) {
    if (next case AsyncData(:final value) when _concernsJob(value, id)) {
      ref.invalidateSelf();
    }
  });

  final loaded = ref.watch(jobsProvider).value?.jobs;

  for (final job in loaded ?? const <Job>[]) {
    if (job.id == id) return job;
  }

  return ref.watch(jobsRepositoryProvider).getById(id);
});

/// Whether [change] could have altered the job with [id].
///
/// A gap in the feed counts: it cannot say what it missed, so it has to be
/// treated as possibly having missed this.
bool _concernsJob(JobChange change, int id) => switch (change) {
  JobUpserted(:final job) => job.id == id,
  JobRemoved(id: final removed) => removed == id,
  JobsDesynced() => true,
};
