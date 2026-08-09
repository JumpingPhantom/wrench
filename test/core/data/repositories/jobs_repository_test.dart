import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/repositories/jobs_repository.dart';
import 'package:wrench/core/data/sources/jobs_source.dart';

import '../../../helpers/test_jobs.dart';

class FakeJobsSource implements JobsSource {
  final saved = <Job>[];
  final deleted = <Job>[];
  List<Job> jobs = [];

  @override
  Future<List<Job>> getAllJobs() async => jobs;

  @override
  Future<void> saveJob(Job job) async => saved.add(job);

  @override
  Future<void> deleteJob(Job job) async => deleted.add(job);
}

void main() {
  late FakeJobsSource source;
  late JobsRepository repository;

  setUp(() {
    source = FakeJobsSource();
    repository = JobsRepository(source: source);
  });

  test('getAll delegates to the source', () async {
    final jobs = buildJobs();
    source.jobs = jobs;

    expect(await repository.getAll(), jobs);
  });

  test('save delegates to the source', () async {
    final job = buildJob();

    await repository.save(job);

    expect(source.saved, [job]);
  });

  test('delete delegates to the source', () async {
    final job = buildJob();

    await repository.delete(job);

    expect(source.deleted, [job]);
  });
}
