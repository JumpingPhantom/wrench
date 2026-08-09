import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/sources/remote/remote_jobs_source.dart';
import 'package:wrench/core/data/sources/jobs_source.dart';
import 'package:wrench/core/data/repositories/jobs_repository.dart';

final _sourceProvider = Provider<JobsSource>((ref) {
  return RemoteJobsSource();
});

final _repositoryProvider = Provider<JobsRepository>((ref) {
  final source = ref.watch(_sourceProvider);
  return JobsRepository(source: source);
});

final jobsProvider = FutureProvider<List<Job>>((ref) {
  final repository = ref.watch(_repositoryProvider);
  return repository.getAll();
});

Future<void> saveJob(WidgetRef ref, Job job) async {
  final repository = ref.read(_repositoryProvider);
  await repository.save(job);
  ref.invalidate(jobsProvider);
}

String getNameById(WidgetRef ref, String id) {
  // TODO: finish this implementation
  return "";
}
