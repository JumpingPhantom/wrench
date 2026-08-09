import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/features/home/data/repositories/home_repository.dart';
import 'package:wrench/features/home/data/sources/home_source.dart';

import '../../../../helpers/test_jobs.dart';

class FakeSource implements HomeSource {
  List<Job> jobs = [];

  @override
  Future<List<Job>> getRecentJobs() async => jobs;
}

void main() {
  test('getRecentJobs delegates to the source', () async {
    final jobs = buildJobs();
    final source = FakeSource()..jobs = jobs;
    final repository = HomeRepository(source);

    expect(await repository.getRecentJobs(), jobs);
  });
}
