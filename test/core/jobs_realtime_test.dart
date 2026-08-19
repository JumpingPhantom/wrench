import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/models/job_change.dart';
import 'package:wrench/core/data/repositories/jobs_repository.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/presentation/controllers/jobs_provider.dart';

import 'fake_jobs_source.dart';
import 'job_fixtures.dart';

/// Jobs newest first and a day apart, the order the source hands them back.
///
/// Distinct timestamps rather than the fixture's one: the list is ordered by
/// them, and a test about where a job lands cannot be run over rows that all
/// claim the same instant.
List<Job> _many(int count) => [
  for (var i = 0; i < count; i++)
    jobWith(draft).copyWith(
      id: i,
      title: "job $i",
      location: "zone $i",
      createdAt: DateTime.utc(2026, 1, 1).subtract(Duration(days: i)),
    ),
];

/// A job from outside the loaded list, dated so it sorts where the test needs.
Job _arrival({required int id, required DateTime createdAt, String? title}) =>
    jobWith(draft).copyWith(
      id: id,
      title: title ?? "job $id",
      location: "zone $id",
      createdAt: createdAt,
    );

void main() {
  late FakeJobsSource source;

  ProviderContainer containerFor(List<Job> jobs, {bool retry = true}) {
    source = FakeJobsSource(jobs);
    final container = ProviderContainer(
      // Riverpod retries a failed provider on its own, on a backoff. A test
      // about what the feed recovers has to be the only thing recovering it.
      retry: retry ? null : (_, _) => null,
      overrides: [
        jobsRepositoryProvider.overrideWithValue(
          JobsRepository(source: source),
        ),
      ],
    );
    addTearDown(source.dispose);
    addTearDown(container.dispose);
    return container;
  }

  /// Loads the first page with a listener attached, so the notifier stays alive
  /// and the change feed it subscribes to stays subscribed.
  Future<ProviderContainer> loaded(List<Job> jobs) async {
    final container = containerFor(jobs);
    container.listen(jobsProvider, (_, _) {});
    await container.read(jobsProvider.future);
    return container;
  }

  JobsPage pageOf(ProviderContainer container) =>
      container.read(jobsProvider).requireValue;

  group("upserts", () {
    test("replace a loaded job without moving it", () async {
      final container = await loaded(_many(5));

      final changed = _many(5)[2].copyWith(title: "changed");
      source.emit(JobChange.upserted(changed));
      await pumpEventQueue();

      final page = pageOf(container);

      expect(page.jobs, hasLength(5));
      expect(page.jobs[2].title, "changed", reason: "in place, not reordered");
      expect(page.jobs[1].id, 1);
      expect(page.jobs[3].id, 3);
    });

    test("drop a job that no longer answers the active filter", () async {
      final container = await loaded([
        jobWith(draft).copyWith(id: 1),
        jobWith(staged).copyWith(id: 2),
      ]);

      await container
          .read(jobsProvider.notifier)
          .setQuery(const JobsQuery(status: JobStatus.staged));

      expect(pageOf(container).jobs.single.id, 2);

      // Somebody moved it on, and it is no longer a staged job.
      source.emit(JobChange.upserted(jobWith(inProgress).copyWith(id: 2)));
      await pumpEventQueue();

      expect(pageOf(container).jobs, isEmpty);
    });

    test("land a new job at the top when it is the newest", () async {
      final container = await loaded(_many(5));

      source.emit(
        JobChange.upserted(
          _arrival(
            id: 99,
            createdAt: DateTime.utc(2026, 6, 1),
            title: "just filed",
          ),
        ),
      );
      await pumpEventQueue();

      final page = pageOf(container);

      expect(page.jobs.first.title, "just filed");
      expect(page.jobs, hasLength(6));
    });

    test("land a new job mid-list where it belongs", () async {
      final container = await loaded(_many(5));

      // Between job 1 (Dec 31) and job 2 (Dec 30).
      source.emit(
        JobChange.upserted(
          _arrival(
            id: 99,
            createdAt: DateTime.utc(2025, 12, 30, 12),
            title: "in between",
          ),
        ),
      );
      await pumpEventQueue();

      final titles = pageOf(container).jobs.map((job) => job.title).toList();

      expect(titles[1], "job 1");
      expect(titles[2], "in between");
      expect(titles[3], "job 2");
    });

    test("drop a job that sorts past the loaded window", () async {
      // Two pages in the source, one of them loaded, so there is a page in
      // between this job and the last row on screen.
      final container = await loaded(_many(JobsNotifier.pageSize * 2));

      expect(pageOf(container).hasMore, isTrue);

      source.emit(
        JobChange.upserted(
          _arrival(id: 99, createdAt: DateTime.utc(2020, 1, 1)),
        ),
      );
      await pumpEventQueue();

      final page = pageOf(container);

      expect(page.jobs, hasLength(JobsNotifier.pageSize));
      expect(
        page.jobs.map((job) => job.id),
        isNot(contains(99)),
        reason: "it belongs on a page nobody has loaded",
      );
    });

    test("keep an old job once the whole list is loaded", () async {
      final container = await loaded(_many(3));

      expect(pageOf(container).hasMore, isFalse);

      source.emit(
        JobChange.upserted(
          _arrival(id: 99, createdAt: DateTime.utc(2020, 1, 1)),
        ),
      );
      await pumpEventQueue();

      final page = pageOf(container);

      expect(page.jobs, hasLength(4));
      expect(page.jobs.last.id, 99, reason: "the oldest goes last");
    });
  });

  group("removals", () {
    test("drop the row", () async {
      final container = await loaded(_many(5));

      source.emit(const JobChange.removed(2));
      await pumpEventQueue();

      final ids = pageOf(container).jobs.map((job) => job.id);

      expect(ids, hasLength(4));
      expect(ids, isNot(contains(2)));
    });

    test("for a job on no loaded page change nothing", () async {
      final container = await loaded(_many(JobsNotifier.pageSize * 2));

      source.emit(const JobChange.removed(999));
      await pumpEventQueue();

      expect(pageOf(container).jobs, hasLength(JobsNotifier.pageSize));
    });
  });

  group("desync", () {
    test("refetches the loaded window rather than the first page", () async {
      final container = await loaded(_many(JobsNotifier.pageSize + 5));
      await container.read(jobsProvider.notifier).loadMore();

      expect(pageOf(container).jobs, hasLength(JobsNotifier.pageSize + 5));

      // Whatever happened while the feed was down is only visible by asking.
      source.jobs = [
        for (final job in source.jobs)
          if (job.id == 22) job.copyWith(title: "changed while away") else job,
      ];

      source.emit(const JobChange.desynced());
      await pumpEventQueue();

      final page = pageOf(container);

      expect(
        page.jobs,
        hasLength(JobsNotifier.pageSize + 5),
        reason: "the whole window, not just the first page",
      );
      expect(page.jobs[22].title, "changed while away");
      expect(source.requests.last.offset, 0);
      expect(source.requests.last.limit, JobsNotifier.pageSize + 5);
    });

    test("leaves the jobs on screen when the refetch fails", () async {
      final container = await loaded(_many(5));

      source.readError = NetworkException(message: "down");
      source.emit(const JobChange.desynced());
      await pumpEventQueue();

      // Stale jobs beat an error page over jobs that are still mostly right.
      expect(container.read(jobsProvider).hasError, isFalse);
      expect(pageOf(container).jobs, hasLength(5));
    });

    test("retries a list that never loaded at all", () async {
      final container = containerFor(_many(3), retry: false);
      source.readError = NetworkException(message: "down");
      container.listen(jobsProvider, (_, _) {});

      await expectLater(
        container.read(jobsProvider.future),
        throwsA(isA<NetworkException>()),
      );
      expect(container.read(jobsProvider).hasError, isTrue);

      // The feed coming back is itself evidence of a connection, and there is
      // no page held to reconcile against — so the whole thing is asked for
      // again rather than patched.
      source.readError = null;
      source.emit(const JobChange.desynced());
      await pumpEventQueue();

      expect(pageOf(container).jobs, hasLength(3));
    });
  });

  group("derived views", () {
    test("the recent list refreshes off the feed", () async {
      final container = await loaded(_many(3));
      container.listen(recentJobsProvider, (_, _) {});

      expect(await container.read(recentJobsProvider.future), hasLength(3));

      source.jobs = [
        _arrival(id: 99, createdAt: DateTime.utc(2026, 6, 1), title: "newest"),
        ...source.jobs,
      ];
      source.emit(JobChange.upserted(source.jobs.first));
      await pumpEventQueue();

      final recent = await container.read(recentJobsProvider.future);

      expect(recent.first.title, "newest");
      expect(recent, hasLength(4));
    });

    test("the status totals refresh off the feed", () async {
      final container = await loaded([jobWith(draft).copyWith(id: 1)]);
      container.listen(jobStatusCountsProvider(null), (_, _) {});

      var counts = await container.read(jobStatusCountsProvider(null).future);
      expect(counts[JobStatus.draft], 1);
      expect(counts[JobStatus.staged], 0);

      source.jobs = [jobWith(staged).copyWith(id: 1)];
      source.emit(JobChange.upserted(source.jobs.single));
      await pumpEventQueue();

      counts = await container.read(jobStatusCountsProvider(null).future);

      expect(counts[JobStatus.draft], 0);
      expect(counts[JobStatus.staged], 1);
    });

    test("a job on no loaded page follows the feed", () async {
      final container = await loaded(_many(JobsNotifier.pageSize + 4));

      const id = 22;
      container.listen(jobByIdProvider(id), (_, _) {});

      expect(
        (await container.read(jobByIdProvider(id).future))?.title,
        "job 22",
      );

      source.jobs = [
        for (final job in source.jobs)
          if (job.id == id) job.copyWith(title: "moved on") else job,
      ];

      source.emit(
        JobChange.upserted(source.jobs.firstWhere((job) => job.id == id)),
      );
      await pumpEventQueue();

      expect(
        (await container.read(jobByIdProvider(id).future))?.title,
        "moved on",
      );
    });
  });

  group("a list that is still loading", () {
    test("takes a change without throwing and without inventing one", () async {
      final container = containerFor(_many(3));
      container.listen(jobsProvider, (_, _) {});

      // Read the notifier without awaiting it: the feed is subscribed by then,
      // but there is no page for a change to be reconciled against.
      final pending = container.read(jobsProvider.future);

      source.emit(
        JobChange.upserted(
          _arrival(id: 99, createdAt: DateTime.utc(2026, 6, 1)),
        ),
      );
      await pumpEventQueue();

      final page = await pending;

      expect(page.jobs, hasLength(3));
      expect(page.jobs.map((job) => job.id), isNot(contains(99)));
    });
  });
}
