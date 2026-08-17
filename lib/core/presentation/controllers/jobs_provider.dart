import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/repositories/jobs_repository.dart';
import 'package:wrench/core/data/sources/remote/remote_jobs_source.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/presentation/controllers/users_provider.dart';

final _jobsRepositoryProvider = Provider((ref) {
  return JobsRepository(source: RemoteJobsSource());
});

class JobsNotifier extends AsyncNotifier<List<Job>> {
  late final JobsRepository _jobsRepository;

  @override
  Future<List<Job>> build() async {
    _jobsRepository = ref.read(_jobsRepositoryProvider);
    return _jobsRepository.getAll();
  }

  Future<void> saveJob(Job job) async {
    await _jobsRepository.save(job);
    state = await AsyncValue.guard(() => _jobsRepository.getAll());
    ref.invalidate(recentJobsProvider);
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

    final jobs = state.value;

    // The returned row is already authoritative, so the changed entry is
    // swapped in place; reloading everything would only cost a round trip and
    // reset the list the user is looking at.
    state = jobs == null
        ? await AsyncValue.guard(_jobsRepository.getAll)
        : AsyncData([
            for (final existing in jobs)
              if (existing.id == updated.id) updated else existing,
          ]);

    ref.invalidate(recentJobsProvider);

    return updated;
  }

  Future<void> delete(Job job) async {
    await _jobsRepository.delete(job);
    state = await AsyncValue.guard(() => _jobsRepository.getAll());
    ref.invalidate(recentJobsProvider);
  }
}

final jobsProvider = AsyncNotifierProvider<JobsNotifier, List<Job>>(
  () => JobsNotifier(),
);

/// The newest jobs, for overview surfaces that only show a short list.
///
/// This is a server-side limited query rather than a slice of [jobsProvider],
/// so it stays cheap on accounts with a long history. [JobsNotifier] refreshes
/// it after every mutation, which is why no screen has to.
final recentJobsProvider = FutureProvider<List<Job>>((ref) {
  return ref.watch(_jobsRepositoryProvider).getRecent();
});
