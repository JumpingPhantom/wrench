import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/repositories/jobs_repository.dart';
import 'package:wrench/core/presentation/controllers/jobs_provider.dart';

import 'fake_jobs_source.dart';
import 'job_fixtures.dart';

/// Enough jobs to fill more than one page, all draft unless stated.
List<Job> _many(int count) => [
  for (var i = 0; i < count; i++)
    jobWith(draft).copyWith(id: i, title: "job $i", location: "zone $i"),
];

void main() {
  late FakeJobsSource source;
  late ProviderContainer container;

  ProviderContainer containerFor(List<Job> jobs) {
    source = FakeJobsSource(jobs);
    final container = ProviderContainer(
      overrides: [
        jobsRepositoryProvider.overrideWithValue(
          JobsRepository(source: source),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group("jobsProvider", () {
    test("reloads when invalidated while the screen is watching", () async {
      container = containerFor([jobWith(draft)]);

      // The listener is the point of the test: with one attached the provider
      // stays alive, so invalidating it re-runs build on the same notifier
      // instead of building a fresh one. Anything build() sets up has to
      // survive that, or pull-to-refresh throws instead of refreshing.
      container.listen(jobsProvider, (_, _) {});
      await container.read(jobsProvider.future);

      container.invalidate(jobsProvider);
      final refreshed = await container.read(jobsProvider.future);

      expect(refreshed.jobs, source.jobs);
      expect(source.reads, 2, reason: "the refresh should hit the source");
    });

    test("survives being invalidated repeatedly", () async {
      container = containerFor([jobWith(draft)]);
      container.listen(jobsProvider, (_, _) {});

      for (var i = 0; i < 3; i++) {
        container.invalidate(jobsProvider);
        await container.read(jobsProvider.future);
      }

      expect(source.reads, 4);
    });
  });

  group("paging", () {
    test("first page stops at the page size and expects more", () async {
      container = containerFor(_many(JobsNotifier.pageSize * 2));

      final page = await container.read(jobsProvider.future);

      expect(page.jobs, hasLength(JobsNotifier.pageSize));
      expect(page.hasMore, isTrue);
    });

    test("a short first page is the whole list", () async {
      container = containerFor(_many(3));

      final page = await container.read(jobsProvider.future);

      expect(page.jobs, hasLength(3));
      expect(page.hasMore, isFalse);
    });

    test("loadMore appends the next page", () async {
      container = containerFor(_many(JobsNotifier.pageSize + 5));
      container.listen(jobsProvider, (_, _) {});
      await container.read(jobsProvider.future);

      await container.read(jobsProvider.notifier).loadMore();
      final page = container.read(jobsProvider).requireValue;

      expect(page.jobs, hasLength(JobsNotifier.pageSize + 5));
      expect(page.hasMore, isFalse, reason: "the last page came up short");
      expect(source.requests.last.offset, JobsNotifier.pageSize);
    });

    test("loadMore does nothing once the end is reached", () async {
      container = containerFor(_many(3));
      container.listen(jobsProvider, (_, _) {});
      await container.read(jobsProvider.future);

      await container.read(jobsProvider.notifier).loadMore();

      expect(source.reads, 1, reason: "there was no second page to ask for");
    });

    test("a job already held is not appended twice", () async {
      // A job inserted after the first page shifts everything down by one, so
      // the second page hands back a row the list already has.
      container = containerFor(_many(JobsNotifier.pageSize + 1));
      container.listen(jobsProvider, (_, _) {});
      await container.read(jobsProvider.future);

      source.jobs = [
        jobWith(draft).copyWith(id: 999, title: "jumped the queue"),
        ...source.jobs,
      ];

      await container.read(jobsProvider.notifier).loadMore();
      final ids = container
          .read(jobsProvider)
          .requireValue
          .jobs
          .map((job) => job.id)
          .toList();

      expect(ids.toSet(), hasLength(ids.length), reason: "$ids");
    });
  });

  group("query", () {
    test("filtering starts again from the first page, at the source", () async {
      container = containerFor([
        jobWith(draft).copyWith(id: 1),
        jobWith(staged).copyWith(id: 2),
        jobWith(finished).copyWith(id: 3),
      ]);
      container.listen(jobsProvider, (_, _) {});
      await container.read(jobsProvider.future);

      await container
          .read(jobsProvider.notifier)
          .setQuery(const JobsQuery(status: JobStatus.staged));

      final page = container.read(jobsProvider).requireValue;

      expect(page.jobs.single.id, 2);
      expect(source.requests.last.status, JobStatus.staged);
      expect(source.requests.last.offset, 0);
    });

    test("searching is handed to the source, not applied here", () async {
      container = containerFor(_many(5));
      container.listen(jobsProvider, (_, _) {});
      await container.read(jobsProvider.future);

      await container
          .read(jobsProvider.notifier)
          .setQuery(const JobsQuery(search: "job 3"));

      expect(source.requests.last.search, "job 3");
      expect(
        container.read(jobsProvider).requireValue.jobs.single.title,
        "job 3",
      );
    });

    test("repeating the same query costs nothing", () async {
      container = containerFor(_many(3));
      container.listen(jobsProvider, (_, _) {});
      await container.read(jobsProvider.future);

      await container.read(jobsProvider.notifier).setQuery(const JobsQuery());

      expect(source.reads, 1);
    });
  });

  group("mutations", () {
    test("saving a job reloads from the top", () async {
      container = containerFor(_many(2));
      container.listen(jobsProvider, (_, _) {});
      await container.read(jobsProvider.future);

      await container
          .read(jobsProvider.notifier)
          .saveJob(jobWith(draft).copyWith(id: 7, title: "new one"));

      final page = container.read(jobsProvider).requireValue;

      expect(page.jobs.first.title, "new one");
      expect(page.jobs, hasLength(3));
    });
  });

  group("jobByIdProvider", () {
    test("serves a job the loaded pages already hold", () async {
      container = containerFor(_many(3));
      container.listen(jobsProvider, (_, _) {});
      await container.read(jobsProvider.future);

      final job = await container.read(jobByIdProvider(1).future);

      expect(job?.title, "job 1");
    });

    test("falls back to the source for a job off the loaded pages", () async {
      // Only the first page is loaded, so this id is nowhere in the list.
      container = containerFor(_many(JobsNotifier.pageSize + 4));
      container.listen(jobsProvider, (_, _) {});
      await container.read(jobsProvider.future);

      final id = JobsNotifier.pageSize + 2;
      final job = await container.read(jobByIdProvider(id).future);

      expect(job?.id, id);
    });
  });

  group("jobStatusCountsProvider", () {
    test("counts every status, not just the loaded page", () async {
      container = containerFor([
        ..._many(JobsNotifier.pageSize),
        jobWith(finished).copyWith(id: 900),
        jobWith(cancelled).copyWith(id: 901),
      ]);

      final counts = await container.read(jobStatusCountsProvider(null).future);

      expect(counts[JobStatus.draft], JobsNotifier.pageSize);
      expect(counts[JobStatus.finished], 1);
      expect(counts[JobStatus.cancelled], 1);
    });

    test("narrows to one user's jobs", () async {
      container = containerFor([
        jobWith(draft).copyWith(id: 1, createdBy: "user-1"),
        jobWith(draft).copyWith(id: 2, createdBy: "user-2"),
      ]);

      final counts = await container.read(
        jobStatusCountsProvider("user-1").future,
      );

      expect(counts[JobStatus.draft], 1);
    });
  });
}
