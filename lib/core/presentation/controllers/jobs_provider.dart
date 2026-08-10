import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/repositories/jobs_repository.dart';
import 'package:wrench/core/data/sources/remote/remote_jobs_source.dart';

final _jobsRepositoryProvider = Provider((ref) {
  return JobsRepository(source: RemoteJobsSource());
});

class JobsNotifier extends AsyncNotifier<List<Job>> {
  late final JobsRepository _jobsRepository;

  @override
  FutureOr<List<Job>> build() {
    _jobsRepository = ref.watch(_jobsRepositoryProvider);
    return _jobsRepository.getAll();
  }

  Future<void> saveJob(Job job) async {
    await _jobsRepository.save(job);
    state = await AsyncValue.guard(() => _jobsRepository.getAll());
  }

  Future<void> delete(Job job) async {
    await _jobsRepository.delete(job);
    state = await AsyncValue.guard(() => _jobsRepository.getAll());
  }
}

final jobsProvider = AsyncNotifierProvider<JobsNotifier, List<Job>>(() {
  return JobsNotifier();
});
